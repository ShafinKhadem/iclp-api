const express = require("express");
const pool = require("../config/pool");
const { isAuth } = require("../middlewares/auth");
const mcqQuizQuestions = require('../utils/mcqQuizQuestions');
const mcqQuizStart = require("../utils/mcqQuizStart");

const mcqRouter = express.Router({ mergeParams: true });

mcqRouter.use(express.json());

async function getSuggestion(topicId) {
    try {
        const query = await pool.query(
            'select topic_id as "topicId" ,name as "topicName",  challenge_id as "challengeId", difficulty, score, time from challenge_topics inner join challenges on challenge_topics.challenge_id = challenges.id inner join topics on topics.id = challenge_topics.topic_id where topic_id = $1 and category = \'mcq\' order by random() limit 1',
            [topicId]
        );
        if (query.rowCount == 0) throw new Error("No mcq under this topic");
        return query.rows[0];
    } catch (error) {
        throw error;
    }
}

async function getSuggestion2(examId) {
    try {
        const query = await pool.query(
            'select challenge_id as "challengeId", difficulty, score, time from challenges inner join invitations on challenges.id = invitations.challenge_id where exam_id = $1',
            [examId]
        );
        if (query.rowCount == 0) throw new Error("No mcq under this examId");
        return query.rows[0];
    } catch (error) {
        throw error;
    }
}

mcqRouter.route("/find2/:examId").get(isAuth, async (req, res, next) => {
    try {
        console.log("---------------find2/" + req.params.examId);
        obj = await getSuggestion2(req.params.examId);
        res.status(200).json(obj);
    } catch (error) {
        next(error);
    }
});

mcqRouter.route("/find/:topicId").get(isAuth, async (req, res, next) => {
    try {
        obj = await getSuggestion(req.params.topicId);
        res.status(200).json(obj);
    } catch (error) {
        next(error);
    }
});

mcqRouter.route("/start/:challengeId").post(isAuth, async (req, res, next) => {
    try {
        const questions = await mcqQuizStart(req.params.challengeId, req.user.id);
        res.status(200).json(questions);
    } catch (error) {
        next(error);
    }
});

mcqRouter.route("/submit/:resultId").post(isAuth, async (req, res, next) => {
    let endTime = new Date();
    try {
        result_row = await pool.query(
            'select challenge_id as "challengeId", user_id as "userId", time, score from challenge_results where id = $1',
            [req.params.resultId]
        );
        if (result_row.rowCount == 0)
            throw new Error("This exam has not initiated yet");
        result_row = result_row.rows[0];
        if (req.user.id !== result_row.userId)
            throw new Error("Different user submitting the answer");
        if (result_row.score !== -1)
            throw new Error("Already have submitted the answer");
        questions = await mcqQuizQuestions(result_row.challengeId);
        let startTime = new Date(result_row.time);
        gap = (endTime - startTime) / 1000;
        if (gap > questions.time + 5)
            throw new Error("Submission time is over");

        let score = 0;
        for (
            let i = 0;
            i < Math.min(questions.questions.length, req.body.answers.length);
            i++
        ) {
            if (req.body.answers[i] == null) continue;
            if (questions.questions[i].type === 1) {
                if (req.body.answers[i] == questions.questions[i].answer)
                    score += parseInt(questions.questions[i].points);
            } else {
                req.body.answers[i].sort();
                questions.questions[i].answer.sort();
                if (
                    req.body.answers[i].length ===
                    questions.questions[i].answer.length
                ) {
                    let j = 0;
                    for (; j < req.body.answers[i].length; j++) {
                        if (
                            req.body.answers[i][j] !=
                            questions.questions[i].answer[j]
                        )
                            break;
                    }
                    if (j === req.body.answers[i].length)
                        score += parseInt(questions.questions[i].points);
                }
            }
        }
        await pool.query(
            "update challenge_results set score = $1, details = $2 where id = $3",
            [score, JSON.stringify(req.body.answers), req.params.resultId]
        );
        questions.score = score;
        res.status(200).json(questions);
    } catch (error) {
        next(error);
    }
});

module.exports = mcqRouter;

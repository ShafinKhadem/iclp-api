const express = require("express");
const { body, query } = require("express-validator");
const pool = require("../config/pool");
const SQL = require("sql-template-strings");
const { isAuth } = require("../middlewares/auth");
const { validate, dbQuery, jsonDBQuery } = require("../util");

const dualRouter = express.Router({ mergeParams: true });
dualRouter.use(express.json());


dualRouter.route("/invitations").get(isAuth, async (req, res, next) => {
    const userid = req.query.userid;
    console.log("userid : ", userid, " last ", req.query.days, " days");
    const allowed_hours = req.query.days * 24;
    console.log("GET OK!");
    const sql = 
        SQL`
            SELECT  F.exam_id AS exam_id,
                    F.challenger_id AS challenger_id, 
                    F.name AS challenger_name,
                    F.challengee_id AS challengee_id,
                    U.name AS challengee_name,
                    F.topic_id AS topic_id,
                    topics.name AS topic_name,
                    F.status AS status,
                    TO_CHAR(F.last_accessed, 'yyyy-mm-dd hh12:mi:ss AM') AS last_accessed
            FROM (invitations AS I INNER JOIN users AS CRU ON (I.challenger_id = CRU.id)) AS F, topics, users AS U 
                WHERE F.topic_id = topics.id AND U.id = F.challengee_id 
                AND (F.challenger_id = ${userid} OR F.challengee_id = ${userid})
                AND EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - F.last_accessed)) < ${allowed_hours} * 60 * 60
                ORDER BY F.last_accessed DESC, F.exam_id;	
        `;
    jsonDBQuery(res, next, sql);
});

dualRouter.route("/invite").post(isAuth, 
    (req, res, next) => {
        try {
            const body = req.body;
            console.log(body.challengerId, '-', body.challengeeId, '-', body.topicId, '-', body.challengeId);
            jsonDBQuery(res, next,
                SQL`
                INSERT INTO invitations(challenger_id, challengee_id, topic_id, status, challenge_id, last_accessed)
                VALUES (${body.challengerId}, ${body.challengeeId}, ${body.topicId}, 'pending', ${body.challengeId}, CURRENT_TIMESTAMP)
                returning challenge_id id;
                `
            );
        } catch (error) {
            next(error);
        }
    }
);

dualRouter.route("/archive").post(isAuth, 
    (req, res, next) => {
        try {
            let outDayNum = 1;
            jsonDBQuery(res, next,
                SQL`
                UPDATE invitations
                SET status = 'archived'
                WHERE EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - last_accessed)) > ${outDayNum} * 24 * 60 * 60 / 2
                      AND status = 'pending';
                `
            );
        } catch (error) {
            next(error);
        }
    }
);

dualRouter.route("/accept").post(isAuth, 
    (req, res, next) => {
        try {
            const body = req.body;
            console.log(body.examId);
            jsonDBQuery(res, next,
                SQL`
                UPDATE invitations
                SET status = 'accepted', last_accessed = CURRENT_TIMESTAMP
                WHERE exam_id = ${body.examId} AND status = 'pending'
                returning challenge_id id;
                `
            );
        } catch (error) {
            next(error);
        }
    }
);

dualRouter.route("/reject").post(isAuth, 
    (req, res, next) => {
        try {
            const body = req.body;
            console.log(body.examId);
            jsonDBQuery(res, next,
                SQL`
                UPDATE invitations
                SET status = 'rejected', last_accessed = CURRENT_TIMESTAMP
                WHERE exam_id = ${body.examId} AND status = 'pending'
                returning challenge_id id;
                `
            );
        } catch (error) {
            next(error);
        }
    }
);

dualRouter.route("/complete").post(isAuth, 
    async (req, res, next) => {
        try {
            const body = req.body;
            console.log(body.examId);

            
            const query = await pool.query(
                "SELECT status FROM invitations WHERE exam_id = $1",
                [req.body.examId]
            );
            const oldStatus = query.rows[0].status;
            console.log("oldStatus", oldStatus)
            let newStatus = oldStatus;
            if (oldStatus === 'accepted')
                newStatus = 'half_completed';
            else if (oldStatus === 'half_completed')
                newStatus = 'full_completed';
            else {
                console.log('Error in changing completion status!');
            }
            console.log("newStatus", newStatus)
            jsonDBQuery(res, next,
                SQL`
                UPDATE invitations
                SET status = ${newStatus}, last_accessed = CURRENT_TIMESTAMP
                WHERE exam_id = ${body.examId} AND status = ${oldStatus}
                returning challenge_id id;
                `
            );
        } catch (error) {
            next(error);
        }
    }
);

// replicated from mcqRouter
async function getQuestions(challengeId) {
    try {
        const query = await pool.query(
            "select title, content, difficulty, score, time from challenges where id = $1 and category='mcq'",
            [challengeId]
        );
        if (query.rowCount == 0)
            throw new Error("No mcq with this challenge id");
        content = JSON.parse(query.rows[0].content);
        delete query.rows[0].content;
        query.rows[0].questions = content.questions;
        return query.rows[0];
    } catch (error) {
        throw error;
    }
}

dualRouter.route("/start").post(isAuth, async (req, res, next) => {
    try {
        questions = await getQuestions(req.query.challengeId);
        questions.questions.forEach(function (part, index) {
            this[index].answer = undefined;
        }, questions.questions);
        const query = await pool.query(
            "insert into challenge_results (id, challenge_id, user_id, time, score, exam_id, details)values (DEFAULT, $1, $2, DEFAULT, -1, $3, null) returning id",
            [req.query.challengeId, req.user.id, req.query.examId]
        );
        questions.resultId = query.rows[0].id;
        res.status(200).json(questions);
    } catch (error) {
        next(error);
    }
});


dualRouter.route("/result").get(isAuth, async (req, res, next) => {
    try {
        console.log(req.query.examId);
        const sql = 
            SQL`
                SELECT title AS problem_title,
                    content as question_answer_set,
                    user_id as participant_id,
                    name as participant_name,
                    challenge_results.score as participant_mark,
                    details as participant_submission
                FROM challenges, users, challenge_results
                WHERE users.id = challenge_results.user_id
                    AND challenge_results.challenge_id = challenges.id
                    AND challenge_results.exam_id = ${req.query.examId};
            `;
        jsonDBQuery(res, next, sql);
    } catch (error) {
        next(error);
    }
});


module.exports = dualRouter;
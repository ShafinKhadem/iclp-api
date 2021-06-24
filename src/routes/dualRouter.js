const express = require("express");
const { body } = require("express-validator");
const pool = require("../config/pool");
const SQL = require("sql-template-strings");
const { isAuth } = require("../middlewares/auth");
const { validate, dbQuery, jsonDBQuery } = require("../util");

const dualRouter = express.Router({ mergeParams: true });
dualRouter.use(express.json());


dualRouter.route("/invitations").get(isAuth, async (req, res, next) => {
    const userid = req.query.userid;
    console.log("userid : ", userid);
    const allowed_hours = 24;
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

	// --generate new type and update status column type (no need to run anymore)
	// select enum_range(null::dual_status);
	// ALTER TABLE invitations
	// ALTER COLUMN status TYPE dual_status USING status::dual_status;

	// --delete previous rows and set PK to start from 1
	// DELETE FROM invitations;
	// SELECT setval('invitations_id_seq', 1, false); 

	// --insert new invitation and visualise
    // INSERT INTO invitations(challenger_id, challengee_id, topic_id, status, challenge_id, last_accessed)
    // VALUES (2, 3, 1, 'accepted', 1, NULL, CURRENT_TIMESTAMP);
	// SELECT * FROM invitations;

module.exports = dualRouter;
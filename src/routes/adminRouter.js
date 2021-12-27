const appRoot = require("app-root-path");
const express = require("express");
const { isAdmin } = require("../middlewares/auth");
const { body } = require("express-validator");
const SQL = require("sql-template-strings");
const { dbQuery, jsonDBQuery } = require("../utils/dbUtils");

const adminRouter = express.Router({ mergeParams: true });
adminRouter.use(express.json(), isAdmin);

adminRouter.route("/create-problem").post(
    async (req, res, next) => {
        const body = req.body;
        const result = await dbQuery(
            SQL`
            INSERT INTO public.challenges (id, title, content, category, difficulty, score)
            VALUES (DEFAULT, ${body.title}, ${body.content}, 'code', ${body.difficulty}, ${body.score})
            returning id;
            `
        );
        if (result instanceof Error) {
            next(result);
        } else {
            jsonDBQuery(
                res,
                next,
                SQL`
                INSERT INTO challenge_topics (challenge_id, topic_id)
                VALUES (${result[0].id}, ${body.topicid})
                returning challenge_id id;
                `
            );
        }
    }
);

adminRouter.route("/add-quiz").post(
    async (req, res, next) => {
        const body = req.body;
        const result = await dbQuery(
            SQL`
                INSERT INTO challenges (id, title, content, category, difficulty, score, time)
                VALUES (DEFAULT, ${body.title}, ${body.content}, 'mcq', ${body.difficulty}, ${body.score}, ${body.time})
                returning id;
                `
        );
        if (result instanceof Error) {
            next(result);
        } else {
            jsonDBQuery(
                res,
                next,
                SQL`
                INSERT INTO challenge_topics (challenge_id, topic_id)
                VALUES (${result[0].id}, ${body.topic})
                returning challenge_id id;
                `
            );
        }
    }
);

module.exports = adminRouter;

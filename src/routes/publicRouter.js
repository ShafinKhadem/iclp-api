const express = require("express");
const { body } = require("express-validator");
const SQL = require("sql-template-strings");
const { validate, dbQuery, jsonDBQuery } = require("../util");

const publicRouter = express.Router({ mergeParams: true });
publicRouter.use(express.json());


publicRouter.route("/").get((req, res, next) => {
    res.status(200).json({ message: "into public" });
});

publicRouter.route("/problem-topics").get(
    (req, res, next) => {
        jsonDBQuery(res, next, SQL`select * from topics`);
    }
);

publicRouter.route("/problems/:topic").get(
    (req, res, next) => {
        jsonDBQuery(res, next,
            SQL`
            select *
            from challenges
            where id in
                  (
                      select challenge_id
                      from challenge_topics
                      where topic_id in
                            (
                                select id
                                from topics
                                where name = ${req.params.topic}
                            )
                  )
              and category = 'code';
            `);
    }
)

publicRouter.route("/challenge/:id").get(
    async (req, res, next) => {
        jsonDBQuery(res, next,
            SQL`
            select *
            from challenges where id = ${req.params.id};
            `);
    }
)

publicRouter.route("/solo/:topicid").get(
    (req, res, next) => {
        jsonDBQuery(res, next,
            SQL`
            select *
            from challenges
            where id in
                  (
                      select challenge_id
                      from challenge_topics
                      where topic_id = ${req.params.topicid}
                  ) and category = 'mcq';
            `);
    }
)

publicRouter.route("/submissions/:problemid").get(
    (req, res, next) => {
        jsonDBQuery(res, next,
            SQL`
            select *
            from challenge_results
            where challenge_id = ${req.params.problemid};
            `);
    }
)

module.exports = publicRouter;

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
            select q1.*, coalesce(q2.score, 0) score
            from (
                     select id, title, difficulty, score as maxscore
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
                       and category = 'code') q1
                     left join

                 (select challenge_id, max(score) score
                  from challenge_results
                  where user_id = ${req.query.userid}
                  group by challenge_id) q2 on challenge_id = id;
            `);
    }
)

publicRouter.route("/user/:id").get(

    async (req, res, next) => {
        const { params, query, body, user, file } = req;

        jsonDBQuery(res, next,
            SQL`
            select to_jsonb(q1) - 'hash' - 'salt' as user
            from (
                     select *
                     from users
                     where id = ${params.id}
                 ) q1;
            `);
    }
);

publicRouter.route("/problem/:id").get(

    async (req, res, next) => {
        const { params, query, body, user, file } = req;

        jsonDBQuery(res, next,
            SQL`
            select *
            from challenges
            where id = ${params.id};
            `);
    }
);

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
            select id, user_id, score, details, time
            from challenge_results
            where challenge_id = ${req.params.problemid}
            order by time desc;
            `);
    }
)

publicRouter.route("/best/:userid").get(

    async (req, res, next) => {
        const { params, query, body, user, file } = req;
        const sql = SQL`
            select q1.*, q2.max_score
            from (select challenge_id, score, min(time) as time
                  from challenge_results
                  where (challenge_id, score) in (
                      select challenge_id, max(score) score
                      from challenge_results
                      where user_id = ${params.userid}
            `;
        if (query.topicid !== undefined && query.topicid !== '0') {
            sql.append(`and challenge_id in (select challenge_id from challenge_topics where topic_id = ${query.topicid})`);
        }
        if (query.problemid !== undefined) {
            sql.append(` and challenge_id = ${query.problemid} `);
        }
        sql.append(`
                      group by challenge_id)
                  group by challenge_id, score) as q1
                     join (
                select id, score max_score
                from challenges
            ) q2 on q1.challenge_id = q2.id order by time;
            `);
        jsonDBQuery(res, next, sql);
    }
);

publicRouter.route("/rank").get(

    async (req, res, next) => {
        const { params, query, body, user, file } = req;
        const sql = SQL`
            select *
            from (
                     select *, rank() over (order by total_score desc)
                     from (
                              select user_id, sum(score) total_score
                              from (
                                       select user_id, max(score) score
                                       from challenge_results
            `;
        if (query.topicid !== undefined && query.topicid !== '0') {
            sql.append(`where challenge_id in (select challenge_id from challenge_topics where topic_id = ${query.topicid})`);
        }
        sql.append(`
                                       group by user_id, challenge_id) q1
                              group by user_id) q2) q3
            `);
        if (query.userid !== undefined) {
            sql.append(`where user_id = ${query.userid}`);
        }
        sql.append(';');
        jsonDBQuery(res, next, sql);
    }
);

module.exports = publicRouter;

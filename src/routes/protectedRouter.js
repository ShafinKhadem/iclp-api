const express = require("express");
const { body } = require("express-validator");
const SQL = require("sql-template-strings");
const { validate, dbQuery, jsonDBQuery } = require("../util");
const isAuth = require("../middlewares/auth");

const protectedRouter = express.Router({ mergeParams: true });
protectedRouter.use(express.json());


protectedRouter.route("/").get(isAuth, (req, res, next) => {
    res.status(200).json({ message: "into protected", user: req.user });
});

protectedRouter.route("/submit").post(
    async (req, res, next) => {
        console.log(`submission received ${req.body.submission}`);
        mark = 5;
        const result = await dbQuery(
            SQL`
            insert into challenge_results(challenge_id, user_id, mark)
            values (${req.body.challenge_id}, ${req.user.id}, ${mark});
            `
        );
        if (result instanceof Error) {
            next(result);
        } else {
            res.status(200).json({ mark: mark });
        }
    }
)

module.exports = protectedRouter;

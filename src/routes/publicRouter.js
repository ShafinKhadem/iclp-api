const express = require("express");
const { body } = require("express-validator");
const SQL = require("sql-template-strings");
const { validate, jsonDBQuery } = require("../util");

const publicRouter = express.Router({ mergeParams: true });
publicRouter.use(express.json());


publicRouter.route("/").get((req, res, next) => {
    res.status(200).json({ message: "into public" });
});

publicRouter.route("/problem-topics").get(
    (req, res, next) => {
        validate(req, next, "invalid request");
        jsonDBQuery(res, next, SQL`select * from topics`);
    }
);

module.exports = publicRouter;

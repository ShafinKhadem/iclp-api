const express = require("express");
const { body } = require("express-validator");
const SQL = require("sql-template-strings");
const { validate, jsonDBQuery } = require("../util");
const isAuth = require("../middlewares/auth");

const protectedRouter = express.Router({ mergeParams: true });
protectedRouter.use(express.json());


protectedRouter.route("/").get(isAuth, (req, res, next) => {
    res.status(200).json({ message: "into protected" });
});

module.exports = protectedRouter;

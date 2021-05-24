const express = require("express");
const isAuth = require("../middlewares/auth");

const publicRouter = express.Router({ mergeParams: true });

publicRouter.use(express.json());

publicRouter.route("/").get((req, res, next) => {
    res.status(200).json({ message: "into public" });
});
publicRouter.route("/problem-topics").get((req, res, next) => {
    res.status(200).json(['python', 'cpp', 'java']);
});

module.exports = publicRouter;

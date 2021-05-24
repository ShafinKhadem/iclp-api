const express = require("express");
const isAuth = require("../middlewares/auth");

const protectedRouter = express.Router({ mergeParams: true });

protectedRouter.use(express.json());

protectedRouter.route("/").get(isAuth, (req, res, next) => {
    res.status(200).json({ message: "into protected" });
});

module.exports = protectedRouter;

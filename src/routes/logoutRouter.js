const express = require("express");
const { isAuth } = require("../middlewares/auth");

const logoutRouter = express.Router({ mergeParams: true });

logoutRouter.use(express.json());

logoutRouter.route("/").get(isAuth, (req, res, next) => {
    console.log(`${req.user.name}(id:${req.user.id}) has just logged out`);
    req.logout();
    res.status(200).json({ message: "logged out successfully" });
});

module.exports = logoutRouter;

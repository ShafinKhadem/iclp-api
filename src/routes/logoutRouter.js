const express = require("express");
const { isAuth } = require("../middlewares/auth");
const SQL = require("sql-template-strings");
const { dbQuery } = require("../util");

const logoutRouter = express.Router({ mergeParams: true });

logoutRouter.use(express.json());

logoutRouter.route("/").get(isAuth, async (req, res, next) => {
    try {
        let uid = req.user.id;
        console.log("-------------- user: ", uid , " is logging out");
        const result = await dbQuery(
            SQL`
                UPDATE users 
                SET is_active = false
                WHERE id = ${uid}
                returning id;
                `
        );
        if (result instanceof Error) {
            next(result);
        } 
    } catch (error) {
        next(error);
    }
    console.log(`${req.user.name}(id:${req.user.id}) has just logged out`);
    req.logout();
    res.status(200).json({ message: "logged out successfully" });
});

// Now we remove user active status
logoutRouter.route("/")
.all(async (req, res, next) => {
    try {
        const uid = req.user.id;
        console.log("-------------- user: ", uid , " is logging out");
        const result = await dbQuery(
            SQL`
                UPDATE users 
                SET is_active = false
                WHERE id = ${uid}
                returning id;
                `
        );
        if (result instanceof Error) {
            next(result);
        } 
    } catch (error) {
        next(error);
    }
});

module.exports = logoutRouter;

const express = require("express");
const { isAuth } = require("../middlewares/auth");
const SQL = require("sql-template-strings");
const { dbQuery } = require("../utils/dbUtils");

const logoutRouter = express.Router({ mergeParams: true });

logoutRouter.use(express.json());

logoutRouter.route("/").get(isAuth, async (req, res, next) => {
    try {
        let uid = req.user.id;
        // Now we remove user active status
        console.log("-------------- user: ", uid, " is logging out");
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

module.exports = logoutRouter;

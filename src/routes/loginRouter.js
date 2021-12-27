const express = require("express");
const passport = require("passport");
const { body, validationResult } = require("express-validator");
const { isAuth } = require("../middlewares/auth");
const SQL = require("sql-template-strings");
const { dbQuery } = require("../utils/dbUtils");
require("../config/passport");

const loginRouter = express.Router({ mergeParams: true });

loginRouter.use(express.json());

loginRouter.route("/")
    .post(
        body("email").isEmail().withMessage("Provided email is not valid"),
        passport.authenticate("local", { failureFlash: true }),
        (req, res, next) => {
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                const err = new Error("login failed");
                err.reasons = errors.errors.map((e) => e.msg);
                err.statusCode = 400;
                next(err);
            } else {
                res.statusCode = 200;
                res.json({ message: "login successful", user: req.user });
                next();
            }
        }
    );

// Now we add user login-time and active status
loginRouter.route("/")
    .all(isAuth, async (req, res, next) => {
        try {
            const uid = req.user.id;
            console.log("-------------- user: ", uid, " just logged in");
            const result = await dbQuery(
                SQL`
                    UPDATE users 
                    SET is_active = true, last_access = CURRENT_TIMESTAMP
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



module.exports = loginRouter;

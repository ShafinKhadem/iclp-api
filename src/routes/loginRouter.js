const express = require("express");
const passport = require("passport");
const { body, validationResult } = require("express-validator");
require("../config/passport");

const loginRouter = express.Router({ mergeParams: true });

loginRouter.use(express.json());

loginRouter
    .route("/")
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
            }
        }
    );

module.exports = loginRouter;

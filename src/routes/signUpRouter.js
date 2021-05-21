const express = require("express");
const pool = require("../config/pool");
const { body, validationResult } = require("express-validator");
const bcrypt = require("bcrypt");
const signUpRouter = express.Router();

signUpRouter.use(express.json());

signUpRouter.route("/").post(
    body("name")
        .isLength({ min: 4, max: 25 })
        .withMessage("Name character should be between 4 to 25"),
    body("email").isEmail().withMessage("Provided email is not valid"),
    body("email").custom(async (email, { req }) => {
        try {
            const query = await pool.query(
                "SELECT * FROM USERS WHERE email = $1",
                [email]
            );
            if (query.rowCount == 0) return true;
            throw new Error("Email already exists");
        } catch (error) {
            throw error;
        }
    }),
    body("password")
        .isStrongPassword()
        .withMessage("Password is not strong enough"),
    body("confirm_password").custom((confirm_password, { req }) => {
        if (confirm_password !== req.body.password) {
            throw new Error("Confirmation password does not match");
        }
        return true;
    }),
    async (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            const err = new Error("signup failed");
            err.reasons = errors.errors.map((e) => e.msg);
            err.statusCode = 400;
            next(err);
        } else {
            try {
                const salt = await bcrypt.genSalt();
                const hashedPassword = await bcrypt.hash(
                    req.body.password,
                    salt
                );
                pool.query(
                    "INSERT INTO users(name, hash, email, salt) VALUES ($1, $2, $3, $4)",
                    [req.body.name, hashedPassword, req.body.email, salt]
                );
                res.statusCode = 201;
                res.json({ msg: "Signup successful" });
            } catch (error) {
                error.msg = "signup failed";
                err.reasons = ["server error"];
                next();
            }
        }
    }
);

module.exports = signUpRouter;
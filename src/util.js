const { validationResult } = require("express-validator");
const pool = require("./config/pool");

function validate(req, next, errorMessage) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const err = new Error(errorMessage);
        err.reasons = errors.errors.map((e) => e.msg);
        err.statusCode = 400;
        next(err);
    }
}

async function jsonDBQuery(res, next, sqlTemplateString) {
    try {
        const result = await pool.query(sqlTemplateString);
        res.status(200).json(result.rows);
    } catch (e) {
        // log the actual error message only in server side.
        console.log(e.message);
        const err = new Error("operation failed");
        err.reasons = ["database error"];
        next(err);
    }
}

module.exports = { validate, jsonDBQuery };

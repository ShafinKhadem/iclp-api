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

async function dbQuery(sqlTemplateString) {
    try {
        const result = await pool.query(sqlTemplateString);
        return result.rows;
    } catch (e) {
        // log the actual error message only in server side.
        console.log(e.message);
        const err = new Error("operation failed");
        err.reasons = ["database error"];
        return err;
    }
}

async function jsonDBQuery(res, next, sqlTemplateString) {
    const result = await dbQuery(sqlTemplateString);
    if (result instanceof Error) {
        next(result);
    } else {
        res.status(200).json(result);
    }
}

module.exports = { validate, dbQuery, jsonDBQuery };

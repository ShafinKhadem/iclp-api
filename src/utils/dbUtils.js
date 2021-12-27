const pool = require("../config/pool");

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

module.exports = { dbQuery, jsonDBQuery };

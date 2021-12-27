const { validationResult } = require("express-validator");

function validate(req, next, errorMessage) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const err = new Error(errorMessage);
        err.reasons = errors.errors.map((e) => e.msg);
        err.statusCode = 400;
        next(err);
    }
}

module.exports = validate;
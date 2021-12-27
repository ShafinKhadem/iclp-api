const pool = require("../config/pool");

async function mcqQuizQuestions(challengeId) {
    const query = await pool.query(`
        select title, content->'questions' as questions, difficulty, score, time from challenges
        where id = $1 and category='mcq'`,
        [challengeId]
    );
    if (query.rowCount == 0)
        throw new Error("No mcq with this challenge id");
    return query.rows[0];
}

module.exports = mcqQuizQuestions;
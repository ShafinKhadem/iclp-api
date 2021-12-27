const pool = require("../config/pool");
const mcqQuizQuestions = require("./mcqQuizQuestions");

async function mcqQuizStart(challenge_id, user_id, exam_id) {
    questions = await mcqQuizQuestions(challenge_id);
    questions.questions.forEach(function (part, index) {
        this[index].answer = undefined;
    }, questions.questions);
    const query = await pool.query(`
        insert into challenge_results (id, challenge_id, user_id, time, score, exam_id, details)
        values (DEFAULT, $1, $2, DEFAULT, -1, $3, null)
        returning id`,
        [challenge_id, user_id, exam_id]
    );
    questions.resultId = query.rows[0].id;
    return questions;
}

module.exports = mcqQuizStart;
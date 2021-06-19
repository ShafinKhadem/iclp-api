const passport = require("passport");
const LocalStrategy = require("passport-local").Strategy;
const pool = require("../pool");
const bcrypt = require("bcrypt");

const customFields = {
    usernameField: "email",
    passwordField: "password",
};

const verifyCallback = async (username, password, done) => {
    try {
        const query = await pool.query("SELECT * FROM USERS WHERE email = $1", [
            username,
        ]);
        if (query.rowCount !== 1) return done(null, false);
        const { hash, salt, ...userObj } = query.rows[0];
        const hashedPassword = await bcrypt.hash(password, salt);
        if (hashedPassword !== hash) return done(null, false);
        return done(null, userObj);
    } catch (err) {
        return done(null, false);
    }
};

const strategy = new LocalStrategy(customFields, verifyCallback);

passport.use(strategy);

passport.serializeUser((user, done) => {
    done(null, user.id);
});

passport.deserializeUser(async (userId, done) => {
    const query = await pool.query("SELECT * FROM users WHERE id = $1", [
        userId,
    ]);
    if (query.rowCount == 1) {
        const { hash, salt, ...userObj } = query.rows[0];
        return done(null, userObj);
    }
});

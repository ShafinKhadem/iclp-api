require("dotenv").config();
const express = require("express");
const morgan = require("morgan");
const session = require("express-session");
const pgSession = require("connect-pg-simple")(session);
const pool = require("./config/pool");
const passport = require("passport");
const loginRouter = require("./routes/loginRouter");
const signUpRouter = require("./routes/signUpRouter");
const logoutRouter = require("./routes/logoutRouter");
const protectedRouter = require("./routes/protectedRouter");

const PORT = process.env.API_PORT || 5000;

const app = express();

app.use(morgan("dev"));
app.use(express.json());

app.use(
    session({
        store: new pgSession({
            pool: pool,
            tableName: "session_store",
        }),
        secret: process.env.COOKIE_SECRET,
        resave: true,
        saveUninitialized: true,
        cookie: { maxAge: 30 * 24 * 60 * 60 * 1000 },
    })
);

require("./config/passport");
app.use(passport.initialize());
app.use(passport.session());

app.use((req, res, next) => {
    console.log(req.body);
    next();
});

app.use("/login", loginRouter);
app.use("/signup", signUpRouter);
app.use("/logout", logoutRouter);
app.use("/protected", protectedRouter);
app.all("*", (req, res, next) => {
    err = new Error("Not supported yet");
    err.statusCode = 400;
    next(err);
});
app.use((err, req, res, next) => {
    res.statusCode = err.statusCode || 500;
    res.json({
        error: {
            message: err.message,
            reasons: err.reasons,
        },
    });
});

//Safety measure if server crashes

const server = app.listen(PORT, () => {
    console.log(`icpl-api is running at port: ${PORT}`);
});

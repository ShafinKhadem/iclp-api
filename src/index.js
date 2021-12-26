require("dotenv").config();
require("util").inspect.defaultOptions.depth = null;
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
const publicRouter = require("./routes/publicRouter");
const adminRouter = require("./routes/adminRouter");
const mcqRouter = require("./routes/mcqRouter");
const dualRouter = require("./routes/dualRouter");
var cors = require("cors");

const PORT = process.env.PORT || process.env.API_PORT || 5000;

const app = express();

const corsOptions = {
    origin: [process.env.FRONTEND_ROOT_URL, "http://localhost:8080"],
    credentials: true,
    optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(morgan("dev"));
app.use(express.json());
app.set('trust proxy', 1);
app.use(
    session({
        store: new pgSession({
            pool: pool,
            tableName: "session_store",
        }),
        secret: process.env.COOKIE_SECRET,
        resave: true,
        saveUninitialized: false,
        cookie: {
            sameSite: process.env.NODE_ENV === "production" ? 'none' : 'lax', // must be 'none' to enable cross-site delivery
            secure: process.env.NODE_ENV === "production", // must be explicitly specified if sameSite='none'
            maxAge: 30 * 24 * 60 * 60 * 1000
        },
    })
);

require("./config/passport");
app.use(passport.initialize());
app.use(passport.session());

app.use((req, res, next) => {
    console.log({ method: req.method, params: req.params, body: req.body });
    next();
});

app.use("/login", loginRouter);
app.use("/signup", signUpRouter);
app.use("/logout", logoutRouter);
app.use("/protected", protectedRouter);
app.use("/public", publicRouter);
app.use("/admin", adminRouter);
app.use("/mcq", mcqRouter);
app.use("/dual", dualRouter);
app.all("*", (req, res, next) => {
    err = new Error("Not supported yet");
    err.statusCode = 400;
    next(err);
});
app.use((err, req, res, next) => {
    if (err) {
        console.error(err.stack);
    }
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
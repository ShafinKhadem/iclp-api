const express = require("express");
const { isAuth } = require("../middlewares/auth");
const appRoot = require("app-root-path");
const { body } = require("express-validator");
const SQL = require("sql-template-strings");
const { dbQuery, jsonDBQuery } = require("../utils/dbUtils");
const { spawn } = require("child_process");
const fs = require("fs");
const fsPromises = require("fs/promises");
const tmpDir = appRoot + "/tmp";
if (!fs.existsSync(tmpDir)) {
    fs.mkdirSync(tmpDir);
}
const multer = require("multer");
const tmpDirMulter = multer({ dest: tmpDir, limits: { fileSize: 100 * 1024 * 8 } });

const protectedRouter = express.Router({ mergeParams: true });
protectedRouter.use(express.json(), isAuth);

protectedRouter.route("/").get((req, res, next) => {
    res.status(200).json({ message: "into protected", user: req.user });
});

async function spawnChild(
    command,
    args,
    seconds = 30,
    outputFilePath = 'ignore',
    inputFilePath = 'ignore',
    input
) {
    const inputFileIsPath = inputFilePath !== 'ignore' && inputFilePath !== 'pipe';
    const outputFileIsPath = outputFilePath !== 'ignore' && outputFilePath !== 'pipe';
    if (inputFileIsPath) {
        inputFilePath = await fsPromises.open(inputFilePath, 'r');
    }
    if (outputFileIsPath) {
        outputFilePath = await fsPromises.open(outputFilePath, 'w');
    }
    const child = spawn(command, args, {
        stdio: [
            inputFilePath,
            outputFilePath,
            'pipe'
        ],
    });
    if (inputFileIsPath) {
        inputFilePath.close();
    }
    if (outputFileIsPath) {
        outputFilePath.close();
    }

    if (inputFilePath === 'pipe') {
        child.stdin.write(input);
        child.stdin.end('\n');
        // NOTE: ending newline is must to denote end of last token. It's stdin, not a file with EOF.
    }

    let err = "";
    child.stderr.on("data", (data) => {
        err += data;
    });

    child.on("error", (error) => {
        console.error(`error: ${error.message}`);
    });

    const exitCode = await new Promise((resolve, reject) => {
        const timeout = setTimeout(() => {
            console.log("Timeout");
            try {
                process.kill(child.pid, "SIGKILL");
            } catch (e) {
                console.error("Cannot kill process");
                console.error(e);
            }
            resolve(1);
        }, seconds * 1000);
        child.on("close", (code) => {
            clearTimeout(timeout);
            resolve(code);
        });
    });
    return { exitCode, err };
}

async function judge(problemid, file) {
    // TODO: add memory limit and prevent thread creation
    let correct = true,
        details = "correct answer";
    const executable = `${tmpDir}/${file.filename}_exec`;
    const { exitCode, err } = await spawnChild("g++", [
        "-x",
        "c++",
        file.path,
        "-o",
        executable,
    ]);
    if (exitCode !== 0) {
        console.error(err);
        correct = false;
        details = "compilation error";
    } else {
        const time_limit = 1 // seconds
        let result = await dbQuery(
            SQL`
            select content->'tests' as tests
            from challenges
            where id = ${problemid};
            `
        );
        if (result instanceof Error) {
            next(result);
        }

        const [{ tests }] = result;
        for (const [index, test] of tests.entries()) {
            console.log(test);
            const run = `${executable}_${index}`;
            const out = `${run}.out`;
            const { exitCode } = await spawnChild(
                executable,
                [],
                time_limit,
                out,
                'pipe',
                test.input
            );
            if (exitCode !== 0) {
                console.log(`exitcode ${exitCode}`);
                correct = false;
                details = `time limit (${time_limit} second) exceeded`;
                // TODO: run time error
            } else {
                const output = await fsPromises.readFile(out, 'utf8');
                console.log(
                    `output:\n${output}\nerror:\n${err}\n`
                );
                if (output !== test.output) {
                    correct = false;
                    details = "wrong answer";
                }
            }
        }
    }
    return { correct, details };
}

protectedRouter.route("/submit").post(
    // NOTE: multer.single('f') discards all fields after f
    tmpDirMulter.single("submission"),
    async (req, res, next) => {
        const { params, query, body, user, file } = req;
        console.log(`submission received ${file.path}`);
        const score_promise = dbQuery(
            SQL`
            select score
            from challenges
            where id = ${body.problemid};
            `
        );
        const judge_promise = judge(body.problemid, file)
        let result = await score_promise;
        if (result instanceof Error) {
            next(result);
        }
        const maxScore = result[0].score;
        const { correct, details } = await judge_promise;
        const score = correct ? maxScore : 0;
        result = await dbQuery(
            SQL`
            insert into challenge_results(challenge_id, user_id, score, details)
            values (${body.problemid}, ${user.id}, ${score}, ${details});
            `
        );
        if (result instanceof Error) {
            next(result);
        }
        res.status(200).json({ score, details });
    }
);

module.exports = protectedRouter;

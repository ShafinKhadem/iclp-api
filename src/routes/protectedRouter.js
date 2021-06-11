const express = require("express");
const isAuth = require("../middlewares/auth");
const appRoot = require('app-root-path');
const { body } = require("express-validator");
const SQL = require("sql-template-strings");
const { validate, dbQuery, jsonDBQuery } = require("../util");
const { spawn } = require("child_process");
const fs = require('fs');
const fsPromises = require('fs/promises');
const tmpDir = appRoot + '/tmp';
if (!fs.existsSync(tmpDir)) {
    fs.mkdirSync(tmpDir);
}
const multer = require('multer');
const upload = multer({ dest: appRoot + '/uploads' });


const protectedRouter = express.Router({ mergeParams: true });
protectedRouter.use(express.json());


protectedRouter.route("/").get(isAuth, (req, res, next) => {
    res.status(200).json({ message: "into protected", user: req.user });
});


async function spawnChild(command, args, outputFilePath = tmpDir + '/out.log', inputFilePath, seconds = 60) {
    const out = fs.openSync(outputFilePath, 'w');
    const child = spawn(command, args, {
        stdio: [inputFilePath ? fs.openSync(inputFilePath, 'r') : 'ignore', out, 'pipe']
    });

    let err = '';
    child.stderr.on('data', data => {
        err += data;
    });

    child.on('error', error => {
        console.error(`error: ${error.message}`);
    });

    const exitCode = await new Promise((resolve, reject) => {
        const timeout = setTimeout(() => {
            console.log('Timeout');
            try {
                process.kill(child.pid, 'SIGKILL');
            } catch (e) {
                console.error('Cannot kill process');
                console.error(e);
            }
            resolve(1);
        }, seconds * 1000);
        child.on('close', code => { clearTimeout(timeout); resolve(code); });
    });
    return { exitCode, err };
};

async function judge(problemid, file) {
    const executable = `${tmpDir}/${file.filename}_exec`;
    const { exitCode, err } = await spawnChild("g++", ['-x', 'c++', file.path, '-o', `${executable}`]);
    let correct = true, details = "congratulations!";
    if (exitCode !== 0) {
        console.error(err);
        correct = false;
        details = "compilation error";
    } else {
        const problemDir = `${appRoot}/uploads/${problemid}`;
        const testDir = problemDir + '/tests';
        const files = await fsPromises.readdir(testDir);
        for (const file of files) {
            const out = `${tmpDir}/${file.filename}_${file}.out`, inp = `${testDir}/${file}`;
            const { exitCode } = await spawnChild(`${executable}`, [], out, inp, 1);
            if (exitCode !== 0) {
                correct = false;
                details = 'time limit (1 second) exceeded';
            } else {
                const { exitCode, err } = await spawnChild(problemDir + '/checker', [inp, out]);
                console.log(`test: ${file}, exitcode: ${exitCode}, error: ${err}`);
                if (exitCode !== 0) {
                    console.error(err);
                    correct = false;
                    details = "wrong answer";
                }
            }
        }
    }
    return { correct, details };
};


protectedRouter.route("/submit").post(
    // NOTE: multer.single('f') discards all fields after f
    upload.single('submission'),
    isAuth,
    async (req, res, next) => {
        const { params, query, body, user, file } = req;
        console.log(`submission received ${file.path}`);
        let result = await dbQuery(
            SQL`
            select score
            from challenges
            where id = ${body.problemid};
            `
        );
        if (result instanceof Error) {
            next(result);
        }
        const maxScore = result[0].score;
        const { correct, details } = await judge(body.problemid, file);
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

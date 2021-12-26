# iclp-api

### How to run

-   setup database following [db/README.md](db/README.md)

-   change .env to appropriate values.

-   Make sure that node version is 14 (latest stable).

-   Install all dependencies

    ```
    npm install
    ```

-   Run dev server

    ```
    npm run dev
    ```

### Documentations of some used npm packages

-   [express-validator](https://express-validator.github.io/docs/index.html)
-   [passport-local](https://www.passportjs.org/packages/passport-local/)
-   [node-postgres](https://node-postgres.com/)
-   [sql-template-strings](https://www.npmjs.com/package/sql-template-strings)
-   [app-root-path](https://www.npmjs.com/package/app-root-path)
-   [multer](https://www.npmjs.com/package/multer) for file upload

### NOTES

- Cross site cookie (third-party cookies) is problematic. I couldn't find any value of {sameSite, secure} for cookie configuration which works both in production (https) and development (http). That's why if you run `npm run start` or with `NODE_ENV=production` environment, authentication will fail after successful login.

### heroku deployment

- [x] add `"start": "NODE_ENV=production node src/index.js",` in scripts of package.json.

- [x] Heroku assigns arbitrary port to each application which is saved in `PORT` environment variable, so use `process.env.PORT ||` before `process.env.API_PORT` in src/index.js

- [x] Heroku assigns DATABASE_URL environment variable appropriately, also we need to allow unauthorized ssl. So add `connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false, }` to new Pool({...}) in src/config/pool/index.js

- [x] Enable proxy by adding `app.set("trust proxy", 1);` in src/index.js

- [x] Add FRONTEND_ROOT_URL in .env, add process.env.FRONTEND_ROOT_URL origin in corsOptions in src/index.js.

- [x] Enable cross site https cookies by adding the following to app.use(Session({cookie:{...}}):

```javascript
sameSite: process.env.NODE_ENV === "production" ? 'none' : 'lax', // must be 'none' to enable cross-site delivery
secure: process.env.NODE_ENV === "production", // must be explicitly specified if sameSite='none', denotes whether allow only https
```

- [x] Commit these changes.

- [ ] Run the following only once.
```bash
APP_NAME=<HEROKU_APP_NAME>
FRONTEND_ROOT_URL=<FRONTEND_ROOT_URL>
heroku login
heroku create $APP_NAME && heroku addons:create heroku-postgresql:hobby-dev
heroku config:set -a $APP_NAME FRONTEND_ROOT_URL=$FRONTEND_ROOT_URL COOKIE_SECRET=$(openssl rand -base64 32) NODE_ENV=production
```

- [ ] run `git push heroku HEAD:main --force` to deploy

- [ ] run the following everytime you wanna restore your DB from db/dump.sql.
```bash
APP_NAME=<HEROKU_APP_NAME>
heroku pg:reset --confirm $APP_NAME
DATABASE_URL=$(heroku config:get DATABASE_URL)
psql -f db/dump.sql $DATABASE_URL && echo "restored $DATABASE_URL from db/dump.sql"
```

run `heroku ps:scale web=0` to shut down the heroku app, run `heroku ps:scale web=1` for starting again.

### Endpoints:

-   `/login`  
    Request body:

    ```javascript
    {
        "email": String,
        "password" : String,
    }
    ```

-   `/signup`  
    Request body:

    ```javascript
    {
        "name": String,
        "email": String,
        "password": String,
        "confirmed_password": String,
    }
    ```

-   `/mcq/find2/:examId`  
    Gets the accociated mcq challenge related to this particular examId<br/>
    Request body: _does not require_ <br/>
    Response body:

    ```javascript
    {
        "challengeId" : String,
        "difficulty" : String,
        "score" : Number,
        "time" : Number
    }
    ```

-   `/mcq/find/:topicID`  
    Randomly gets a mcq challenge under this topic.<br/>
    Request body: _does not require_ <br/>
    Response body:

    ```javascript
    {
        "topicId": String,
        "topicName" : String,
        "challengeId" : String,
        "difficulty" : String,
        "score" : Number,
        "time" : Number
    }
    ```

-   `/mcq/start/:challengeId`  
    User starts a challenge with this challengeId. Timer starts as soon as user hits this endpoint.<br/>
    Request body: _does not require_ <br />
    Response body: Here, `questions` object does not contain answers.

    ```javascript
    {
        "title": String,
        "challengeId" : String,
        "difficulty" : String,
        "score" : Number,
        "time" : Number.
        "questions": Object,
        "resultId": Number
    }

    ```

-   `/mcq/submit/:resultId`  
    User submits a quiz. If submission is proper and within time limit, it gets accepted. 5 seconds of wiggle room is kept.<br/>
    Request body:

    ```javascript
    {
        "answers" : Array
    }

    ```

    Response body: This time, `questions` object contains correct answers.

    ```javascript
    {
        "title": String,
        "challengeId" : String,
        "difficulty" : String,
        "score" : Number,
        "time" : Number.
        "questions": Object,
        "resultId": Number
    }

    ```

-   `/mcq/start/:challengeId`
    Request body: _does not require_ <br/>
    User starts this challenge. Timer starts as soon as user hit this endpoint.

-   `/dual/invitations?userid=...&days=...`
    get list of dual notifications for a particilura user filtered by last n days. 

    Request body: _does not require_ <br/>
    Response body: Javascript array of `json` data
    
    ```javascript
    [
        {
            "exam_id" : Number,
            "challenger_id" : Number,
            "challenger_name" : String,
            "challengee_id" : Number,
            "challengee_name" : String,
            "topic_id" : Number,
            "topic_name" : String,
            "status" : String,
            "last_accessed" : Date
        },
        ...
    ]
    ```

-   `/dual/invite`
    Invite a user to a dual challenge on a particular topic

    Request body: `json` data
    ```javascript
    {
        "challengerId" : Number,
        "challengeeId" : Number,
        "topicId" : Number,
        "challengeId" : Number,
    }
    ```
    Response body: `json` data containing challenge_id
    ```javascript
    {
        "id" : Number
    }
    ```

-   `/dual/archive`
    Archive all `pending` outdated invitations 

    Request body: _does not require_<br/>
    Response body: _does not require_


-   `/dual/accept`
    Accept a user's invitation on a particular topic

    Request body: `json` data
    ```javascript
    {
        "examId" : Number,
    }
    ```
    Response body: `json` data containing challenge_id
    ```javascript
    {
        "id" : Number
    }
    ```

-   `/dual/reject`
    Reject a user's invitation on a particular topic

    Request body: `json` data
    ```javascript
    {
        "examId" : Number,
    }
    ```
    Response body: `json` data containing challenge_id
    ```javascript
    {
        "id" : Number
    }
    ```

-   `/dual/complete`
    Complete a dual challenge on a particular topic

    Request body: `json` data
    ```javascript
    {
        "examId" : Number,
    }
    ```
    Response body: `json` data containing challenge_id
    ```javascript
    {
        "id" : Number
    }
    ```

-   `/dual/start?examId=...&challengeId=...`

    Request body: _does not require_ <br/>
    User starts this challenge. Timer starts as soon as user hit this endpoint.

-   `/dual/result?examId=...`

    Request body: _does not require_ <br/>
    Response body: Javascript Array(2) of `json` data
    ```javascript
    {
        "problem_title" : String,
        "question_answer_set" : JSON,
        "participant_id" : Number,
        "participant_name" : String,
        "participant_mark" : Number,
        "participant_submission" : Array,
    }
    ```

-   `/public/best/:userid[?problemid=][?topicid=]`  
    get best score(s) for given user [and problem] [and topic] in chronological order. best score means: highest score, earliest submission time.
    Also return problem's max score (to compare with this user's score) and category. *_topicid=0 means all topics.*

-   `/public/bestscores/:userid[?problemid=][?topicid=]`  
    similar to best, except it considers only coding challenges and sorted by recency.

-   `/public/activities/:userid[?topicid=]`  
    get all challenge results of userid [for given topic] sorted by recency. _topicid=0 means all topics._

-   `/public/rank[?userid=][?topicid=]`  
    get rank of user(s) [for given topic]. _topicid=0 means all topics._

-   `/public/solidusercount/:topicid`  
    get number of users with non-zero score in topicid. _topicid=0 means all topics._

-   `/public/activeusers`
    get currently active user lists<br/>
    Request body: _does not require_<br/>
    Response body: Javascript array of `json` data
    
    ```javascript
    [
        {
            "userid" : Number,
            "name" : String,
            "score" : String
        },
        ...
    ]

    ```

-   `/logout`
    Request body: _does not require_


-    _This will be updated along with implementation._

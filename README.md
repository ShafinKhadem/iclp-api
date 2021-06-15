# iclp-api

### Endpoints:

-   /login  
    Request body:

    ```JSON
    {
      	"email": String,
        "password" : String,
    }
    ```

-   /signup  
    Request body:
    ```JSON
    {
      	"name": String,
        "email": String,
        "password": String,
        "confirmed_password": String,
    }
    ```
-   /logout  
    Request body: _does not require_
-   /protected
    Request body: _does not require_
    This is for testing authentication

-   `/public/best/:userid[?problemid=][?topicid=]`  
    get best score(s) for given user [and problem] [and topic]. best score means: highest score, earliest submission time.
    Also return problem's max_score to compare with this user's score. _topicid=0 means all topics._

-   `/public/rank[?userid=][?topicid=]`  
    get rank of user(s) [for given topic]. _topicid=0 means all topics._

    _This will be updated along with implementation._

### Project Info

-   Make sure that node version is 14 (latest stable).

-   Install all dependencies

    ```
    npm install
    ```

-   Run dev server

    ```
    npm run dev
    ```

### Read documentations

- [express-validator](https://express-validator.github.io/docs/index.html)
- [passport-local](https://www.passportjs.org/packages/passport-local/)
- [node-postgres](https://node-postgres.com/)
- [sql-template-strings](https://www.npmjs.com/package/sql-template-strings)
- [app-root-path](https://www.npmjs.com/package/app-root-path)
- [multer](https://www.npmjs.com/package/multer) for file upload

### Install new npm package

npm i --save whatever_package

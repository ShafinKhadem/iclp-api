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
    This is for testing authentication, will delete later.

    _This will be updated along with implementation._

### Project Info

-   Install all dependencies

    ```
    npm install
    ```

-   Run dev server

    ```
    npm run dev
    ```

### Read documentations

- [node-postgres](https://node-postgres.com/)
- [express-validator](https://express-validator.github.io/docs/index.html)
- [sql-template-strings](https://www.npmjs.com/package/sql-template-strings)
- [passport-local](https://www.passportjs.org/packages/passport-local/)

### Install new npm package

npm i --save whatever_package

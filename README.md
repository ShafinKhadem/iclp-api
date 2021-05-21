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

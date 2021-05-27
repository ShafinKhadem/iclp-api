Run the following sql query

```sql
create role public_read;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO public_read;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
   GRANT SELECT ON TABLES TO public_read;
create role public_write;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO public_write;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO public_write;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
   GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO public_write;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
   GRANT EXECUTE ON FUNCTIONS TO public_write;
create role authenticator noinherit login password 'mysecretpassword';
grant public_read, public_write to authenticator;
```

Run the server using `postgrest postgrest.conf`

For now anyone can make select, insert, update, delete requests and execute functions. But we can change that later by changing db-anon-role in postgrest.conf and using [JWT](https://postgrest.org/en/stable/tutorials/tut1.html).

api documentation: https://postgrest.org/en/stable/api.html

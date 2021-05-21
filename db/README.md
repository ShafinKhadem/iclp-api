# DB Info

It may need to change something in database. If you change anything, please write it down in this file.

1. Changed all table's name to lowercase (it was actually necessary).
2. Added a new table named session_store. It saves user sessions.
3. Added a new column 'salt' in 'users' table.
4. Password column was renamed to hash.

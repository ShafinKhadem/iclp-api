# DB Info

It may need to change something in database. If you change anything, please write it down in this file.

1. Changed all table's name to lowercase (it was actually necessary).
2. Added a new table named session_store. It saves user sessions.
3. Added a new column 'salt' in 'users' table.
4. Password column was renamed to hash.
5. Removed all tables irrelevant to our part.
6. Added difficulty_type and challenge_type enum
7. Added category, difficulty and score in challenges
7. Added opponent_id and details in challenge_results
8. Added language enum
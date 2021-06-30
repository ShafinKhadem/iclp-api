current_time=$(date "+%Y.%m.%d-%H.%M.%S")
PGPASSWORD=postgres pg_dump -h localhost -U postgres -d iclp_db -f dump_$current_time.sql
echo "dumped iclp_db to: dump_$current_time.sql"
PGPASSWORD=postgres dropdb -h localhost -U postgres iclp_db && echo "dropped iclp_db"
PGPASSWORD=postgres createdb -h localhost -U postgres iclp_db
PGPASSWORD=postgres psql -h localhost -U postgres -d iclp_db -f $1 && echo "restored iclp_db from $1"
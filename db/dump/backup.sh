current_time=$(date "+%Y.%m.%d-%H.%M.%S")
PGPASSWORD=postgres pg_dump -h localhost -U postgres -d iclp_db -f dump_$current_time.sql
echo "dumped iclp_db to: dump_$current_time.sql"

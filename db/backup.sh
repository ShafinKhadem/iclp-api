export $(cat "$(dirname "$0")"/../.env | xargs)
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME -f dump_$current_time.sql && echo "dumped $DB_NAME to: dump_$current_time.sql"
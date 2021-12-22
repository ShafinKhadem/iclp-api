[ "$#" -lt 1 ] && echo "Give /path/to/dump_file (to restore) as argument" && exit
export $(cat "$(dirname "$0")"/../.env | xargs)
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
PGPASSWORD=$DB_PASSWORD pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME -f dump_$current_time.sql && echo "dumped $DB_NAME to: dump_$current_time.sql"
PGPASSWORD=$DB_PASSWORD dropdb -h $DB_HOST -U $DB_USER $DB_NAME && echo "dropped $DB_NAME"
PGPASSWORD=$DB_PASSWORD createdb -h $DB_HOST -U $DB_USER $DB_NAME
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f $1 && echo "restored $DB_NAME from $1"
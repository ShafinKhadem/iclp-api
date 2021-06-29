ICLP_DB

# Usage

### Make user=postgres password=postgres

```
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
```

### backup iclp_db

```
PGPASSWORD=postgres pg_dump -h localhost -U postgres -d iclp_db -f ~/Downloads/dump.sql
```

### restore iclp_db

```
PGPASSWORD=postgres pg_dump -h localhost -U postgres -d iclp_db -f ~/Downloads/dump-old.sql
PGPASSWORD=postgres dropdb -h localhost -U postgres iclp_db || exit
PGPASSWORD=postgres createdb -h localhost -U postgres iclp_db
PGPASSWORD=postgres psql -h localhost -U postgres -d iclp_db -f ~/Downloads/dump.sql
```


### If you mess up any sequence

```
alter sequence "Users_id_seq" restart with 101;
```

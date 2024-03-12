# Postgres DB testdrive

Author: MvS  
Date: 2024-03-10  

[forked from](https://github.com/ghusta/docker-postgres-world-db)

Example Database for [PostgreSQL](https://www.postgresql.org/) : World DB

Database script downloaded at : [here](http://pgfoundry.org/frs/?group_id=1000150&release_id=366#world-world-1.0-title-content)

See also PostgreSQL [Sample Databases](https://wiki.postgresql.org/wiki/Sample_Databases).

## Database details

**Important note** : from version 2.0, tables and columns names use [_snake case_](https://en.wikipedia.org/wiki/Snake_case).
 This version is incompatible with version 1.x.

### Default parameters

[why this works](https://stackoverflow.com/questions/26598738/how-to-create-user-database-in-script-for-docker-postgres)

- database : world-db
- user : world
- password : world123

### Schema

- public

### Tables

This database contains 3 tables :

- city
- country
- country_language

### Relationships

- country_language -> country (country_language_country_code_fkey)
- city -> country (country_fk)
- country -> city (country_capital_fkey)

## Run a Docker container

You can run a Docker container with this command (replace _xxxx_ by your local port) :

`docker run -d -p xxxx:5432 ghusta/postgres-world-db:2.6`

## PostgreSQL configuration

If you need to inspect the PostgreSQL server configuration, you can print this file : `/var/lib/posgtresql/data/postgresql.conf`.

All settings are documented here : [here](https://www.postgresql.org/docs/current/runtime-config.html)

With Docker, you can run :

`docker exec <my-container-name> cat /var/lib/postgresql/data/postgresql.conf`

### Log all statements

To log all statements, you can activate this line in the configuration :

`log_min_duration_statement = 0`

### Log categories of statements

You can also log only some categories of statements with `log_statement`.

Valid values are `none, ddl, mod, all`. Default is `none`.

See details : [here](https://www.postgresql.org/docs/current/runtime-config-logging.html)

### Test it

### With the psql CLI command

`docker exec -it <container_name> psql -d world-db -U world`

Then try a command, like :

#### List of relations

``` [bash]
psql (14.2 (Debian 14.2-1.pgdg110+1))
Type "help" for help.

world-db=# \d
             List of relations
 Schema |       Name       | Type  | Owner
--------+------------------+-------+-------
 public | city             | table | world
 public | country          | table | world
 public | country_language | table | world
(3 rows)
```

### List of schemas

``` [bash]
world-db=# \dn
List of schemas
  Name  | Owner
--------+-------
 public | world
(1 row)
```

### Manual manipulation of PostgreSQL DB in Docker container

Note: ToDo , update

One step process:  
`docker-compose exec postgres env PGOPTIONS="--search_path=inventory" bash -c 'psql -U $POSTGRES_USER postgres'`

Two step process:  

1. Enter container: `docker exec -it <postgres-container-name> bash`
2. Use client: `psql -d postgres -U postgres -W`

Relevant commands:

- Switch to other db with new user: `\c <database_name> <user_name>`
- Quit psql: `\q`
- Add schema to search path:  
(not working): `ALTER DATABASE <database_name> SET search_path TO <schema_name_1>,<schema_name_2>;`  
`SET search_path TO public, inventory;`
- Change WAL log replication: `ALTER SYSTEM SET wal_level = 'logical';`  
and verify: `SHOW wal_level;`
- Gather information on DBs:
  - list databases: `\l`
  - list users: `\du`
  - list schema: `\dn`
  - list tables: `\dt`
  - list tables for schema: `\dt <schema_name>`
  - list views: `\dv`
  - list functions: `\df`
  - describe table: `\d <table_name>`
- History:
  - command history: `\s`
  - execute previous command: `\g`
- Help:
  - help on all commands: `\?`
  - help on command: `\h <command_name>`

### Describe the city table

``` [bash]
world-db=# \d+ city
...
```

### A simple query

``` [bash]
world-db=# select * from city limit 10;
  1 | Kabul          | AFG          | Kabol         |    1780000
  2 | Qandahar       | AFG          | Qandahar      |     237500
  3 | Herat          | AFG          | Herat         |     186800
  4 | Mazar-e-Sharif | AFG          | Balkh         |     127800
  5 | Amsterdam      | NLD          | Noord-Holland |     731200
  6 | Rotterdam      | NLD          | Zuid-Holland  |     593321
  7 | Haag           | NLD          | Zuid-Holland  |     440900
  8 | Utrecht        | NLD          | Utrecht       |     234323
  9 | Eindhoven      | NLD          | Noord-Brabant |     201843
 10 | Tilburg        | NLD          | Noord-Brabant |     193238
```

## Connection using Python

To maintain module interoperability it is advised to create different throwaway
environments for individual purposes of each repository.
*Note*: without going into slight differences between OS'es we are describing the Linux way.
To manually create a virtual environment called <notebook_env> do the following:  

```[bash]
python3 -m venv notebook_env
```

After the init process completes and the virtual environment is created, you can use the following
step to activate your environment.

```[bash]
source notebook_env/bin/activate
```

Once the virtualenv is activated, you can install the required dependencies.

```[bash]
pip install -r notebooks/requirements.txt
```

In this example repo it will add [psycopg](https://pypi.org/project/psycopg/), a PostgreSQL database
adapter for Python and some common modules to facilitate data wrangling  - (and Jupyter modules, optionally).

Then you should be able to either run the Jupyter notebook `test_connection.ipynb` provided for reference.
Or you can open a connection from a regular python script.

``` [python]
import psycopg

DB_HOST = "localhost"
DB_PORT = "8432"
DB_NAME = "world-db"
DB_USER = "world"
DB_PASS = "world123"

with  psycopg.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASS, host=DB_HOST, port=DB_PORT) as conn:

    with conn.cursor() as cur:
        cur.execute("select count(*) from city")
        row = cur.fetchone()
        print('Count = ', row[0])
```
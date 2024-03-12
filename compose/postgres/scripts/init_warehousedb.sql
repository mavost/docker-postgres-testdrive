--
-- PostgreSQL port of the "warehouse" database.
--
--
CREATE USER bi WITH PASSWORD 'admin';
CREATE DATABASE warehouse;
GRANT ALL PRIVILEGES ON DATABASE warehouse TO bi;
-- BEGIN;

-- CREATE TABLE mylist (
--     id integer NOT NULL,
--     name text NOT NULL,
--     counter integer NOT NULL
-- );

-- ALTER TABLE ONLY city
--     ADD CONSTRAINT city_pkey PRIMARY KEY (id);

-- COMMIT;

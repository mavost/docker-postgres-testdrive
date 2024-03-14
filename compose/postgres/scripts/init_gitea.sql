--
-- PostgreSQL port of the "gitea" database.
--
--
CREATE USER gitea WITH PASSWORD 'giteapw';
CREATE DATABASE giteadb;
GRANT ALL PRIVILEGES ON DATABASE giteadb TO gitea;


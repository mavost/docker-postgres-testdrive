# Init Example Database World on PostgreSQL
ARG BASEIMAGE
FROM ${BASEIMAGE}

# ENV POSTGRES_USER world
# ENV POSTGRES_PASSWORD world123
# ENV POSTGRES_DB world-db

ADD scripts/*.sql /docker-entrypoint-initdb.d/

COPY docker-healthcheck /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK CMD ["docker-healthcheck"]

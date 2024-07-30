# Init Example Database World on PostgreSQL
ARG BASEIMAGE=postgres:latest
FROM ${BASEIMAGE}

# ENV POSTGRES_USER world
# ENV POSTGRES_PASSWORD world123
# ENV POSTGRES_DB world-db

# Add SQL scripts to initialize the database
ADD scripts/*.sql /docker-entrypoint-initdb.d/

# Copy and set up the health check script
COPY docker-healthcheck /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-healthcheck

# Define health check command
HEALTHCHECK CMD /usr/local/bin/docker-healthcheck || exit 1

FROM mdillon/postgis:9.5-alpine
RUN rm -f /var/lib/postgresql/data/* && ls /var/lib/postgresql/data/
COPY pgdata /var/lib/postgresql/data

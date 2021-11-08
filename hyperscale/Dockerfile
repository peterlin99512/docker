# This file is auto generated from it's template,
# see citusdata/tools/packaging_automation/templates/docker/latest/latest.tmpl.dockerfile.
FROM postgres:14.0
ARG VERSION=10.2.2
LABEL maintainer="Citus Data https://citusdata.com" \
      org.label-schema.name="Citus" \
      org.label-schema.description="Scalable PostgreSQL for multi-tenant and real-time workloads" \
      org.label-schema.url="https://www.citusdata.com" \
      org.label-schema.vcs-url="https://github.com/citusdata/citus" \
      org.label-schema.vendor="Citus Data, Inc." \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"

ENV CITUS_VERSION ${VERSION}.citus-1
ENV POSTGRES_DB citus

# install Citus
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
    && curl -s https://install.citusdata.com/community/deb.sh | bash \
    && apt-get install -y postgresql-$PG_MAJOR-citus-10.2=$CITUS_VERSION \
                          postgresql-$PG_MAJOR-hll=2.16.citus-1 \
                          postgresql-$PG_MAJOR-topn=2.4.0 \
    && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/lists/*

# install other extensions
RUN     apt-get update \
      &&apt-get install -y postgresql-14-postgis-3 \
            postgresql-plperl-14 \
            postgresql-contrib \
            postgresql-14-partman \
            postgresql-14-tdigest \
            postgresql-14-mysql-fdw

RUN apt-get -y install postgresql-14-cron

# add citus to default PostgreSQL config
RUN echo "shared_preload_libraries='citus,pg_cron,pg_stat_statements'" >> /usr/share/postgresql/postgresql.conf.sample

# add pg_cron into default PostgreSQL config
RUN echo "cron.database_name = 'citus'" >> /usr/share/postgresql/postgresql.conf.sample

# add scripts to run after initdb
COPY hyperscale/001-db-user-creation.sql /docker-entrypoint-initdb.d/
COPY hyperscale/002-create_extension_functions.sql /docker-entrypoint-initdb.d/
COPY hyperscale/003-create_citus_extension.sql /docker-entrypoint-initdb.d/
COPY hyperscale/004-postgres_replication_origins.sql /docker-entrypoint-initdb.d/
COPY hyperscale/005-create_postgis_extension.sql /docker-entrypoint-initdb.d/
COPY hyperscale/006-other_extensions.sql /docker-entrypoint-initdb.d/
COPY hyperscale/007-pg_cron_pg_partman_setup.sql /docker-entrypoint-initdb.d/
COPY hyperscale/008-grant_usage_fdw.sql /docker-entrypoint-initdb.d/
COPY hyperscale/009-other_grants.sql /docker-entrypoint-initdb.d/
COPY hyperscale/010-stat_statements_reset.sql /docker-entrypoint-initdb.d/





# add health check script
COPY pg_healthcheck wait-for-manager.sh /
RUN chmod +x /wait-for-manager.sh

# entry point unsets PGPASSWORD, but we need it to connect to workers
# https://github.com/docker-library/postgres/blob/33bccfcaddd0679f55ee1028c012d26cd196537d/12/docker-entrypoint.sh#L303
RUN sed "/unset PGPASSWORD/d" -i /usr/local/bin/docker-entrypoint.sh

HEALTHCHECK --interval=4s --start-period=6s CMD ./pg_healthcheck

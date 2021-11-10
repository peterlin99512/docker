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

# install Citus and needed extension on hyperscale
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
    && curl -s https://install.citusdata.com/community/deb.sh | bash \
    && apt-get install -y postgresql-$PG_MAJOR-citus-10.2=$CITUS_VERSION \
                          postgresql-$PG_MAJOR-hll=2.16.citus-1 \
                          postgresql-$PG_MAJOR-topn=2.4.0 \
                          postgresql-14-postgis-3 \
                          postgresql-plperl-14 \
                          postgresql-contrib \
                          postgresql-14-partman \
                          postgresql-14-tdigest \
                          postgresql-14-mysql-fdw \
                          postgresql-14-cron \
    && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/lists/*

# set shared_preload_libraries to the list of extensions that needs to be loaded when postgresql starts
RUN echo "shared_preload_libraries='citus,pg_cron,pg_stat_statements'" >> /usr/share/postgresql/postgresql.conf.sample

# set default database name for pg_cron extension
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

# This block is required to be able to define the password for user citus. With the below script citus password can be
# set using 'CITUS_PASSWORD' env variable set in docker run phase
RUN apt-get update && apt-get install -y  sudo && adduser postgres sudo
RUN echo 'postgres     ALL=(ALL) NOPASSWD:ALL' >> '/etc/sudoers'
ARG CITUS_PWD_COMMAND='\\tsudo sed "s\/###CITUS_PASSWORD###\/${CITUS_PASSWORD}\/g" -i \/docker-entrypoint-initdb.d\/001-db-user-creation.sql\n'
RUN sed "/# if first arg looks like a flag.*/a ${CITUS_PWD_COMMAND}" -i /usr/local/bin/docker-entrypoint.sh

# entry point unsets PGPASSWORD, but we need it to connect to workers
# https://github.com/docker-library/postgres/blob/33bccfcaddd0679f55ee1028c012d26cd196537d/12/docker-entrypoint.sh#L303
RUN sed "/unset PGPASSWORD/d" -i /usr/local/bin/docker-entrypoint.sh

HEALTHCHECK --interval=4s --start-period=6s CMD ./pg_healthcheck


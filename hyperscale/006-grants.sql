-- partman schema and grants per resource https://github.com/pgpartman/pg_partman
CREATE ROLE partman WITH LOGIN;
CREATE SCHEMA partman;
CREATE EXTENSION pg_partman SCHEMA partman;
GRANT ALL ON ALL TABLES IN SCHEMA partman TO partman;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA partman TO partman;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA partman TO partman;
GRANT ALL ON SCHEMA citus TO partman;
GRANT TEMPORARY ON DATABASE citus to partman;
GRANT CREATE ON DATABASE citus TO partman;

GRANT EXECUTE ON FUNCTION create_extension(text) TO citus WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION drop_extension(text) TO citus WITH GRANT OPTION;
GRANT ALL ON SCHEMA public TO citus WITH GRANT OPTION;
GRANT SELECT ON pg_buffercache TO public;
GRANT EXECUTE ON FUNCTION pg_buffercache_pages() TO public;
GRANT pg_monitor TO citus;
GRANT USAGE ON SCHEMA cron TO citus WITH GRANT OPTION;
GRANT ALL ON SCHEMA partman TO citus WITH GRANT OPTION;
GRANT ALL ON ALL TABLES IN SCHEMA partman TO citus WITH GRANT OPTION;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA partman TO citus WITH GRANT OPTION;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA partman TO citus WITH GRANT OPTION;
GRANT USAGE ON FOREIGN DATA WRAPPER dblink_fdw TO citus WITH GRANT OPTION;
-- TODO Having problems installing below functions
-- GRANT EXECUTE ON FUNCTION public.pg_replication_origin_create(text) TO citus;
-- GRANT EXECUTE ON FUNCTION public.pg_replication_origin_session_progress(bool) TO citus;
-- GRANT EXECUTE ON FUNCTION public.pg_replication_origin_progress(text, bool) TO citus;
-- GRANT EXECUTE ON FUNCTION public.pg_replication_origin_drop(text) TO citus;
-- GRANT EXECUTE ON FUNCTION public.pg_replication_origin_xact_setup(pg_lsn, timestamptz) TO citus;
-- GRANT EXECUTE ON FUNCTION public.pg_replication_origin_session_setup(text) TO citus;
GRANT EXECUTE ON FUNCTION pg_stat_statements_reset TO citus WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION citus_stat_statements_reset TO citus WITH GRANT OPTION;
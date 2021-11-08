--https://msdata.visualstudio.com/Database%20Systems/_git/CitusMigration?path=/instance/lib/stat_statements_reset.sql
GRANT EXECUTE ON FUNCTION pg_stat_statements_reset TO citus WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION citus_stat_statements_reset TO citus WITH GRANT OPTION;
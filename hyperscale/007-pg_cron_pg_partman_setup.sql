-- source https://msdata.visualstudio.com/Database%20Systems/_git/CitusMigration?path=/instance/lib/pg_cron_pg_partman_setup.sql
SELECT current_database();
\connect citus;
SELECT current_database();
CREATE EXTENSION pg_cron;
GRANT USAGE ON SCHEMA cron TO citus WITH GRANT OPTION;

CREATE SCHEMA partman;
CREATE EXTENSION pg_partman WITH SCHEMA partman;
GRANT ALL ON SCHEMA partman TO citus WITH GRANT OPTION;
GRANT ALL ON ALL TABLES IN SCHEMA partman TO citus WITH GRANT OPTION;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA partman TO citus WITH GRANT OPTION;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA partman TO citus WITH GRANT OPTION;
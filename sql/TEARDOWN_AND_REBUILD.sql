-- =============================================================================
-- TEARDOWN AND REBUILD: YMCA San Diego County SI Demo
-- Run this single file to deploy the complete demo from scratch.
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- TEARDOWN
DROP SCHEMA IF EXISTS CUSTOMER_DEMOS.YMC CASCADE;
DROP WAREHOUSE IF EXISTS YMC_WH;
DROP NOTIFICATION INTEGRATION IF EXISTS YMC_EMAIL_INTEGRATION;

-- REBUILD
!source setup/01_database_and_schema.sql;
!source setup/02_create_tables.sql;
!source data/03_generate_synthetic_data.sql;
!source views/04_create_views.sql;
!source views/05_create_semantic_view.sql;
!source search/06_create_cortex_search.sql;
!source tools/07_create_email_proc.sql;
!source agent/08_create_agent.sql;

-- VERIFY
SHOW AGENTS IN SCHEMA CUSTOMER_DEMOS.YMC;
SHOW CORTEX SEARCH SERVICES IN SCHEMA CUSTOMER_DEMOS.YMC;
SHOW SEMANTIC VIEWS IN SCHEMA CUSTOMER_DEMOS.YMC;
SELECT 'BRANCHES' AS TBL, COUNT(*) AS ROWS FROM CUSTOMER_DEMOS.YMC.BRANCHES
UNION ALL SELECT 'EMPLOYEES', COUNT(*) FROM CUSTOMER_DEMOS.YMC.EMPLOYEES
UNION ALL SELECT 'MEMBERS', COUNT(*) FROM CUSTOMER_DEMOS.YMC.MEMBERS
UNION ALL SELECT 'IT_TICKETS', COUNT(*) FROM CUSTOMER_DEMOS.YMC.IT_TICKETS
UNION ALL SELECT 'CHILDCARE_PROGRAMS', COUNT(*) FROM CUSTOMER_DEMOS.YMC.CHILDCARE_PROGRAMS;

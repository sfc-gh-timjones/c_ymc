/***************************************************************************************************
  YMC ASSISTANT — One-Click Deployment

  This script:
    1. Creates a Git repo integration to pull scripts directly from GitHub
    2. Tears down any existing YMC demo objects (safe to run fresh)
    3. Runs all setup scripts (01 → 08) via EXECUTE IMMEDIATE FROM

  NOTE: PDF documents for Cortex Search (in pdfs/) must be re-uploaded manually
  after a teardown. Run the PUT commands in sql/search/06_create_cortex_search.sql
  via SnowSQL or the Snowsight file upload UI, then ALTER STAGE ... REFRESH.
***************************************************************************************************/

USE ROLE ACCOUNTADMIN;
CREATE WAREHOUSE IF NOT EXISTS YMC_DEPLOY_WH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE YMC_DEPLOY_WH;

/*=============================================================================
  1. GIT REPO INTEGRATION

  If you followed the README instructions, this integration already exists
  and the block below will do nothing. If you skipped that step or are unsure,
  you can safely uncomment and run it — IF NOT EXISTS means it will only
  create the integration if it isn't already there.
=============================================================================*/

-- CREATE API INTEGRATION IF NOT EXISTS GIT_HUB_INTEGRATION
--   API_PROVIDER = git_https_api
--   API_ALLOWED_PREFIXES = ('https://github.com/')
--   ENABLED = TRUE;

CREATE DATABASE IF NOT EXISTS YMC_DEPLOY;
CREATE SCHEMA IF NOT EXISTS YMC_DEPLOY.GIT;

CREATE OR REPLACE GIT REPOSITORY YMC_DEPLOY.GIT.C_YMC_REPO
  API_INTEGRATION = GIT_HUB_INTEGRATION
  ORIGIN = 'https://github.com/sfc-gh-timjones/c_ymc';

ALTER GIT REPOSITORY YMC_DEPLOY.GIT.C_YMC_REPO FETCH;

/*=============================================================================
  2. TEARDOWN (safe even on first run)
=============================================================================*/

EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/99-teardown.sql;

/*=============================================================================
  3. REBUILD (runs in order: 01 → 08)
=============================================================================*/

EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/setup/01_database_and_schema.sql;
EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/setup/02_create_tables.sql;
EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/data/03_generate_synthetic_data.sql;
EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/views/04_create_views.sql;
EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/views/05_create_semantic_view.sql;
EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/search/06_create_cortex_search.sql;
EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/tools/07_create_email_proc.sql;
EXECUTE IMMEDIATE FROM @YMC_DEPLOY.GIT.C_YMC_REPO/branches/master/sql/agent/08_create_agent.sql;

/*=============================================================================
  DONE!

  The demo environment is ready. Open Snowflake Intelligence → YMC Assistant.
  Verify objects:
    SHOW AGENTS IN SCHEMA CUSTOMER_DEMOS.YMC;
    SHOW CORTEX SEARCH SERVICES IN SCHEMA CUSTOMER_DEMOS.YMC;
    SHOW SEMANTIC VIEWS IN SCHEMA CUSTOMER_DEMOS.YMC;
=============================================================================*/

DROP DATABASE IF EXISTS YMC_DEPLOY;
DROP WAREHOUSE IF EXISTS YMC_DEPLOY_WH;

SELECT 'YMC SI demo deployed. Open Snowflake Intelligence → YMC Assistant.' AS status;

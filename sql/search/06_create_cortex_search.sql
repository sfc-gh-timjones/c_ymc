USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

-- =============================================================================
-- STAGES FOR PDF DOCUMENTS
-- =============================================================================

CREATE OR REPLACE STAGE YMC_HR_DOCS_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE STAGE YMC_IT_DOCS_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE STAGE YMC_SOP_DOCS_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- =============================================================================
-- UPLOAD PDFs (run from SnowSQL or Snowsight)
-- HR: Employee handbooks
-- IT: Salesforce guide, Microsoft 365 guide, Zoho Desk guide
-- SOP: Aquatics safety plan, camp info packet, team events SOP
-- =============================================================================

-- HR Policy documents
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/2025 Employee Handbook.pdf @YMC_HR_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/2024-Employee-Handbook-REV-12.27.23.pdf @YMC_HR_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/YMCA-of-Metropolitan-Washington-Membership-Handbook_122823.pdf @YMC_HR_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- IT Knowledge Base documents
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/getting_started_with_salesforce.pdf @YMC_IT_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/Microsoft 365 Quick Start Guide.pdf @YMC_IT_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/zoho-desk-integration-guide-p-series-appliance-edition-en.pdf @YMC_IT_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- SOP documents
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/Aquatic-Safety-Plan-Dec2018.pdf @YMC_SOP_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/Summer_overnight_camp_info_packet.pdf @YMC_SOP_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT file:///Users/timjones/projects/coco/ymca_demo/pdfs/SOP-for-Participation-in-Team-Events.pdf @YMC_SOP_DOCS_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- Refresh directory metadata
ALTER STAGE YMC_HR_DOCS_STAGE REFRESH;
ALTER STAGE YMC_IT_DOCS_STAGE REFRESH;
ALTER STAGE YMC_SOP_DOCS_STAGE REFRESH;

-- =============================================================================
-- PARSE AND CHUNK: HR POLICY DOCUMENTS
-- =============================================================================

CREATE OR REPLACE TABLE YMC_HR_POLICY_DOCS AS
WITH parsed AS (
    SELECT
        RELATIVE_PATH AS FILE_NAME,
        AI_PARSE_DOCUMENT(
            TO_FILE('@YMC_HR_DOCS_STAGE', RELATIVE_PATH),
            {'mode': 'LAYOUT', 'page_split': FALSE}
        ):content::STRING AS DOC_TEXT
    FROM DIRECTORY(@YMC_HR_DOCS_STAGE)
),
chunked AS (
    SELECT
        FILE_NAME,
        f.index AS CHUNK_INDEX,
        f.value::STRING AS CHUNK_TEXT
    FROM parsed,
    LATERAL FLATTEN(
        INPUT => SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
            DOC_TEXT, 'markdown', 1600, 300
        )
    ) f
)
SELECT
    ROW_NUMBER() OVER (ORDER BY FILE_NAME, CHUNK_INDEX) AS DOC_ID,
    REPLACE(REPLACE(FILE_NAME, '.pdf', ''), '_', ' ') AS TITLE,
    'HR Policy' AS CATEGORY,
    FILE_NAME,
    CHUNK_INDEX,
    CHUNK_TEXT
FROM chunked
WHERE LENGTH(CHUNK_TEXT) > 50;

-- =============================================================================
-- PARSE AND CHUNK: IT KNOWLEDGE BASE DOCUMENTS
-- =============================================================================

CREATE OR REPLACE TABLE YMC_IT_KB_DOCS AS
WITH parsed AS (
    SELECT
        RELATIVE_PATH AS FILE_NAME,
        AI_PARSE_DOCUMENT(
            TO_FILE('@YMC_IT_DOCS_STAGE', RELATIVE_PATH),
            {'mode': 'LAYOUT', 'page_split': FALSE}
        ):content::STRING AS DOC_TEXT
    FROM DIRECTORY(@YMC_IT_DOCS_STAGE)
),
chunked AS (
    SELECT
        FILE_NAME,
        f.index AS CHUNK_INDEX,
        f.value::STRING AS CHUNK_TEXT
    FROM parsed,
    LATERAL FLATTEN(
        INPUT => SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
            DOC_TEXT, 'markdown', 1600, 300
        )
    ) f
)
SELECT
    ROW_NUMBER() OVER (ORDER BY FILE_NAME, CHUNK_INDEX) AS DOC_ID,
    REPLACE(REPLACE(FILE_NAME, '.pdf', ''), '_', ' ') AS TITLE,
    'IT Knowledge Base' AS CATEGORY,
    FILE_NAME,
    CHUNK_INDEX,
    CHUNK_TEXT
FROM chunked
WHERE LENGTH(CHUNK_TEXT) > 50;

-- =============================================================================
-- PARSE AND CHUNK: SOP DOCUMENTS
-- =============================================================================

CREATE OR REPLACE TABLE YMC_SOP_DOCS AS
WITH parsed AS (
    SELECT
        RELATIVE_PATH AS FILE_NAME,
        AI_PARSE_DOCUMENT(
            TO_FILE('@YMC_SOP_DOCS_STAGE', RELATIVE_PATH),
            {'mode': 'LAYOUT', 'page_split': FALSE}
        ):content::STRING AS DOC_TEXT
    FROM DIRECTORY(@YMC_SOP_DOCS_STAGE)
),
chunked AS (
    SELECT
        FILE_NAME,
        f.index AS CHUNK_INDEX,
        f.value::STRING AS CHUNK_TEXT
    FROM parsed,
    LATERAL FLATTEN(
        INPUT => SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
            DOC_TEXT, 'markdown', 1600, 300
        )
    ) f
)
SELECT
    ROW_NUMBER() OVER (ORDER BY FILE_NAME, CHUNK_INDEX) AS DOC_ID,
    REPLACE(REPLACE(FILE_NAME, '.pdf', ''), '_', ' ') AS TITLE,
    'Standard Operating Procedure' AS CATEGORY,
    FILE_NAME,
    CHUNK_INDEX,
    CHUNK_TEXT
FROM chunked
WHERE LENGTH(CHUNK_TEXT) > 50;

-- =============================================================================
-- CREATE CORTEX SEARCH SERVICES
-- =============================================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE YMC_HR_POLICY_SEARCH
  ON CHUNK_TEXT
  ATTRIBUTES TITLE, CATEGORY, FILE_NAME
  WAREHOUSE = YMC_WH
  TARGET_LAG = '1 hour'
AS (
    SELECT DOC_ID, TITLE, CATEGORY, FILE_NAME, CHUNK_TEXT
    FROM YMC_HR_POLICY_DOCS
);

CREATE OR REPLACE CORTEX SEARCH SERVICE YMC_IT_KB_SEARCH
  ON CHUNK_TEXT
  ATTRIBUTES TITLE, CATEGORY, FILE_NAME
  WAREHOUSE = YMC_WH
  TARGET_LAG = '1 hour'
AS (
    SELECT DOC_ID, TITLE, CATEGORY, FILE_NAME, CHUNK_TEXT
    FROM YMC_IT_KB_DOCS
);

CREATE OR REPLACE CORTEX SEARCH SERVICE YMC_SOP_SEARCH
  ON CHUNK_TEXT
  ATTRIBUTES TITLE, CATEGORY, FILE_NAME
  WAREHOUSE = YMC_WH
  TARGET_LAG = '1 hour'
AS (
    SELECT DOC_ID, TITLE, CATEGORY, FILE_NAME, CHUNK_TEXT
    FROM YMC_SOP_DOCS
);

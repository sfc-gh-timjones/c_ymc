-- =============================================================================
-- PDF UPLOAD: Run these PUT commands BEFORE executing TEARDOWN_AND_REBUILD.sql
-- Run via SnowSQL or the snowflake_sql_execute tool (CoCo).
-- PDFs must be present in the pdfs/ folder of this project locally.
-- =============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

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

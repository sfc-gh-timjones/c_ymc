-- =============================================================================
-- TEARDOWN: YMCA San Diego County SI Demo
-- Removes all demo objects. Safe to run multiple times.
-- =============================================================================

USE ROLE ACCOUNTADMIN;

DROP SCHEMA IF EXISTS CUSTOMER_DEMOS.YMC CASCADE;
DROP WAREHOUSE IF EXISTS YMC_WH;
DROP NOTIFICATION INTEGRATION IF EXISTS YMC_EMAIL_INTEGRATION;

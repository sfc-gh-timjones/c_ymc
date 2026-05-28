USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

CREATE NOTIFICATION INTEGRATION IF NOT EXISTS YMC_EMAIL_INTEGRATION
  TYPE = EMAIL
  ENABLED = TRUE;

CREATE OR REPLACE PROCEDURE SEND_EMAIL(TO_ADDRESS STRING, SUBJECT STRING, BODY_HTML STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'run'
AS
$$
def run(session, to_address, subject, body_html):
    session.sql(f"""
        CALL SYSTEM$SEND_EMAIL(
            'YMC_EMAIL_INTEGRATION',
            '{to_address}',
            '{subject}',
            '{body_html}',
            'text/html'
        )
    """).collect()
    return f'Email sent to {to_address}'
$$;

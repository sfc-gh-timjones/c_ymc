USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

-- =============================================================================
-- GENERATE EMPLOYEES WITH FAKER
-- Creates a Snowpark Python stored procedure that generates realistic employee
-- data using Faker + numpy, then calls it, then drops it.
--
-- Why Python here instead of SQL GENERATOR:
--   - Faker produces thousands of distinct realistic names (not 20 cycling)
--   - numpy enables non-uniform distributions (employment mix, pay skew)
--   - Reads actual parent PKs from DEPARTMENTS/BRANCHES — zero FK orphans
--
-- ORDERING NOTE: This script MUST run AFTER 03_generate_synthetic_data.sql.
-- DEPARTMENTS and BRANCHES must have rows before this proc executes, because
-- np.random.choice(dept_ids) throws ValueError on an empty list.
-- =============================================================================

CREATE OR REPLACE PROCEDURE YMC_GENERATE_EMPLOYEES(ROW_COUNT INT)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'faker', 'numpy', 'pandas')
HANDLER = 'run'
AS $$
from faker import Faker
import numpy as np
import pandas as pd
from snowflake.snowpark import Session

def run(session: Session, row_count: int) -> str:
    fake = Faker('en_US')
    np.random.seed(None)

    dept_ids = [r[0] for r in session.sql("SELECT DEPARTMENT_ID FROM DEPARTMENTS ORDER BY DEPARTMENT_ID").collect()]
    branch_ids = [r[0] for r in session.sql("SELECT BRANCH_ID FROM BRANCHES ORDER BY BRANCH_ID").collect()]

    positions = [
        'Lifeguard', 'Youth Program Leader', 'Childcare Teacher', 'Personal Trainer',
        'Maintenance Technician', 'IT Support Specialist', 'HR Coordinator', 'Accountant',
        'Community Outreach Coordinator', 'Camp Counselor', 'Member Services Representative',
        'Marketing Specialist', 'Development Officer', 'Branch Director', 'Case Manager'
    ]

    # Realistic YMCA employment mix: mostly part-time/seasonal
    emp_types = np.random.choice(
        ['Full-Time', 'Part-Time', 'Seasonal'],
        size=row_count,
        p=[0.28, 0.52, 0.20]
    )

    # Pay correlated with employment type
    hourly = np.where(
        emp_types == 'Full-Time',
        np.random.uniform(18.0, 45.0, row_count),   # full-time: wider range, higher ceiling
        np.where(
            emp_types == 'Part-Time',
            np.random.uniform(13.0, 22.0, row_count), # part-time: entry-level range
            np.random.uniform(12.0, 18.0, row_count)  # seasonal: minimum wage range
        )
    )

    is_active = np.random.choice([True, False], size=row_count, p=[0.92, 0.08])

    data = {
        'FIRST_NAME':      [fake.first_name() for _ in range(row_count)],
        'LAST_NAME':       [fake.last_name() for _ in range(row_count)],
        'EMAIL':           [f"{fake.user_name()}{i}@ymcasd.org" for i in range(row_count)],
        'DEPARTMENT_ID':   np.random.choice(dept_ids, size=row_count).tolist(),
        'BRANCH_ID':       np.random.choice(branch_ids, size=row_count).tolist(),
        'POSITION_TITLE':  np.random.choice(positions, size=row_count).tolist(),
        'EMPLOYMENT_TYPE': emp_types.tolist(),
        'HIRE_DATE':       [fake.date_between(start_date='-10y', end_date='today').strftime('%Y-%m-%d')
                            for _ in range(row_count)],
        'STATUS':          ['Active' if a else 'Inactive' for a in is_active.tolist()],
        'HOURLY_RATE':     np.round(hourly, 2).tolist(),
        'MANAGER_ID':      [int(np.random.randint(1, min(300, row_count) + 1))
                            if np.random.random() < 0.80 else None
                            for _ in range(row_count)],
        'IS_ACTIVE':       is_active.tolist(),
    }

    df = pd.DataFrame(data)
    session.write_pandas(
        df, 'EMPLOYEES',
        database='CUSTOMER_DEMOS', schema='YMC',
        overwrite=True, auto_create_table=False
    )
    return f'Generated {row_count} employees with Faker'
$$;

CALL YMC_GENERATE_EMPLOYEES(6000);
DROP PROCEDURE YMC_GENERATE_EMPLOYEES(INT);

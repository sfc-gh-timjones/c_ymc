USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

-- =============================================================================
-- LEVEL 1: PARENT TABLES (standalone, no FK dependencies)
-- =============================================================================

-- BRANCHES (20 rows) — San Diego County locations
INSERT INTO BRANCHES (BRANCH_NAME, CITY, REGION, DIRECTOR_NAME, PHONE, ADDRESS)
VALUES
    ('Mission Valley Branch', 'San Diego', 'Central', 'Maria Rodriguez', '(858) 292-9622', '3401 Clairemont Dr'),
    ('Clairemont Branch', 'San Diego', 'Central', 'James Wilson', '(858) 277-8506', '4975 Clairemont Dr'),
    ('Rancho Family Branch', 'Rancho Bernardo', 'North Inland', 'Sarah Chen', '(858) 487-0221', '16151 Bernardo Center Dr'),
    ('La Mesa Branch', 'La Mesa', 'East County', 'Robert Thompson', '(619) 464-1323', '5505 Kiowa Dr'),
    ('South Bay Branch', 'Chula Vista', 'South', 'Ana Gutierrez', '(619) 421-7202', '1201 Paseo Magda'),
    ('Toby Wells Branch', 'San Diego', 'Central', 'Michael Park', '(858) 292-3490', '5105 Overland Ave'),
    ('Copley-Price Family Branch', 'San Diego', 'Central', 'Jennifer Adams', '(619) 283-2251', '4300 El Cajon Blvd'),
    ('Palomar Family Branch', 'Escondido', 'North Inland', 'David Martinez', '(760) 745-7490', '1050 N Broadway'),
    ('Peninsula Family Branch', 'San Diego', 'Coastal', 'Lisa Nguyen', '(619) 226-8888', '4390 Valeta St'),
    ('Magdalena Ecke Family Branch', 'Encinitas', 'North Coastal', 'Karen O''Brien', '(760) 942-9622', '200 Saxony Rd'),
    ('Don Powell Branch', 'National City', 'South', 'Carlos Reyes', '(619) 477-5400', '1201 E 4th St'),
    ('Herbert Beck Branch', 'El Cajon', 'East County', 'Patricia Wong', '(619) 588-8483', '1050 N Mollison Ave'),
    ('Cameron Family Branch', 'Santee', 'East County', 'Steven Brown', '(619) 449-9622', '10123 Riverwalk Dr'),
    ('Sam & Rose Stein Family Branch', 'Oceanside', 'North Coastal', 'Diane Foster', '(760) 758-0808', '3601 Vista Way'),
    ('North Park Branch', 'San Diego', 'Central', 'Thomas Lee', '(619) 298-3576', '3272 University Ave'),
    ('Kearny Mesa Branch', 'San Diego', 'Central', 'Nancy Kim', '(858) 292-4034', '3708 Ruffin Rd'),
    ('Vista Branch', 'Vista', 'North Coastal', 'Raymond Garcia', '(760) 726-9622', '1415 Washington Ave'),
    ('Poway Branch', 'Poway', 'North Inland', 'Amanda Scott', '(858) 748-1919', '13255 Poway Rd'),
    ('Spring Valley Branch', 'Spring Valley', 'East County', 'Mark Davis', '(619) 460-7900', '3901 Bancroft Dr'),
    ('Imperial Beach Branch', 'Imperial Beach', 'South', 'Laura Hernandez', '(619) 423-9622', '845 Imperial Beach Blvd');

-- MEMBERSHIP_TYPES (8 rows)
INSERT INTO MEMBERSHIP_TYPES (TYPE_NAME, CATEGORY, MONTHLY_FEE, ANNUAL_FEE)
VALUES
    ('Individual Adult', 'Adult', 55.00, 594.00),
    ('Couple', 'Adult', 85.00, 918.00),
    ('Family', 'Family', 95.00, 1026.00),
    ('Senior Individual', 'Senior', 40.00, 432.00),
    ('Senior Couple', 'Senior', 65.00, 702.00),
    ('Young Adult (18-25)', 'Young Adult', 35.00, 378.00),
    ('Youth (12-17)', 'Youth', 25.00, 270.00),
    ('Corporate', 'Corporate', 45.00, 486.00);

-- DEPARTMENTS (15 rows)
INSERT INTO DEPARTMENTS (DEPARTMENT_NAME, DIVISION, COST_CENTER)
VALUES
    ('Aquatics', 'Programs', 'CC-100'),
    ('Youth Development', 'Programs', 'CC-101'),
    ('Childcare', 'Programs', 'CC-102'),
    ('Fitness & Wellness', 'Programs', 'CC-103'),
    ('Facilities & Maintenance', 'Operations', 'CC-200'),
    ('Information Technology', 'Operations', 'CC-201'),
    ('Human Resources', 'Administration', 'CC-300'),
    ('Finance & Accounting', 'Administration', 'CC-301'),
    ('Community Programs', 'Programs', 'CC-104'),
    ('Camp Services', 'Programs', 'CC-105'),
    ('Membership Services', 'Operations', 'CC-202'),
    ('Marketing & Communications', 'Administration', 'CC-302'),
    ('Development & Fundraising', 'Administration', 'CC-303'),
    ('Executive', 'Administration', 'CC-400'),
    ('Social Services', 'Programs', 'CC-106');

-- =============================================================================
-- LEVEL 2: TABLES WITH FK TO LEVEL 1 PARENTS
-- =============================================================================

-- EMPLOYEES (6,000 rows) — FK to BRANCHES (1-20), DEPARTMENTS (1-15)
INSERT INTO EMPLOYEES (FIRST_NAME, LAST_NAME, EMAIL, DEPARTMENT_ID, BRANCH_ID, POSITION_TITLE, EMPLOYMENT_TYPE, HIRE_DATE, STATUS, HOURLY_RATE, MANAGER_ID, IS_ACTIVE)
SELECT
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN 'Maria' WHEN 2 THEN 'James' WHEN 3 THEN 'Sarah'
        WHEN 4 THEN 'Robert' WHEN 5 THEN 'Ana' WHEN 6 THEN 'Michael'
        WHEN 7 THEN 'Jennifer' WHEN 8 THEN 'David' WHEN 9 THEN 'Lisa'
        WHEN 10 THEN 'Carlos' WHEN 11 THEN 'Patricia' WHEN 12 THEN 'Steven'
        WHEN 13 THEN 'Diane' WHEN 14 THEN 'Thomas' WHEN 15 THEN 'Nancy'
        WHEN 16 THEN 'Raymond' WHEN 17 THEN 'Amanda' WHEN 18 THEN 'Mark'
        WHEN 19 THEN 'Laura' ELSE 'Kevin'
    END AS FIRST_NAME,
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN 'Rodriguez' WHEN 2 THEN 'Wilson' WHEN 3 THEN 'Chen'
        WHEN 4 THEN 'Thompson' WHEN 5 THEN 'Gutierrez' WHEN 6 THEN 'Park'
        WHEN 7 THEN 'Adams' WHEN 8 THEN 'Martinez' WHEN 9 THEN 'Nguyen'
        WHEN 10 THEN 'O''Brien' WHEN 11 THEN 'Reyes' WHEN 12 THEN 'Wong'
        WHEN 13 THEN 'Brown' WHEN 14 THEN 'Foster' WHEN 15 THEN 'Lee'
        WHEN 16 THEN 'Kim' WHEN 17 THEN 'Garcia' WHEN 18 THEN 'Scott'
        WHEN 19 THEN 'Davis' ELSE 'Hernandez'
    END AS LAST_NAME,
    LOWER(
        CASE UNIFORM(1, 20, RANDOM())
            WHEN 1 THEN 'maria' WHEN 2 THEN 'james' WHEN 3 THEN 'sarah'
            WHEN 4 THEN 'robert' WHEN 5 THEN 'ana' WHEN 6 THEN 'michael'
            WHEN 7 THEN 'jennifer' WHEN 8 THEN 'david' WHEN 9 THEN 'lisa'
            WHEN 10 THEN 'carlos' WHEN 11 THEN 'patricia' WHEN 12 THEN 'steven'
            WHEN 13 THEN 'diane' WHEN 14 THEN 'thomas' WHEN 15 THEN 'nancy'
            WHEN 16 THEN 'raymond' WHEN 17 THEN 'amanda' WHEN 18 THEN 'mark'
            WHEN 19 THEN 'laura' ELSE 'kevin'
        END
    ) || SEQ4() || '@ymcasd.org' AS EMAIL,
    UNIFORM(1, 15, RANDOM()) AS DEPARTMENT_ID,
    UNIFORM(1, 20, RANDOM()) AS BRANCH_ID,
    CASE UNIFORM(1, 15, RANDOM())
        WHEN 1 THEN 'Lifeguard' WHEN 2 THEN 'Youth Program Leader'
        WHEN 3 THEN 'Childcare Teacher' WHEN 4 THEN 'Personal Trainer'
        WHEN 5 THEN 'Maintenance Technician' WHEN 6 THEN 'IT Support Specialist'
        WHEN 7 THEN 'HR Coordinator' WHEN 8 THEN 'Accountant'
        WHEN 9 THEN 'Community Outreach Coordinator' WHEN 10 THEN 'Camp Counselor'
        WHEN 11 THEN 'Member Services Representative' WHEN 12 THEN 'Marketing Specialist'
        WHEN 13 THEN 'Development Officer' WHEN 14 THEN 'Branch Director'
        ELSE 'Case Manager'
    END AS POSITION_TITLE,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Full-Time' WHEN 2 THEN 'Full-Time' WHEN 3 THEN 'Full-Time'
        WHEN 4 THEN 'Part-Time' WHEN 5 THEN 'Part-Time' WHEN 6 THEN 'Part-Time'
        WHEN 7 THEN 'Part-Time' WHEN 8 THEN 'Seasonal' WHEN 9 THEN 'Seasonal'
        ELSE 'Part-Time'
    END AS EMPLOYMENT_TYPE,
    DATEADD('day', -UNIFORM(30, 3650, RANDOM()), CURRENT_DATE()) AS HIRE_DATE,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN 'Active' ELSE 'Inactive' END AS STATUS,
    ROUND(UNIFORM(1500, 4500, RANDOM()) / 100.0, 2) AS HOURLY_RATE,
    CASE WHEN UNIFORM(1, 10, RANDOM()) <= 8 THEN UNIFORM(1, 300, RANDOM()) ELSE NULL END AS MANAGER_ID,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN TRUE ELSE FALSE END AS IS_ACTIVE
FROM TABLE(GENERATOR(ROWCOUNT => 6000));

-- MEMBERS (500,000 rows) — FK to BRANCHES (1-20), MEMBERSHIP_TYPES (1-8)
INSERT INTO MEMBERS (FIRST_NAME, LAST_NAME, EMAIL, BRANCH_ID, MEMBERSHIP_TYPE_ID, JOIN_DATE, STATUS, AGE_GROUP, GENDER)
SELECT
    CASE UNIFORM(1, 25, RANDOM())
        WHEN 1 THEN 'John' WHEN 2 THEN 'Mary' WHEN 3 THEN 'Daniel'
        WHEN 4 THEN 'Jessica' WHEN 5 THEN 'Christopher' WHEN 6 THEN 'Ashley'
        WHEN 7 THEN 'Matthew' WHEN 8 THEN 'Stephanie' WHEN 9 THEN 'Andrew'
        WHEN 10 THEN 'Michelle' WHEN 11 THEN 'Joshua' WHEN 12 THEN 'Nicole'
        WHEN 13 THEN 'Brandon' WHEN 14 THEN 'Samantha' WHEN 15 THEN 'Ryan'
        WHEN 16 THEN 'Emily' WHEN 17 THEN 'Tyler' WHEN 18 THEN 'Rachel'
        WHEN 19 THEN 'Jacob' WHEN 20 THEN 'Lauren' WHEN 21 THEN 'Nathan'
        WHEN 22 THEN 'Megan' WHEN 23 THEN 'Justin' WHEN 24 THEN 'Brittany'
        ELSE 'Alex'
    END AS FIRST_NAME,
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN 'Smith' WHEN 2 THEN 'Johnson' WHEN 3 THEN 'Williams'
        WHEN 4 THEN 'Brown' WHEN 5 THEN 'Jones' WHEN 6 THEN 'Garcia'
        WHEN 7 THEN 'Miller' WHEN 8 THEN 'Davis' WHEN 9 THEN 'Rodriguez'
        WHEN 10 THEN 'Martinez' WHEN 11 THEN 'Hernandez' WHEN 12 THEN 'Lopez'
        WHEN 13 THEN 'Gonzalez' WHEN 14 THEN 'Wilson' WHEN 15 THEN 'Anderson'
        WHEN 16 THEN 'Thomas' WHEN 17 THEN 'Taylor' WHEN 18 THEN 'Moore'
        WHEN 19 THEN 'Jackson' ELSE 'Martin'
    END AS LAST_NAME,
    'member' || SEQ4() || '@email.com' AS EMAIL,
    UNIFORM(1, 20, RANDOM()) AS BRANCH_ID,
    UNIFORM(1, 8, RANDOM()) AS MEMBERSHIP_TYPE_ID,
    DATEADD('day', -UNIFORM(1, 1825, RANDOM()), CURRENT_DATE()) AS JOIN_DATE,
    CASE UNIFORM(1, 100, RANDOM())
        WHEN 1 THEN 'Inactive' WHEN 2 THEN 'Inactive' WHEN 3 THEN 'Inactive'
        WHEN 4 THEN 'Frozen' WHEN 5 THEN 'Frozen'
        ELSE 'Active'
    END AS STATUS,
    -- Biased: Adults dominate YMCA membership; Youth/Seniors less common
    CASE
        WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 'Adult (26-44)'
        WHEN UNIFORM(1, 100, RANDOM()) <= 55 THEN 'Adult (45-63)'
        WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Senior (64+)'
        WHEN UNIFORM(1, 100, RANDOM()) <= 83 THEN 'Young Adult (18-25)'
        WHEN UNIFORM(1, 100, RANDOM()) <= 93 THEN 'Youth (5-12)'
        ELSE 'Teen (13-17)'
    END AS AGE_GROUP,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Male' WHEN 2 THEN 'Female' WHEN 3 THEN 'Non-binary'
        ELSE 'Prefer not to say'
    END AS GENDER
FROM TABLE(GENERATOR(ROWCOUNT => 500000));

-- LEADS (500,000 rows) — FK to BRANCHES (1-20)
-- CTE so source roll feeds both SOURCE and conversion probability
INSERT INTO LEADS (FIRST_NAME, LAST_NAME, EMAIL, SOURCE, BRANCH_ID, CREATED_DATE, STATUS, IS_CONVERTED, CONVERTED_DATE)
WITH base AS (
    SELECT
        SEQ4()                        AS seq_num,
        UNIFORM(1, 100, RANDOM())     AS src_roll,
        UNIFORM(1, 100, RANDOM())     AS conv_roll,
        UNIFORM(1, 15, RANDOM())      AS fname_roll,
        UNIFORM(1, 15, RANDOM())      AS lname_roll,
        UNIFORM(1, 20, RANDOM())      AS branch_roll,
        DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_DATE()) AS created_dt
    FROM TABLE(GENERATOR(ROWCOUNT => 500000))
),
enriched AS (
    SELECT *,
        -- Biased source distribution
        CASE
            WHEN src_roll <= 28 THEN 'Website'
            WHEN src_roll <= 48 THEN 'Walk-In'
            WHEN src_roll <= 63 THEN 'Referral'
            WHEN src_roll <= 75 THEN 'Social Media'
            WHEN src_roll <= 84 THEN 'Community Event'
            WHEN src_roll <= 91 THEN 'Google Ads'
            WHEN src_roll <= 96 THEN 'Corporate Partner'
            ELSE 'Email Campaign'
        END AS source_val
    FROM base
)
SELECT
    CASE fname_roll
        WHEN 1 THEN 'Taylor' WHEN 2 THEN 'Jordan' WHEN 3 THEN 'Casey'
        WHEN 4 THEN 'Morgan' WHEN 5 THEN 'Riley' WHEN 6 THEN 'Avery'
        WHEN 7 THEN 'Quinn' WHEN 8 THEN 'Parker' WHEN 9 THEN 'Cameron'
        WHEN 10 THEN 'Dakota' WHEN 11 THEN 'Reese' WHEN 12 THEN 'Harper'
        WHEN 13 THEN 'Finley' WHEN 14 THEN 'Sage' ELSE 'Emerson'
    END AS FIRST_NAME,
    CASE lname_roll
        WHEN 1 THEN 'Rivera' WHEN 2 THEN 'Campbell' WHEN 3 THEN 'Mitchell'
        WHEN 4 THEN 'Roberts' WHEN 5 THEN 'Carter' WHEN 6 THEN 'Phillips'
        WHEN 7 THEN 'Evans' WHEN 8 THEN 'Turner' WHEN 9 THEN 'Torres'
        WHEN 10 THEN 'Parker' WHEN 11 THEN 'Collins' WHEN 12 THEN 'Edwards'
        WHEN 13 THEN 'Stewart' WHEN 14 THEN 'Flores' ELSE 'Morris'
    END AS LAST_NAME,
    'lead' || seq_num || '@email.com' AS EMAIL,
    source_val AS SOURCE,
    branch_roll AS BRANCH_ID,
    created_dt AS CREATED_DATE,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'New' WHEN 2 THEN 'Contacted'
        WHEN 3 THEN 'Qualified' WHEN 4 THEN 'Tour Scheduled'
        WHEN 5 THEN 'Converted' ELSE 'Lost'
    END AS STATUS,
    -- Conversion rate varies meaningfully by source
    CASE
        WHEN source_val = 'Referral'         AND conv_roll <= 40 THEN TRUE
        WHEN source_val = 'Walk-In'          AND conv_roll <= 35 THEN TRUE
        WHEN source_val = 'Community Event'  AND conv_roll <= 28 THEN TRUE
        WHEN source_val = 'Corporate Partner' AND conv_roll <= 25 THEN TRUE
        WHEN source_val = 'Website'          AND conv_roll <= 22 THEN TRUE
        WHEN source_val = 'Email Campaign'   AND conv_roll <= 18 THEN TRUE
        WHEN source_val = 'Google Ads'       AND conv_roll <= 14 THEN TRUE
        WHEN source_val = 'Social Media'     AND conv_roll <= 10 THEN TRUE
        ELSE FALSE
    END AS IS_CONVERTED,
    CASE
        WHEN source_val = 'Referral'         AND conv_roll <= 40
          THEN DATEADD('day', UNIFORM(3, 21, RANDOM()), created_dt)
        WHEN source_val = 'Walk-In'          AND conv_roll <= 35
          THEN DATEADD('day', UNIFORM(1, 14, RANDOM()), created_dt)
        WHEN source_val = 'Community Event'  AND conv_roll <= 28
          THEN DATEADD('day', UNIFORM(7, 30, RANDOM()), created_dt)
        WHEN source_val = 'Corporate Partner' AND conv_roll <= 25
          THEN DATEADD('day', UNIFORM(14, 45, RANDOM()), created_dt)
        WHEN source_val = 'Website'          AND conv_roll <= 22
          THEN DATEADD('day', UNIFORM(3, 30, RANDOM()), created_dt)
        WHEN source_val = 'Email Campaign'   AND conv_roll <= 18
          THEN DATEADD('day', UNIFORM(5, 30, RANDOM()), created_dt)
        WHEN source_val = 'Google Ads'       AND conv_roll <= 14
          THEN DATEADD('day', UNIFORM(3, 21, RANDOM()), created_dt)
        WHEN source_val = 'Social Media'     AND conv_roll <= 10
          THEN DATEADD('day', UNIFORM(7, 45, RANDOM()), created_dt)
        ELSE NULL
    END AS CONVERTED_DATE
FROM enriched;

-- CHILDCARE_PROGRAMS (200 rows) — FK to BRANCHES (1-20)
INSERT INTO CHILDCARE_PROGRAMS (PROGRAM_NAME, PROGRAM_TYPE, BRANCH_ID, CAPACITY, CURRENT_ENROLLMENT, AGE_MIN_MONTHS, AGE_MAX_MONTHS, MONTHLY_FEE, SUBSIDY_ACCEPTED, STATUS)
SELECT
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Before School Program'
        WHEN 2 THEN 'After School Program'
        WHEN 3 THEN 'Preschool'
        WHEN 4 THEN 'Full Day Care'
        WHEN 5 THEN 'Intersession Camp'
        ELSE 'Summer Camp'
    END || ' - Branch ' || UNIFORM(1, 20, RANDOM())::VARCHAR AS PROGRAM_NAME,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Before School'
        WHEN 2 THEN 'After School'
        WHEN 3 THEN 'Preschool'
        WHEN 4 THEN 'Full Day Care'
        WHEN 5 THEN 'Intersession Camp'
        ELSE 'Summer Camp'
    END AS PROGRAM_TYPE,
    UNIFORM(1, 20, RANDOM()) AS BRANCH_ID,
    UNIFORM(15, 45, RANDOM()) AS CAPACITY,
    UNIFORM(8, 42, RANDOM()) AS CURRENT_ENROLLMENT,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 60 WHEN 2 THEN 60 WHEN 3 THEN 24
        WHEN 4 THEN 6 WHEN 5 THEN 60 ELSE 48
    END AS AGE_MIN_MONTHS,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 144 WHEN 2 THEN 144 WHEN 3 THEN 60
        WHEN 4 THEN 60 WHEN 5 THEN 192 ELSE 192
    END AS AGE_MAX_MONTHS,
    ROUND(UNIFORM(300, 1200, RANDOM()), -1) AS MONTHLY_FEE,
    CASE WHEN UNIFORM(1, 10, RANDOM()) <= 8 THEN TRUE ELSE FALSE END AS SUBSIDY_ACCEPTED,
    CASE WHEN UNIFORM(1, 20, RANDOM()) <= 18 THEN 'Active' ELSE 'Waitlist Only' END AS STATUS
FROM TABLE(GENERATOR(ROWCOUNT => 200));

-- =============================================================================
-- LEVEL 3: TABLES WITH FK TO LEVEL 2 TABLES
-- =============================================================================

-- CHILDCARE_ENROLLMENTS (1,000,000 rows) — FK to CHILDCARE_PROGRAMS (1-200)
INSERT INTO CHILDCARE_ENROLLMENTS (PROGRAM_ID, CHILD_FIRST_NAME, CHILD_LAST_NAME, PARENT_NAME, PARENT_EMAIL, ENROLLMENT_DATE, STATUS, SUBSIDY_ELIGIBLE, SUBSIDY_AMOUNT)
SELECT
    UNIFORM(1, 200, RANDOM()) AS PROGRAM_ID,
    CASE UNIFORM(1, 15, RANDOM())
        WHEN 1 THEN 'Emma' WHEN 2 THEN 'Liam' WHEN 3 THEN 'Olivia'
        WHEN 4 THEN 'Noah' WHEN 5 THEN 'Sophia' WHEN 6 THEN 'Aiden'
        WHEN 7 THEN 'Isabella' WHEN 8 THEN 'Lucas' WHEN 9 THEN 'Mia'
        WHEN 10 THEN 'Ethan' WHEN 11 THEN 'Amelia' WHEN 12 THEN 'Mason'
        WHEN 13 THEN 'Charlotte' WHEN 14 THEN 'Logan' ELSE 'Ava'
    END AS CHILD_FIRST_NAME,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Smith' WHEN 2 THEN 'Johnson' WHEN 3 THEN 'Garcia'
        WHEN 4 THEN 'Martinez' WHEN 5 THEN 'Brown' WHEN 6 THEN 'Lee'
        WHEN 7 THEN 'Wilson' WHEN 8 THEN 'Davis' WHEN 9 THEN 'Lopez'
        ELSE 'Anderson'
    END AS CHILD_LAST_NAME,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Jennifer Smith' WHEN 2 THEN 'Michael Johnson'
        WHEN 3 THEN 'Maria Garcia' WHEN 4 THEN 'David Martinez'
        WHEN 5 THEN 'Sarah Brown' WHEN 6 THEN 'Kevin Lee'
        WHEN 7 THEN 'Lisa Wilson' WHEN 8 THEN 'Robert Davis'
        WHEN 9 THEN 'Ana Lopez' ELSE 'Chris Anderson'
    END AS PARENT_NAME,
    'parent' || SEQ4() || '@email.com' AS PARENT_EMAIL,
    DATEADD('day', -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) AS ENROLLMENT_DATE,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Withdrawn' WHEN 2 THEN 'Waitlisted'
        ELSE 'Active'
    END AS STATUS,
    CASE WHEN UNIFORM(1, 10, RANDOM()) <= 4 THEN TRUE ELSE FALSE END AS SUBSIDY_ELIGIBLE,
    CASE WHEN UNIFORM(1, 10, RANDOM()) <= 4 THEN ROUND(UNIFORM(100, 600, RANDOM()), -1) ELSE 0 END AS SUBSIDY_AMOUNT
FROM TABLE(GENERATOR(ROWCOUNT => 1000000));

-- IT_TICKETS (1,500,000 rows) — FK to EMPLOYEES (1-6000), BRANCHES (1-20)
-- CTE assigns category/priority rolls first so resolution time and satisfaction can be correlated
INSERT INTO IT_TICKETS (TICKET_NUMBER, SUBJECT, CATEGORY, SUBCATEGORY, PRIORITY, STATUS, CREATED_DATE, RESOLVED_DATE, EMPLOYEE_ID, BRANCH_ID, ASSIGNED_TECHNICIAN, RESOLUTION_HOURS, SATISFACTION_SCORE)
WITH base AS (
    SELECT
        SEQ4()                          AS seq_num,
        UNIFORM(1, 100, RANDOM())       AS cat_roll,      -- biased category distribution
        UNIFORM(1, 100, RANDOM())       AS pri_roll,      -- priority distribution
        UNIFORM(1, 10,  RANDOM())       AS status_roll,
        UNIFORM(1, 5,   RANDOM())       AS subcat_roll,
        UNIFORM(1, 20,  RANDOM())       AS subject_roll,
        UNIFORM(1, 6,   RANDOM())       AS tech_roll,
        DATEADD('hour', -UNIFORM(1, 17520, RANDOM()), CURRENT_TIMESTAMP()) AS created_ts
    FROM TABLE(GENERATOR(ROWCOUNT => 1500000))
)
SELECT
    'TKT-' || LPAD(seq_num::VARCHAR, 7, '0') AS TICKET_NUMBER,
    CASE subject_roll
        WHEN 1  THEN 'Cannot connect to WiFi'
        WHEN 2  THEN 'Salesforce login error'
        WHEN 3  THEN 'Printer not responding'
        WHEN 4  THEN 'Password reset request'
        WHEN 5  THEN 'VPN connection dropping'
        WHEN 6  THEN 'Email not syncing on mobile'
        WHEN 7  THEN 'New laptop setup needed'
        WHEN 8  THEN 'Software installation request'
        WHEN 9  THEN 'Monitor flickering'
        WHEN 10 THEN 'Zoom audio not working'
        WHEN 11 THEN 'Shared drive access request'
        WHEN 12 THEN 'Computer running slow'
        WHEN 13 THEN 'Badge reader not working'
        WHEN 14 THEN 'Phone system down'
        WHEN 15 THEN 'Cannot access SharePoint'
        WHEN 16 THEN 'Zoho Desk ticket routing issue'
        WHEN 17 THEN 'Security alert - suspicious email'
        WHEN 18 THEN 'Power BI report not loading'
        WHEN 19 THEN 'Projector in conference room broken'
        ELSE 'Application crashing repeatedly'
    END AS SUBJECT,
    -- Biased distribution: Account Access and Software most common, Security rare
    CASE
        WHEN cat_roll <= 22 THEN 'Account Access'
        WHEN cat_roll <= 42 THEN 'Software/Applications'
        WHEN cat_roll <= 55 THEN 'Network/Connectivity'
        WHEN cat_roll <= 65 THEN 'Email/Calendar'
        WHEN cat_roll <= 73 THEN 'Hardware'
        WHEN cat_roll <= 81 THEN 'VPN/Remote Access'
        WHEN cat_roll <= 88 THEN 'Printer/Copier'
        WHEN cat_roll <= 93 THEN 'Phone/Video Conferencing'
        WHEN cat_roll <= 97 THEN 'Database/Reporting'
        ELSE 'Security'
    END AS CATEGORY,
    CASE subcat_roll
        WHEN 1 THEN 'Configuration' WHEN 2 THEN 'Troubleshooting'
        WHEN 3 THEN 'Installation'  WHEN 4 THEN 'Access Request'
        ELSE 'Replacement'
    END AS SUBCATEGORY,
    -- Realistic priority skew: most tickets are P3/P4
    CASE
        WHEN pri_roll <= 5  THEN 'P1'
        WHEN pri_roll <= 20 THEN 'P2'
        WHEN pri_roll <= 65 THEN 'P3'
        ELSE 'P4'
    END AS PRIORITY,
    CASE status_roll
        WHEN 1  THEN 'Open' WHEN 2 THEN 'Open' WHEN 3 THEN 'In Progress'
        WHEN 4  THEN 'In Progress' WHEN 5 THEN 'Awaiting User'
        WHEN 6  THEN 'Resolved' WHEN 7 THEN 'Resolved' WHEN 8 THEN 'Resolved'
        WHEN 9  THEN 'Resolved' ELSE 'Closed'
    END AS STATUS,
    created_ts AS CREATED_DATE,
    CASE WHEN status_roll >= 6
         THEN DATEADD('hour', UNIFORM(1, 48, RANDOM()), created_ts)
         ELSE NULL
    END AS RESOLVED_DATE,
    UNIFORM(1, 6000, RANDOM()) AS EMPLOYEE_ID,
    UNIFORM(1, 20,   RANDOM()) AS BRANCH_ID,
    CASE tech_roll
        WHEN 1 THEN 'Alex Torres' WHEN 2 THEN 'Sam Patel'
        WHEN 3 THEN 'Jordan Rivera' WHEN 4 THEN 'Casey Kim'
        WHEN 5 THEN 'Morgan Chen' ELSE 'Taylor Brooks'
    END AS ASSIGNED_TECHNICIAN,
    -- Resolution hours vary meaningfully by category — this is the key fix
    CASE WHEN status_roll >= 6 THEN
        ROUND(CASE
            WHEN cat_roll <= 22 THEN UNIFORM(0.5, 3.0,  RANDOM())  -- Account Access: 0.5-3h (avg ~1.75h)
            WHEN cat_roll <= 42 THEN UNIFORM(1.0, 8.0,  RANDOM())  -- Software: 1-8h (avg ~4.5h)
            WHEN cat_roll <= 55 THEN UNIFORM(3.0, 18.0, RANDOM())  -- Network: 3-18h (avg ~10.5h)
            WHEN cat_roll <= 65 THEN UNIFORM(1.0, 6.0,  RANDOM())  -- Email: 1-6h (avg ~3.5h)
            WHEN cat_roll <= 73 THEN UNIFORM(24.0, 96.0, RANDOM()) -- Hardware: 24-96h (avg ~60h) — needs parts
            WHEN cat_roll <= 81 THEN UNIFORM(0.5, 4.0,  RANDOM())  -- VPN: 0.5-4h (avg ~2.25h)
            WHEN cat_roll <= 88 THEN UNIFORM(4.0, 24.0, RANDOM())  -- Printer: 4-24h (avg ~14h)
            WHEN cat_roll <= 93 THEN UNIFORM(0.5, 5.0,  RANDOM())  -- Phone/Video: 0.5-5h (avg ~2.75h)
            WHEN cat_roll <= 97 THEN UNIFORM(4.0, 20.0, RANDOM())  -- Database: 4-20h (avg ~12h)
            ELSE                     UNIFORM(12.0, 72.0, RANDOM()) -- Security: 12-72h (avg ~42h) — investigation
        END, 2)
    ELSE NULL END AS RESOLUTION_HOURS,
    -- Satisfaction inversely correlated with resolution time
    CASE WHEN status_roll >= 6 THEN
        CASE
            WHEN cat_roll <= 22 THEN UNIFORM(4, 5, RANDOM())  -- Account Access: mostly 4-5
            WHEN cat_roll <= 42 THEN UNIFORM(3, 5, RANDOM())  -- Software: 3-5
            WHEN cat_roll <= 55 THEN UNIFORM(3, 5, RANDOM())  -- Network: 3-5
            WHEN cat_roll <= 65 THEN UNIFORM(3, 5, RANDOM())  -- Email: 3-5
            WHEN cat_roll <= 73 THEN UNIFORM(2, 4, RANDOM())  -- Hardware: 2-4 (slow = unhappy)
            WHEN cat_roll <= 81 THEN UNIFORM(4, 5, RANDOM())  -- VPN: 4-5
            WHEN cat_roll <= 88 THEN UNIFORM(2, 4, RANDOM())  -- Printer: 2-4
            WHEN cat_roll <= 93 THEN UNIFORM(3, 5, RANDOM())  -- Phone/Video: 3-5
            WHEN cat_roll <= 97 THEN UNIFORM(3, 4, RANDOM())  -- Database: 3-4
            ELSE                     UNIFORM(1, 3, RANDOM())  -- Security: 1-3 (stressful incident)
        END
    ELSE NULL END AS SATISFACTION_SCORE
FROM base;

-- ONBOARDING_TASKS (120,000 rows) — FK to EMPLOYEES (1-6000)
INSERT INTO ONBOARDING_TASKS (EMPLOYEE_ID, TASK_NAME, CATEGORY, DUE_DATE, COMPLETED_DATE, STATUS)
SELECT
    UNIFORM(1, 6000, RANDOM()) AS EMPLOYEE_ID,
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN 'Complete I-9 verification'
        WHEN 2 THEN 'Set up Salesforce account'
        WHEN 3 THEN 'Complete safety training'
        WHEN 4 THEN 'Review employee handbook'
        WHEN 5 THEN 'Submit direct deposit form'
        WHEN 6 THEN 'Complete background check'
        WHEN 7 THEN 'Set up email and calendar'
        WHEN 8 THEN 'Meet with branch director'
        WHEN 9 THEN 'Complete CPR/First Aid certification'
        WHEN 10 THEN 'Review child protection policy'
        WHEN 11 THEN 'Complete IT security training'
        WHEN 12 THEN 'Set up badge access'
        WHEN 13 THEN 'Complete benefits enrollment'
        WHEN 14 THEN 'Shadow experienced staff member'
        WHEN 15 THEN 'Review program-specific SOPs'
        WHEN 16 THEN 'Complete diversity & inclusion training'
        WHEN 17 THEN 'Set up Zoho Service Desk access'
        WHEN 18 THEN 'Complete mandatory reporter training'
        WHEN 19 THEN 'Tour assigned branch facility'
        ELSE 'Submit emergency contact information'
    END AS TASK_NAME,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'HR & Compliance'
        WHEN 2 THEN 'IT Setup'
        WHEN 3 THEN 'Safety & Training'
        WHEN 4 THEN 'Operations'
        ELSE 'Benefits & Payroll'
    END AS CATEGORY,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), DATEADD('day', -UNIFORM(30, 365, RANDOM()), CURRENT_DATE())) AS DUE_DATE,
    CASE WHEN UNIFORM(1, 10, RANDOM()) <= 7
         THEN DATEADD('day', -UNIFORM(1, 60, RANDOM()), CURRENT_DATE())
         ELSE NULL
    END AS COMPLETED_DATE,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Pending' WHEN 2 THEN 'Pending' WHEN 3 THEN 'Pending'
        WHEN 4 THEN 'In Progress' WHEN 5 THEN 'In Progress'
        WHEN 6 THEN 'Completed' WHEN 7 THEN 'Completed' WHEN 8 THEN 'Completed'
        WHEN 9 THEN 'Completed' ELSE 'Overdue'
    END AS STATUS
FROM TABLE(GENERATOR(ROWCOUNT => 120000));

-- =============================================================================
-- VERIFY REFERENTIAL INTEGRITY
-- =============================================================================

SELECT 'EMPLOYEES → BRANCHES' AS fk_check,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN b.BRANCH_ID IS NULL THEN 1 ELSE 0 END) AS orphans
FROM EMPLOYEES e LEFT JOIN BRANCHES b ON e.BRANCH_ID = b.BRANCH_ID
UNION ALL
SELECT 'EMPLOYEES → DEPARTMENTS',
    COUNT(*),
    SUM(CASE WHEN d.DEPARTMENT_ID IS NULL THEN 1 ELSE 0 END)
FROM EMPLOYEES e LEFT JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
UNION ALL
SELECT 'MEMBERS → BRANCHES',
    COUNT(*),
    SUM(CASE WHEN b.BRANCH_ID IS NULL THEN 1 ELSE 0 END)
FROM MEMBERS m LEFT JOIN BRANCHES b ON m.BRANCH_ID = b.BRANCH_ID
UNION ALL
SELECT 'MEMBERS → MEMBERSHIP_TYPES',
    COUNT(*),
    SUM(CASE WHEN mt.MEMBERSHIP_TYPE_ID IS NULL THEN 1 ELSE 0 END)
FROM MEMBERS m LEFT JOIN MEMBERSHIP_TYPES mt ON m.MEMBERSHIP_TYPE_ID = mt.MEMBERSHIP_TYPE_ID
UNION ALL
SELECT 'IT_TICKETS → EMPLOYEES',
    COUNT(*),
    SUM(CASE WHEN e.EMPLOYEE_ID IS NULL THEN 1 ELSE 0 END)
FROM IT_TICKETS t LEFT JOIN EMPLOYEES e ON t.EMPLOYEE_ID = e.EMPLOYEE_ID
UNION ALL
SELECT 'IT_TICKETS → BRANCHES',
    COUNT(*),
    SUM(CASE WHEN b.BRANCH_ID IS NULL THEN 1 ELSE 0 END)
FROM IT_TICKETS t LEFT JOIN BRANCHES b ON t.BRANCH_ID = b.BRANCH_ID
UNION ALL
SELECT 'CHILDCARE_ENROLLMENTS → CHILDCARE_PROGRAMS',
    COUNT(*),
    SUM(CASE WHEN p.PROGRAM_ID IS NULL THEN 1 ELSE 0 END)
FROM CHILDCARE_ENROLLMENTS ce LEFT JOIN CHILDCARE_PROGRAMS p ON ce.PROGRAM_ID = p.PROGRAM_ID
UNION ALL
SELECT 'ONBOARDING_TASKS → EMPLOYEES',
    COUNT(*),
    SUM(CASE WHEN e.EMPLOYEE_ID IS NULL THEN 1 ELSE 0 END)
FROM ONBOARDING_TASKS ot LEFT JOIN EMPLOYEES e ON ot.EMPLOYEE_ID = e.EMPLOYEE_ID;

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
    CASE UNIFORM(1, 7, RANDOM())
        WHEN 1 THEN 'Youth (5-12)' WHEN 2 THEN 'Teen (13-17)'
        WHEN 3 THEN 'Young Adult (18-25)' WHEN 4 THEN 'Adult (26-44)'
        WHEN 5 THEN 'Adult (45-63)' WHEN 6 THEN 'Senior (64+)'
        ELSE 'Adult (26-44)'
    END AS AGE_GROUP,
    CASE UNIFORM(1, 4, RANDOM())
        WHEN 1 THEN 'Male' WHEN 2 THEN 'Female' WHEN 3 THEN 'Non-binary'
        ELSE 'Prefer not to say'
    END AS GENDER
FROM TABLE(GENERATOR(ROWCOUNT => 500000));

-- LEADS (500,000 rows) — FK to BRANCHES (1-20)
INSERT INTO LEADS (FIRST_NAME, LAST_NAME, EMAIL, SOURCE, BRANCH_ID, CREATED_DATE, STATUS, IS_CONVERTED, CONVERTED_DATE)
SELECT
    CASE UNIFORM(1, 15, RANDOM())
        WHEN 1 THEN 'Taylor' WHEN 2 THEN 'Jordan' WHEN 3 THEN 'Casey'
        WHEN 4 THEN 'Morgan' WHEN 5 THEN 'Riley' WHEN 6 THEN 'Avery'
        WHEN 7 THEN 'Quinn' WHEN 8 THEN 'Parker' WHEN 9 THEN 'Cameron'
        WHEN 10 THEN 'Dakota' WHEN 11 THEN 'Reese' WHEN 12 THEN 'Harper'
        WHEN 13 THEN 'Finley' WHEN 14 THEN 'Sage' ELSE 'Emerson'
    END AS FIRST_NAME,
    CASE UNIFORM(1, 15, RANDOM())
        WHEN 1 THEN 'Rivera' WHEN 2 THEN 'Campbell' WHEN 3 THEN 'Mitchell'
        WHEN 4 THEN 'Roberts' WHEN 5 THEN 'Carter' WHEN 6 THEN 'Phillips'
        WHEN 7 THEN 'Evans' WHEN 8 THEN 'Turner' WHEN 9 THEN 'Torres'
        WHEN 10 THEN 'Parker' WHEN 11 THEN 'Collins' WHEN 12 THEN 'Edwards'
        WHEN 13 THEN 'Stewart' WHEN 14 THEN 'Flores' ELSE 'Morris'
    END AS LAST_NAME,
    'lead' || SEQ4() || '@email.com' AS EMAIL,
    CASE UNIFORM(1, 8, RANDOM())
        WHEN 1 THEN 'Website' WHEN 2 THEN 'Walk-In' WHEN 3 THEN 'Referral'
        WHEN 4 THEN 'Social Media' WHEN 5 THEN 'Community Event'
        WHEN 6 THEN 'Corporate Partner' WHEN 7 THEN 'Google Ads'
        ELSE 'Email Campaign'
    END AS SOURCE,
    UNIFORM(1, 20, RANDOM()) AS BRANCH_ID,
    DATEADD('day', -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) AS CREATED_DATE,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'New' WHEN 2 THEN 'Contacted'
        WHEN 3 THEN 'Qualified' WHEN 4 THEN 'Tour Scheduled'
        WHEN 5 THEN 'Converted' ELSE 'Lost'
    END AS STATUS,
    CASE WHEN UNIFORM(1, 6, RANDOM()) = 5 THEN TRUE ELSE FALSE END AS IS_CONVERTED,
    CASE WHEN UNIFORM(1, 6, RANDOM()) = 5
         THEN DATEADD('day', UNIFORM(3, 30, RANDOM()), DATEADD('day', -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()))
         ELSE NULL
    END AS CONVERTED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 500000));

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
INSERT INTO IT_TICKETS (TICKET_NUMBER, SUBJECT, CATEGORY, SUBCATEGORY, PRIORITY, STATUS, CREATED_DATE, RESOLVED_DATE, EMPLOYEE_ID, BRANCH_ID, ASSIGNED_TECHNICIAN, RESOLUTION_HOURS, SATISFACTION_SCORE)
SELECT
    'TKT-' || LPAD(SEQ4()::VARCHAR, 7, '0') AS TICKET_NUMBER,
    CASE UNIFORM(1, 20, RANDOM())
        WHEN 1 THEN 'Cannot connect to WiFi'
        WHEN 2 THEN 'Salesforce login error'
        WHEN 3 THEN 'Printer not responding'
        WHEN 4 THEN 'Password reset request'
        WHEN 5 THEN 'VPN connection dropping'
        WHEN 6 THEN 'Email not syncing on mobile'
        WHEN 7 THEN 'New laptop setup needed'
        WHEN 8 THEN 'Software installation request'
        WHEN 9 THEN 'Monitor flickering'
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
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Network/Connectivity'
        WHEN 2 THEN 'Software/Applications'
        WHEN 3 THEN 'Hardware'
        WHEN 4 THEN 'Account Access'
        WHEN 5 THEN 'Email/Calendar'
        WHEN 6 THEN 'Printer/Copier'
        WHEN 7 THEN 'Security'
        WHEN 8 THEN 'VPN/Remote Access'
        WHEN 9 THEN 'Phone/Video Conferencing'
        ELSE 'Database/Reporting'
    END AS CATEGORY,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'Configuration' WHEN 2 THEN 'Troubleshooting'
        WHEN 3 THEN 'Installation' WHEN 4 THEN 'Access Request'
        ELSE 'Replacement'
    END AS SUBCATEGORY,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'P1' WHEN 2 THEN 'P2' WHEN 3 THEN 'P2'
        WHEN 4 THEN 'P3' WHEN 5 THEN 'P3' WHEN 6 THEN 'P3'
        WHEN 7 THEN 'P3' WHEN 8 THEN 'P4' WHEN 9 THEN 'P4'
        ELSE 'P4'
    END AS PRIORITY,
    CASE UNIFORM(1, 10, RANDOM())
        WHEN 1 THEN 'Open' WHEN 2 THEN 'Open' WHEN 3 THEN 'In Progress'
        WHEN 4 THEN 'In Progress' WHEN 5 THEN 'Awaiting User'
        WHEN 6 THEN 'Resolved' WHEN 7 THEN 'Resolved' WHEN 8 THEN 'Resolved'
        WHEN 9 THEN 'Resolved' ELSE 'Closed'
    END AS STATUS,
    DATEADD('hour', -UNIFORM(1, 4380, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE,
    CASE WHEN UNIFORM(1, 10, RANDOM()) >= 6
         THEN DATEADD('hour', UNIFORM(1, 72, RANDOM()), DATEADD('hour', -UNIFORM(1, 4380, RANDOM()), CURRENT_TIMESTAMP()))
         ELSE NULL
    END AS RESOLVED_DATE,
    UNIFORM(1, 6000, RANDOM()) AS EMPLOYEE_ID,
    UNIFORM(1, 20, RANDOM()) AS BRANCH_ID,
    CASE UNIFORM(1, 6, RANDOM())
        WHEN 1 THEN 'Alex Torres' WHEN 2 THEN 'Sam Patel'
        WHEN 3 THEN 'Jordan Rivera' WHEN 4 THEN 'Casey Kim'
        WHEN 5 THEN 'Morgan Chen' ELSE 'Taylor Brooks'
    END AS ASSIGNED_TECHNICIAN,
    CASE WHEN UNIFORM(1, 10, RANDOM()) >= 6
         THEN ROUND(UNIFORM(1, 72, RANDOM()) + UNIFORM(0, 100, RANDOM()) / 100.0, 2)
         ELSE NULL
    END AS RESOLUTION_HOURS,
    CASE WHEN UNIFORM(1, 10, RANDOM()) >= 6
         THEN UNIFORM(1, 5, RANDOM())
         ELSE NULL
    END AS SATISFACTION_SCORE
FROM TABLE(GENERATOR(ROWCOUNT => 1500000));

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

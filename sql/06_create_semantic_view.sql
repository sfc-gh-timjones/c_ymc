USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

-- Semantic view DDL syntax: `table_alias.semantic_name AS column_expression`
-- LEFT side of AS = the user-facing fact/dimension/metric name
-- RIGHT side of AS = the physical column or SQL expression in the source table
CREATE OR REPLACE SEMANTIC VIEW YMC_SEMANTIC_VIEW
  TABLES (
    branches         AS CUSTOMER_DEMOS.YMC.BRANCHES         PRIMARY KEY (BRANCH_ID),
    membership_types AS CUSTOMER_DEMOS.YMC.MEMBERSHIP_TYPES PRIMARY KEY (MEMBERSHIP_TYPE_ID),
    departments      AS CUSTOMER_DEMOS.YMC.DEPARTMENTS      PRIMARY KEY (DEPARTMENT_ID),
    employees        AS CUSTOMER_DEMOS.YMC.EMPLOYEES        PRIMARY KEY (EMPLOYEE_ID),
    members          AS CUSTOMER_DEMOS.YMC.MEMBERS          PRIMARY KEY (MEMBER_ID),
    leads            AS CUSTOMER_DEMOS.YMC.LEADS            PRIMARY KEY (LEAD_ID),
    childcare_programs     AS CUSTOMER_DEMOS.YMC.CHILDCARE_PROGRAMS     PRIMARY KEY (PROGRAM_ID),
    childcare_enrollments  AS CUSTOMER_DEMOS.YMC.CHILDCARE_ENROLLMENTS  PRIMARY KEY (ENROLLMENT_ID),
    it_tickets       AS CUSTOMER_DEMOS.YMC.IT_TICKETS       PRIMARY KEY (TICKET_ID),
    onboarding_tasks AS CUSTOMER_DEMOS.YMC.ONBOARDING_TASKS PRIMARY KEY (TASK_ID)
  )
  RELATIONSHIPS (
    employees(DEPARTMENT_ID)          REFERENCES departments,
    employees(BRANCH_ID)              REFERENCES branches,
    members(BRANCH_ID)                REFERENCES branches,
    members(MEMBERSHIP_TYPE_ID)       REFERENCES membership_types,
    leads(BRANCH_ID)                  REFERENCES branches,
    childcare_programs(BRANCH_ID)     REFERENCES branches,
    childcare_enrollments(PROGRAM_ID) REFERENCES childcare_programs,
    it_tickets(EMPLOYEE_ID)           REFERENCES employees,
    it_tickets(BRANCH_ID)             REFERENCES branches,
    onboarding_tasks(EMPLOYEE_ID)     REFERENCES employees
  )
  FACTS (
    membership_types.monthly_fee         AS MONTHLY_FEE,
    membership_types.annual_fee          AS ANNUAL_FEE,
    employees.hourly_rate                AS HOURLY_RATE,
    childcare_programs.capacity          AS CAPACITY,
    childcare_programs.current_enrollment AS CURRENT_ENROLLMENT,
    childcare_programs.program_monthly_fee AS MONTHLY_FEE,
    childcare_enrollments.subsidy_amount AS SUBSIDY_AMOUNT,
    it_tickets.resolution_hours          AS RESOLUTION_HOURS,
    it_tickets.satisfaction_score        AS SATISFACTION_SCORE
  )
  DIMENSIONS (
    branches.branch_id       AS BRANCH_ID,
    branches.branch_name     AS BRANCH_NAME,
    branches.city            AS CITY,
    branches.region          AS REGION,
    branches.director_name   AS DIRECTOR_NAME,
    membership_types.type_name AS TYPE_NAME,
    membership_types.category  AS CATEGORY,
    departments.department_id      AS DEPARTMENT_ID,
    departments.department_name    AS DEPARTMENT_NAME,
    departments.division           AS DIVISION,
    employees.employee_id          AS EMPLOYEE_ID,
    employees.first_name           AS FIRST_NAME,
    employees.last_name            AS LAST_NAME,
    employees.position_title       AS POSITION_TITLE,
    employees.employment_type      AS EMPLOYMENT_TYPE,
    employees.hire_date            AS HIRE_DATE,
    employees.status               AS STATUS,
    employees.is_active            AS IS_ACTIVE,
    members.member_id              AS MEMBER_ID,
    members.first_name             AS FIRST_NAME,
    members.last_name              AS LAST_NAME,
    members.join_date              AS JOIN_DATE,
    members.status                 AS STATUS,
    members.age_group              AS AGE_GROUP,
    members.gender                 AS GENDER,
    leads.lead_id                  AS LEAD_ID,
    leads.source                   AS SOURCE,
    leads.created_date             AS CREATED_DATE,
    leads.status                   AS STATUS,
    leads.is_converted             AS IS_CONVERTED,
    childcare_programs.program_id   AS PROGRAM_ID,
    childcare_programs.program_name AS PROGRAM_NAME,
    childcare_programs.program_type AS PROGRAM_TYPE,
    childcare_programs.status       AS STATUS,
    childcare_enrollments.enrollment_id   AS ENROLLMENT_ID,
    childcare_enrollments.enrollment_date AS ENROLLMENT_DATE,
    childcare_enrollments.status          AS STATUS,
    it_tickets.ticket_id           AS TICKET_ID,
    it_tickets.ticket_number       AS TICKET_NUMBER,
    it_tickets.subject             AS SUBJECT,
    it_tickets.category            AS CATEGORY,
    it_tickets.subcategory         AS SUBCATEGORY,
    it_tickets.priority            AS PRIORITY,
    it_tickets.status              AS STATUS,
    it_tickets.created_date        AS CREATED_DATE,
    it_tickets.assigned_technician AS ASSIGNED_TECHNICIAN,
    onboarding_tasks.task_id       AS TASK_ID,
    onboarding_tasks.task_name     AS TASK_NAME,
    onboarding_tasks.category      AS CATEGORY,
    onboarding_tasks.due_date      AS DUE_DATE,
    onboarding_tasks.status        AS STATUS
  )
  METRICS (
    it_tickets.avg_resolution_hours AS AVG(it_tickets.RESOLUTION_HOURS),
    it_tickets.avg_satisfaction     AS AVG(it_tickets.SATISFACTION_SCORE),
    members.total_members           AS COUNT(members.MEMBER_ID),
    employees.total_employees       AS COUNT(employees.EMPLOYEE_ID),
    childcare_enrollments.total_enrollments AS COUNT(childcare_enrollments.ENROLLMENT_ID)
  )
  COMMENT = 'YMCA of San Diego County operational analytics — IT tickets, membership, childcare, workforce, and lead pipeline'
  AI_SQL_GENERATION '
    Domain: YMCA of San Diego County — nonprofit, ~6,000 employees, 144,000+ members, ~20 San Diego County branches.
    Fiscal year: July 1 through June 30.
    IT ticket priorities: P1=Critical, P2=High, P3=Medium, P4=Low.
    Open tickets include statuses: Open, In Progress, Awaiting User.
    New hires: HIRE_DATE in last 90 days.
  '
  AI_QUESTION_CATEGORIZATION '
    HR policies, PTO, benefits → HRPolicySearch tool.
    IT troubleshooting, password reset, VPN → ITKnowledgeBaseSearch tool.
    Childcare ratios, aquatics safety, camp procedures → SOPSearch tool.
    Quantitative questions about tickets, members, enrollment, headcount, revenue → use this semantic view.
  '
  AI_VERIFIED_QUERIES (
    open_tickets_by_priority AS (
      QUESTION 'What are our current open IT tickets by priority?'
      SQL 'SELECT it_tickets.PRIORITY, COUNT(*) AS ticket_count FROM it_tickets WHERE it_tickets.STATUS IN (''Open'', ''In Progress'', ''Awaiting User'') GROUP BY it_tickets.PRIORITY ORDER BY it_tickets.PRIORITY'
      ONBOARDING_QUESTION TRUE
    ),
    avg_resolution_by_category AS (
      QUESTION 'What is the average IT ticket resolution time by category?'
      SQL 'SELECT it_tickets.CATEGORY, ROUND(AVG(it_tickets.RESOLUTION_HOURS), 1) AS avg_hours, COUNT(*) AS resolved_tickets FROM it_tickets WHERE it_tickets.RESOLUTION_HOURS IS NOT NULL GROUP BY it_tickets.CATEGORY ORDER BY avg_hours DESC'
      ONBOARDING_QUESTION TRUE
    ),
    membership_by_branch AS (
      QUESTION 'How many active members does each branch have?'
      SQL 'SELECT branches.BRANCH_NAME, branches.REGION, COUNT(*) AS active_members FROM members JOIN branches ON members.BRANCH_ID = branches.BRANCH_ID WHERE members.STATUS = ''Active'' GROUP BY branches.BRANCH_NAME, branches.REGION ORDER BY active_members DESC'
      ONBOARDING_QUESTION TRUE
    ),
    childcare_capacity_utilization AS (
      QUESTION 'Which childcare programs are at or near full capacity?'
      SQL 'SELECT childcare_programs.PROGRAM_NAME, childcare_programs.PROGRAM_TYPE, branches.BRANCH_NAME, childcare_programs.CAPACITY, childcare_programs.CURRENT_ENROLLMENT, ROUND(childcare_programs.CURRENT_ENROLLMENT * 100.0 / childcare_programs.CAPACITY, 1) AS utilization_pct FROM childcare_programs JOIN branches ON childcare_programs.BRANCH_ID = branches.BRANCH_ID WHERE childcare_programs.STATUS = ''Active'' ORDER BY utilization_pct DESC'
    ),
    onboarding_completion_by_dept AS (
      QUESTION 'What is the employee onboarding task completion rate by department?'
      SQL 'SELECT departments.DEPARTMENT_NAME, COUNT(onboarding_tasks.TASK_ID) AS total_tasks, SUM(CASE WHEN onboarding_tasks.STATUS = ''Completed'' THEN 1 ELSE 0 END) AS completed_tasks, ROUND(SUM(CASE WHEN onboarding_tasks.STATUS = ''Completed'' THEN 1 ELSE 0 END) * 100.0 / COUNT(onboarding_tasks.TASK_ID), 1) AS completion_pct FROM onboarding_tasks JOIN employees ON onboarding_tasks.EMPLOYEE_ID = employees.EMPLOYEE_ID JOIN departments ON employees.DEPARTMENT_ID = departments.DEPARTMENT_ID GROUP BY departments.DEPARTMENT_NAME ORDER BY completion_pct DESC'
    ),
    ticket_volume_trend AS (
      QUESTION 'How has IT ticket volume trended over the last 6 months?'
      SQL 'SELECT DATE_TRUNC(''month'', it_tickets.CREATED_DATE) AS month, COUNT(*) AS ticket_count FROM it_tickets WHERE it_tickets.CREATED_DATE >= DATEADD(''month'', -6, CURRENT_TIMESTAMP()) GROUP BY month ORDER BY month'
    ),
    lead_conversion_by_source AS (
      QUESTION 'What is our lead conversion rate by source this fiscal year?'
      SQL 'SELECT leads.SOURCE, COUNT(*) AS total_leads, SUM(CASE WHEN leads.IS_CONVERTED = TRUE THEN 1 ELSE 0 END) AS converted, ROUND(SUM(CASE WHEN leads.IS_CONVERTED = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS conversion_rate_pct FROM leads WHERE leads.CREATED_DATE >= ''2025-07-01'' GROUP BY leads.SOURCE ORDER BY conversion_rate_pct DESC'
    ),
    member_revenue_by_type AS (
      QUESTION 'What is total estimated membership revenue by membership type?'
      SQL 'SELECT membership_types.TYPE_NAME, COUNT(*) AS active_members, membership_types.MONTHLY_FEE, COUNT(*) * membership_types.MONTHLY_FEE AS estimated_monthly_revenue FROM members JOIN membership_types ON members.MEMBERSHIP_TYPE_ID = membership_types.MEMBERSHIP_TYPE_ID WHERE members.STATUS = ''Active'' GROUP BY membership_types.TYPE_NAME, membership_types.MONTHLY_FEE ORDER BY estimated_monthly_revenue DESC'
    )
  );

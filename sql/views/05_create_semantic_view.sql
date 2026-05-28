USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

CREATE OR REPLACE SEMANTIC VIEW YMC_SEMANTIC_VIEW
  COMMENT = 'YMCA of San Diego County operational analytics — IT tickets, membership, childcare, workforce, and lead pipeline'
  DISTRIBUTION = 'ALL'
  TABLES (
    branches AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.BRANCHES'
      SYNONYM = 'branches'
      PRIMARY_KEY = (BRANCH_ID)
      DIMENSIONS (
        BRANCH_ID COMMENT 'Unique branch identifier',
        BRANCH_NAME COMMENT 'YMCA branch name',
        CITY COMMENT 'City where branch is located',
        REGION COMMENT 'Geographic region: Central, North Inland, North Coastal, East County, South, Coastal',
        DIRECTOR_NAME COMMENT 'Name of the branch director'
      )
    ),
    membership_types AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.MEMBERSHIP_TYPES'
      SYNONYM = 'membership_types'
      PRIMARY_KEY = (MEMBERSHIP_TYPE_ID)
      DIMENSIONS (
        MEMBERSHIP_TYPE_ID COMMENT 'Unique membership type identifier',
        TYPE_NAME COMMENT 'Membership type name: Individual Adult, Couple, Family, Senior Individual, Senior Couple, Young Adult (18-25), Youth (12-17), Corporate',
        CATEGORY COMMENT 'Membership category: Adult, Family, Senior, Young Adult, Youth, Corporate'
      )
      FACTS (
        MONTHLY_FEE COMMENT 'Monthly membership fee in USD',
        ANNUAL_FEE COMMENT 'Annual membership fee in USD'
      )
    ),
    departments AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.DEPARTMENTS'
      SYNONYM = 'departments'
      PRIMARY_KEY = (DEPARTMENT_ID)
      DIMENSIONS (
        DEPARTMENT_ID COMMENT 'Unique department identifier',
        DEPARTMENT_NAME COMMENT 'Department name: Aquatics, Youth Development, Childcare, Fitness & Wellness, Facilities & Maintenance, Information Technology, Human Resources, Finance & Accounting, Community Programs, Camp Services, Membership Services, Marketing & Communications, Development & Fundraising, Executive, Social Services',
        DIVISION COMMENT 'Division: Programs, Operations, Administration',
        COST_CENTER COMMENT 'Cost center code'
      )
    ),
    employees AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.EMPLOYEES'
      SYNONYM = 'employees'
      PRIMARY_KEY = (EMPLOYEE_ID)
      DIMENSIONS (
        EMPLOYEE_ID COMMENT 'Unique employee identifier',
        FIRST_NAME COMMENT 'Employee first name',
        LAST_NAME COMMENT 'Employee last name',
        EMAIL COMMENT 'Employee email address',
        POSITION_TITLE COMMENT 'Job title',
        EMPLOYMENT_TYPE COMMENT 'Employment type: Full-Time, Part-Time, Seasonal',
        HIRE_DATE COMMENT 'Date employee was hired',
        STATUS COMMENT 'Employee status: Active or Inactive',
        IS_ACTIVE COMMENT 'Whether employee is currently active'
      )
      FACTS (
        HOURLY_RATE COMMENT 'Hourly pay rate in USD',
        DEPARTMENT_ID COMMENT 'FK to departments table',
        BRANCH_ID COMMENT 'FK to branches table'
      )
    ),
    members AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.MEMBERS'
      SYNONYM = 'members'
      PRIMARY_KEY = (MEMBER_ID)
      DIMENSIONS (
        MEMBER_ID COMMENT 'Unique member identifier',
        FIRST_NAME COMMENT 'Member first name',
        LAST_NAME COMMENT 'Member last name',
        EMAIL COMMENT 'Member email',
        JOIN_DATE COMMENT 'Date the member joined',
        STATUS COMMENT 'Member status: Active, Inactive, or Frozen',
        AGE_GROUP COMMENT 'Age group: Youth (5-12), Teen (13-17), Young Adult (18-25), Adult (26-44), Adult (45-63), Senior (64+)',
        GENDER COMMENT 'Member gender: Male, Female, Non-binary, Prefer not to say'
      )
      FACTS (
        BRANCH_ID COMMENT 'FK to branches table',
        MEMBERSHIP_TYPE_ID COMMENT 'FK to membership_types table'
      )
    ),
    leads AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.LEADS'
      SYNONYM = 'leads'
      PRIMARY_KEY = (LEAD_ID)
      DIMENSIONS (
        LEAD_ID COMMENT 'Unique lead identifier',
        FIRST_NAME COMMENT 'Lead first name',
        LAST_NAME COMMENT 'Lead last name',
        SOURCE COMMENT 'Lead source: Website, Walk-In, Referral, Social Media, Community Event, Corporate Partner, Google Ads, Email Campaign',
        CREATED_DATE COMMENT 'Date lead was created',
        STATUS COMMENT 'Lead status: New, Contacted, Qualified, Tour Scheduled, Converted, Lost',
        IS_CONVERTED COMMENT 'Whether lead has been converted to a member',
        CONVERTED_DATE COMMENT 'Date lead was converted'
      )
      FACTS (
        BRANCH_ID COMMENT 'FK to branches table'
      )
    ),
    childcare_programs AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.CHILDCARE_PROGRAMS'
      SYNONYM = 'childcare_programs'
      PRIMARY_KEY = (PROGRAM_ID)
      DIMENSIONS (
        PROGRAM_ID COMMENT 'Unique program identifier',
        PROGRAM_NAME COMMENT 'Childcare program name',
        PROGRAM_TYPE COMMENT 'Program type: Before School, After School, Preschool, Full Day Care, Intersession Camp, Summer Camp',
        SUBSIDY_ACCEPTED COMMENT 'Whether program accepts subsidy',
        STATUS COMMENT 'Program status: Active or Waitlist Only'
      )
      FACTS (
        CAPACITY COMMENT 'Maximum enrollment capacity',
        CURRENT_ENROLLMENT COMMENT 'Current number of children enrolled',
        AGE_MIN_MONTHS COMMENT 'Minimum age in months',
        AGE_MAX_MONTHS COMMENT 'Maximum age in months',
        MONTHLY_FEE COMMENT 'Monthly program fee in USD',
        BRANCH_ID COMMENT 'FK to branches table'
      )
    ),
    childcare_enrollments AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.CHILDCARE_ENROLLMENTS'
      SYNONYM = 'childcare_enrollments'
      PRIMARY_KEY = (ENROLLMENT_ID)
      DIMENSIONS (
        ENROLLMENT_ID COMMENT 'Unique enrollment identifier',
        CHILD_FIRST_NAME COMMENT 'Child first name',
        CHILD_LAST_NAME COMMENT 'Child last name',
        PARENT_NAME COMMENT 'Parent or guardian name',
        ENROLLMENT_DATE COMMENT 'Date of enrollment',
        STATUS COMMENT 'Enrollment status: Active, Withdrawn, Waitlisted',
        SUBSIDY_ELIGIBLE COMMENT 'Whether child is eligible for subsidy'
      )
      FACTS (
        SUBSIDY_AMOUNT COMMENT 'Monthly subsidy amount in USD',
        PROGRAM_ID COMMENT 'FK to childcare_programs table'
      )
    ),
    it_tickets AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.IT_TICKETS'
      SYNONYM = 'it_tickets'
      PRIMARY_KEY = (TICKET_ID)
      DIMENSIONS (
        TICKET_ID COMMENT 'Unique ticket identifier',
        TICKET_NUMBER COMMENT 'Display ticket number (e.g. TKT-00001)',
        SUBJECT COMMENT 'Ticket subject/description',
        CATEGORY COMMENT 'IT ticket category: Network/Connectivity, Software/Applications, Hardware, Account Access, Email/Calendar, Printer/Copier, Security, VPN/Remote Access, Phone/Video Conferencing, Database/Reporting',
        SUBCATEGORY COMMENT 'Ticket subcategory: Configuration, Troubleshooting, Installation, Access Request, Replacement',
        PRIORITY COMMENT 'Priority level: P1 (Critical), P2 (High), P3 (Medium), P4 (Low)',
        STATUS COMMENT 'Ticket status: Open, In Progress, Awaiting User, Resolved, Closed',
        CREATED_DATE COMMENT 'Date and time ticket was created',
        RESOLVED_DATE COMMENT 'Date and time ticket was resolved (NULL if still open)',
        ASSIGNED_TECHNICIAN COMMENT 'Name of assigned IT technician'
      )
      FACTS (
        RESOLUTION_HOURS COMMENT 'Hours from creation to resolution',
        SATISFACTION_SCORE COMMENT 'User satisfaction score 1-5 (5 is best)',
        EMPLOYEE_ID COMMENT 'FK to employees table - the requestor',
        BRANCH_ID COMMENT 'FK to branches table'
      )
    ),
    onboarding_tasks AS (
      BASE_TABLE = 'CUSTOMER_DEMOS.YMC.ONBOARDING_TASKS'
      SYNONYM = 'onboarding_tasks'
      PRIMARY_KEY = (TASK_ID)
      DIMENSIONS (
        TASK_ID COMMENT 'Unique task identifier',
        TASK_NAME COMMENT 'Name of the onboarding task',
        CATEGORY COMMENT 'Task category: HR & Compliance, IT Setup, Safety & Training, Operations, Benefits & Payroll',
        DUE_DATE COMMENT 'Task due date',
        COMPLETED_DATE COMMENT 'Date task was completed (NULL if not completed)',
        STATUS COMMENT 'Task status: Pending, In Progress, Completed, Overdue'
      )
      FACTS (
        EMPLOYEE_ID COMMENT 'FK to employees table'
      )
    )
  )
  RELATIONSHIPS (
    employees.DEPARTMENT_ID REFERENCES departments.DEPARTMENT_ID,
    employees.BRANCH_ID REFERENCES branches.BRANCH_ID,
    members.BRANCH_ID REFERENCES branches.BRANCH_ID,
    members.MEMBERSHIP_TYPE_ID REFERENCES membership_types.MEMBERSHIP_TYPE_ID,
    leads.BRANCH_ID REFERENCES branches.BRANCH_ID,
    childcare_programs.BRANCH_ID REFERENCES branches.BRANCH_ID,
    childcare_enrollments.PROGRAM_ID REFERENCES childcare_programs.PROGRAM_ID,
    it_tickets.EMPLOYEE_ID REFERENCES employees.EMPLOYEE_ID,
    it_tickets.BRANCH_ID REFERENCES branches.BRANCH_ID,
    onboarding_tasks.EMPLOYEE_ID REFERENCES employees.EMPLOYEE_ID
  )
  AI_SQL_GENERATION = '
    Domain: YMCA of San Diego County — nonprofit community organization with ~6,000 employees serving 144,000+ members across ~20 branches in San Diego County, California.

    Fiscal year: July 1 through June 30. When users say "this year" they mean the current fiscal year.

    Employment types: Full-Time, Part-Time, Seasonal. Majority of staff are Part-Time.

    IT ticket priorities: P1 = Critical (4-hour SLA), P2 = High (24-hour SLA), P3 = Medium (48-hour SLA), P4 = Low (72-hour SLA).

    Ticket status lifecycle: Open → In Progress → Awaiting User → Resolved → Closed.

    Regions in San Diego County: Central (downtown/midcity), North Inland (Escondido, Poway, Rancho Bernardo), North Coastal (Oceanside, Encinitas, Vista), East County (La Mesa, El Cajon, Santee, Spring Valley), South (Chula Vista, National City, Imperial Beach), Coastal (Peninsula).

    When asked about "open" tickets, include statuses: Open, In Progress, Awaiting User.
    When asked about resolution time, use RESOLUTION_HOURS column.
    When asked about new hires, look for employees with HIRE_DATE in the last 90 days.
  '
  AI_QUESTION_CATEGORIZATION = '
    Route questions about HR policies, PTO, benefits, employee handbook, code of conduct, leave of absence, payroll, direct deposit → HRPolicySearch tool.
    Route questions about IT troubleshooting steps, how to reset password, VPN setup, software installation, printer fix, hardware setup → ITKnowledgeBaseSearch tool.
    Route questions about childcare ratios, aquatics safety, camp procedures, emergency protocols, member check-in SOPs, program standards → SOPSearch tool.
    All quantitative questions about ticket counts, resolution times, member numbers, enrollment, headcount, conversion rates, revenue → use this semantic view.
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

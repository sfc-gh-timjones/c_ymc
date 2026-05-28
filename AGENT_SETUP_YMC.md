# AGENT_SETUP_YMC — Demo Questions & Setup Guide

## Agent Configuration

| Setting | Value |
|---------|-------|
| Name | YMC_AGENT |
| Display Name | YMC Assistant |
| Schema | CUSTOMER_DEMOS.YMC |
| Model | claude-sonnet-4.6 |
| Budget | 360 seconds / 32,000 tokens |
| Tools | YmcAnalyst, HRPolicySearch, ITKnowledgeBaseSearch, SOPSearch, SendEmail, data_to_chart |

---

## Demo Questions by Category

### IT Help Desk — Structured Data (→ YmcAnalyst)

1. What are our current open IT tickets by priority?
2. What is the average IT ticket resolution time by category?
3. Which branches have the most open IT tickets right now?
4. How many P1 tickets were created in the last month?
5. Which IT technician has the highest ticket volume?
6. What is the ticket satisfaction score average by technician?
7. How has IT ticket volume trended over the last 6 months?
8. What IT categories have the longest average resolution time?
9. How many tickets are currently awaiting user response?
10. What percentage of P2 tickets breach our 24-hour SLA?

### IT Help Desk — Knowledge Base (→ ITKnowledgeBaseSearch)

11. How do I reset my Salesforce password?
12. How do I set up VPN to work from home?
13. How do I submit an IT ticket in Zoho Desk?
14. How do I set up Microsoft Teams on my phone?
15. How do I access shared files in OneDrive?
16. What should I do if my email isn't syncing?

### HR & People — Policies (→ HRPolicySearch)

17. What is the PTO policy for part-time employees?
18. How do I enroll in benefits?
19. What is the dress code policy?
20. How do I request a leave of absence?
21. What is the process for performance reviews?
22. How do I update my direct deposit information?
23. What is the anti-harassment policy?
24. What are the rules about social media use at work?

### HR & People — Analytics (→ YmcAnalyst)

25. How many new employees were hired in the last 90 days?
26. What is the onboarding task completion rate by department?
27. What is our full-time vs part-time employee breakdown?
28. Which departments have the most employees in onboarding?
29. What is the average tenure of our active employees?

### Childcare & Programs — SOPs (→ SOPSearch)

30. What are the required staff-to-child ratios for preschool programs?
31. What is the aquatics emergency action plan?
32. What are the rules for participation in team events?
33. What should staff do in a pool emergency?
34. What are the overnight camp health screening procedures?

### Childcare & Programs — Analytics (→ YmcAnalyst)

35. Which childcare programs are at or near full capacity?
36. How many children are receiving subsidy assistance?
37. What is the average childcare program utilization rate?
38. How many active enrollments do we have by program type?

### Membership & Operations (→ YmcAnalyst)

39. How many active members does each branch have?
40. What is our lead conversion rate by source?
41. Which membership type generates the most revenue?
42. What is the age group distribution of our members?
43. How many leads came in through referrals this quarter?

### Cross-Tool / Email (→ SendEmail + YmcAnalyst)

44. Send me a summary of today's open IT tickets by priority.
45. Email me a report of childcare utilization across all branches.

---

## Table Schemas

### BRANCHES (20 rows)
BRANCH_ID, BRANCH_NAME, CITY, REGION, DIRECTOR_NAME, PHONE, ADDRESS

### MEMBERSHIP_TYPES (8 rows)
MEMBERSHIP_TYPE_ID, TYPE_NAME, CATEGORY, MONTHLY_FEE, ANNUAL_FEE

### DEPARTMENTS (15 rows)
DEPARTMENT_ID, DEPARTMENT_NAME, DIVISION, COST_CENTER

### EMPLOYEES (500 rows)
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, DEPARTMENT_ID, BRANCH_ID, POSITION_TITLE, EMPLOYMENT_TYPE, HIRE_DATE, STATUS, HOURLY_RATE, MANAGER_ID, IS_ACTIVE

### MEMBERS (800 rows)
MEMBER_ID, FIRST_NAME, LAST_NAME, EMAIL, BRANCH_ID, MEMBERSHIP_TYPE_ID, JOIN_DATE, STATUS, AGE_GROUP, GENDER

### LEADS (300 rows)
LEAD_ID, FIRST_NAME, LAST_NAME, EMAIL, SOURCE, BRANCH_ID, CREATED_DATE, STATUS, IS_CONVERTED, CONVERTED_DATE

### CHILDCARE_PROGRAMS (40 rows)
PROGRAM_ID, PROGRAM_NAME, PROGRAM_TYPE, BRANCH_ID, CAPACITY, CURRENT_ENROLLMENT, AGE_MIN_MONTHS, AGE_MAX_MONTHS, MONTHLY_FEE, SUBSIDY_ACCEPTED, STATUS

### CHILDCARE_ENROLLMENTS (600 rows)
ENROLLMENT_ID, PROGRAM_ID, CHILD_FIRST_NAME, CHILD_LAST_NAME, PARENT_NAME, PARENT_EMAIL, ENROLLMENT_DATE, STATUS, SUBSIDY_ELIGIBLE, SUBSIDY_AMOUNT

### IT_TICKETS (500 rows)
TICKET_ID, TICKET_NUMBER, SUBJECT, CATEGORY, SUBCATEGORY, PRIORITY, STATUS, CREATED_DATE, RESOLVED_DATE, EMPLOYEE_ID, BRANCH_ID, ASSIGNED_TECHNICIAN, RESOLUTION_HOURS, SATISFACTION_SCORE

### ONBOARDING_TASKS (1000 rows)
TASK_ID, EMPLOYEE_ID, TASK_NAME, CATEGORY, DUE_DATE, COMPLETED_DATE, STATUS

---

## Deployment Steps

1. Ensure ACCOUNTADMIN role and Cortex AI enabled
2. Run `sql/TEARDOWN_AND_REBUILD.sql` in a Snowsight worksheet or Workspace
3. Wait 1-2 minutes for Cortex Search services to index
4. Navigate to Snowflake Intelligence → select "YMC Assistant"
5. Test with sample questions above

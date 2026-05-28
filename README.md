# YMCA San Diego County — Snowflake Intelligence Demo

> Internal "Swiss Army Knife" agent for IT help desk, HR policies, SOPs, and operational analytics.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Snowflake Intelligence UI                      │
│                      "YMC Assistant"                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    ┌────────┴────────┐
                    │   YMC_AGENT      │
                    │  (Cortex Agent)  │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────┴────┐        ┌─────┴─────┐       ┌─────┴─────┐
   │YmcAnalyst│        │  Search   │       │  SendEmail │
   │(Semantic │        │ Services  │       │(Procedure) │
   │  View)   │        │           │       └───────────┘
   └────┬────┘        ├───────────┤
        │             │HR Policy  │
   10 tables          │IT KB      │
   8 VQRs             │SOPs       │
                      └───────────┘
```

## Quick Start

Complete Steps 1 and 2 below and the demo environment will be fully set up and ready to run.

### Step 1: Create a Git API Integration & Connect Your Workspace

Before running any scripts, you need a Git API integration so Snowflake can pull from this repo — and a Workspace linked to it so you can browse and run the files.

1. Navigate to **Projects → Workspaces** in Snowsight.
2. Open a blank SQL file and run the following as `ACCOUNTADMIN`:

```sql
USE ROLE ACCOUNTADMIN;

CREATE API INTEGRATION IF NOT EXISTS GIT_HUB_INTEGRATION
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ENABLED = TRUE;
```

3. At the top of the left-hand file pane, click the **dropdown arrow** next to your current workspace name (likely **My Workspace**).
4. Select **From Git repository**.
5. Fill in the form:
   - **Repository URL:** `https://github.com/sfc-gh-timjones/c_ymc`
   - **Workspace name:** e.g. `YMC Demo`
   - **API integration:** select `GIT_HUB_INTEGRATION` (the one you just created)

   > If `GIT_HUB_INTEGRATION` doesn't appear in the dropdown, log out and log back in — since it was just created, Snowsight may not have picked it up yet.

   - **Repository access:** select **Public repository**

   > Note: public repositories are read-only — you will not be able to push changes from this Workspace.

6. Click **Create**.

Your Workspace is now connected to the repo and all scripts are accessible in the left pane.

### Step 2: Deploy the Demo Environment

| Script | What it does |
|--------|--------------|
| sql/TEARDOWN_AND_REBUILD.sql | Run this next. Tears down any existing objects, runs all setup scripts in order. After this, the demo environment is ready. |

### Step 3: Access the Agent in Snowflake Intelligence

Navigate to **Snowflake Intelligence** in the left nav → Select **YMC Assistant**.

## Objects Created

| Object Type | Name | Description |
|-------------|------|-------------|
| Database | CUSTOMER_DEMOS | Shared demo database |
| Schema | CUSTOMER_DEMOS.YMC | All demo objects |
| Warehouse | YMC_WH | XSmall, auto-suspend 30s |
| Agent | YMC_AGENT | Main SI agent |
| Semantic View | YMC_SEMANTIC_VIEW | 10 tables, 8 VQRs |
| Search Service | YMC_HR_POLICY_SEARCH | Employee handbooks |
| Search Service | YMC_IT_KB_SEARCH | IT guides (Salesforce, M365, Zoho) |
| Search Service | YMC_SOP_SEARCH | Safety & program SOPs |
| Procedure | SEND_EMAIL | HTML email via notification integration |

## Source Systems Simulated

| System | Tables | Use Case |
|--------|--------|----------|
| Salesforce | BRANCHES, MEMBERSHIP_TYPES, MEMBERS, LEADS | CRM, membership, pipeline |
| Childcare Programs | CHILDCARE_PROGRAMS, CHILDCARE_ENROLLMENTS | Program management |
| HR/Payroll | DEPARTMENTS, EMPLOYEES, ONBOARDING_TASKS | Workforce, onboarding |
| Zoho Service Desk | IT_TICKETS | IT help desk |

## PDF Documents (Search Services)

| Stage | Documents |
|-------|-----------|
| YMC_HR_DOCS_STAGE | 2025 Employee Handbook, 2024 Employee Handbook, Membership Handbook |
| YMC_IT_DOCS_STAGE | Getting Started with Salesforce, Microsoft 365 Quick Start, Zoho Desk Guide |
| YMC_SOP_DOCS_STAGE | Aquatic Safety Plan, Summer Overnight Camp Packet, Team Events SOP |

## Cleanup

Run `sql/99-teardown.sql` to remove all demo objects.

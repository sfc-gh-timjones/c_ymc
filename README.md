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

## Quick Start (Git Integration + Workspace)

### Step 1: Create Git API Integration & Workspace
1. Create a Git API Integration connected to this repo
2. Create a Workspace from the Git repo URL
3. Open the workspace in Snowsight

### Step 2: Run sql/TEARDOWN_AND_REBUILD.sql
Open `sql/TEARDOWN_AND_REBUILD.sql` in the workspace and execute it. This will:
- Drop existing objects (safe to re-run)
- Create the database, schema, and warehouse
- Build all tables and load synthetic data
- Create analytical views and semantic view
- Upload and parse PDFs into Cortex Search services
- Create the email procedure
- Deploy the agent and register it with Snowflake Intelligence

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

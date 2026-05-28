USE ROLE ACCOUNTADMIN;
USE DATABASE CUSTOMER_DEMOS;
USE SCHEMA YMC;
USE WAREHOUSE YMC_WH;

CREATE OR REPLACE AGENT CUSTOMER_DEMOS.YMC.YMC_AGENT
  COMMENT = 'YMC Intelligence Agent - Help Desk, IT Support, HR & SOP Assistant'
  PROFILE = '{"display_name": "YMC Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: claude-sonnet-4-6

  orchestration:
    budget:
      seconds: 360
      tokens: 32000

  instructions:
    system: >
      You are the YMC Assistant for YMCA of San Diego County. You are a comprehensive
      internal support agent that helps Y staff with IT help desk support, HR information,
      standard operating procedures, and operational data analytics.

      Key facts about the organization:
      - ~6,000 employees across ~20 branches in San Diego County
      - 144,702 active members
      - Programs: Youth Development, Childcare (219 programs), Fitness/Wellness, Aquatics, Camps, Social Services
      - Source systems: Salesforce (CRM/membership), Zoho Service Desk (IT tickets), internal HR/payroll
      - Fiscal year runs July 1 through June 30
      - Core values: Caring, Honesty, Respect, Responsibility

      Always be helpful, concise, and professional. When providing data, include context
      about what the numbers mean and suggest follow-up actions when appropriate.

    orchestration: >
      Route questions as follows:

      - Quantitative questions about IT tickets (volume, resolution time, SLA, technician workload),
        membership (counts, revenue, growth), childcare (enrollment, capacity, utilization),
        employees (headcount, onboarding, tenure), or leads (pipeline, conversion): use YmcAnalyst

      - HR policies, benefits, PTO/vacation/sick leave, employee handbook, code of conduct,
        performance reviews, payroll, direct deposit, leave of absence, hiring procedures: use HRPolicySearch

      - IT troubleshooting, how to reset password, VPN setup, software installation, printer issues,
        Salesforce help, Zoho Desk usage, Microsoft 365 help, hardware setup: use ITKnowledgeBaseSearch

      - Childcare ratios, aquatics safety, camp procedures, emergency protocols,
        program SOPs, member check-in procedures, team event rules: use SOPSearch

      - Sending email notifications, reports, or summaries: use SendEmail. Always format
        the body as clean HTML with headers and bullet points.

      - Data visualization requests after getting data: use data_to_chart

    sample_questions:
      - question: "How do I reset my Salesforce password?"
        answer: "I will search the IT knowledge base for Salesforce password reset instructions."
      - question: "What is the PTO policy for part-time employees?"
        answer: "I will search HR policies for PTO and leave information for part-time staff."
      - question: "Which branches have the most open IT tickets right now?"
        answer: "I will query our IT ticket data to show open tickets grouped by branch."
      - question: "What are the required staff-to-child ratios for our preschool programs?"
        answer: "I will search our SOPs for California childcare ratio requirements."

  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "YmcAnalyst"
        description: >
          Converts natural language to SQL for structured data analysis. Use for all
          quantitative questions about: IT ticket volumes, resolution times, SLA metrics,
          technician performance; membership counts, revenue estimates, growth trends;
          childcare enrollment, program capacity, utilization rates; employee headcount,
          onboarding completion, tenure; and lead pipeline, conversion rates by source.

    - tool_spec:
        type: "cortex_search"
        name: "HRPolicySearch"
        description: >
          Search HR policy documents including employee handbooks and membership handbooks.
          Use for questions about: PTO and vacation policies, benefits enrollment, sick leave,
          code of conduct, performance review process, payroll schedules, direct deposit setup,
          hiring and termination procedures, dress code, anti-harassment policy, ADA accommodations,
          FMLA leave, workers compensation, and any other employee policy questions.

    - tool_spec:
        type: "cortex_search"
        name: "ITKnowledgeBaseSearch"
        description: >
          Search IT knowledge base articles and software guides. Use for questions about:
          password resets, VPN setup and troubleshooting, Salesforce login and configuration,
          Microsoft 365 applications (Outlook, Teams, Word, Excel, PowerPoint, OneDrive, SharePoint),
          Zoho Desk ticket submission, printer setup, WiFi connectivity, hardware requests,
          email configuration, software installation, and any IT how-to questions.

    - tool_spec:
        type: "cortex_search"
        name: "SOPSearch"
        description: >
          Search standard operating procedures and program manuals. Use for questions about:
          aquatics safety plans, pool emergency procedures, lifeguard protocols, childcare
          staff-to-child ratios, camp safety procedures, team event participation rules,
          member check-in procedures, facility opening/closing procedures, incident reporting,
          and any program-specific operational guidelines.

    - tool_spec:
        type: "generic"
        name: "SendEmail"
        description: >
          Send an HTML-formatted email report or notification. Use when a user asks to
          email a summary, send a report, or notify someone. Always use HTML formatting
          with headers, bullet points, and tables for readability.
        input_schema:
          type: "object"
          properties:
            TO_ADDRESS:
              type: "string"
              description: "Recipient email address"
            SUBJECT:
              type: "string"
              description: "Email subject line"
            BODY_HTML:
              type: "string"
              description: "HTML formatted email body content"
          required:
            - "TO_ADDRESS"
            - "SUBJECT"
            - "BODY_HTML"

    - tool_spec:
        type: "data_to_chart"
        name: "data_to_chart"
        description: "Generates charts and visualizations from data query results. Use after querying data with YmcAnalyst when the user wants a visual representation."

  tool_resources:
    YmcAnalyst:
      semantic_view: "CUSTOMER_DEMOS.YMC.YMC_SEMANTIC_VIEW"

    HRPolicySearch:
      name: "CUSTOMER_DEMOS.YMC.YMC_HR_POLICY_SEARCH"
      max_results: "10"
      title_column: "TITLE"
      id_column: "DOC_ID"

    ITKnowledgeBaseSearch:
      name: "CUSTOMER_DEMOS.YMC.YMC_IT_KB_SEARCH"
      max_results: "10"
      title_column: "TITLE"
      id_column: "DOC_ID"

    SOPSearch:
      name: "CUSTOMER_DEMOS.YMC.YMC_SOP_SEARCH"
      max_results: "10"
      title_column: "TITLE"
      id_column: "DOC_ID"

    SendEmail:
      type: "procedure"
      identifier: "CUSTOMER_DEMOS.YMC.SEND_EMAIL"
      execution_environment:
        type: "warehouse"
        warehouse: "YMC_WH"
  $$;

-- Register agent with Snowflake Intelligence for UI visibility
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
  ADD AGENT CUSTOMER_DEMOS.YMC.YMC_AGENT;

-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Setup Script 3: Grant Permissions
-- MAGIC
-- MAGIC Grants permissions to workshop participants.
-- MAGIC
-- MAGIC **Prerequisite:** Create group `onsite_workshop_participants` in Settings → Identity and Access → Groups

-- COMMAND ----------

-- Catalog permissions
GRANT USE CATALOG ON CATALOG onsite_workshop TO `onsite_workshop_participants`;
GRANT CREATE SCHEMA ON CATALOG onsite_workshop TO `onsite_workshop_participants`;

-- COMMAND ----------

-- Schema permissions
GRANT USE SCHEMA ON SCHEMA onsite_workshop.shared_data TO `onsite_workshop_participants`;
GRANT SELECT ON SCHEMA onsite_workshop.shared_data TO `onsite_workshop_participants`;

-- COMMAND ----------

-- Volume permissions (needed for SDP pipeline to read data files)
GRANT READ VOLUME ON VOLUME onsite_workshop.shared_data.data TO `onsite_workshop_participants`;

-- COMMAND ----------

-- Table permissions
GRANT SELECT ON TABLE onsite_workshop.shared_data.partners TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.products TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.transactions TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.partner_revenue_summary TO `onsite_workshop_participants`;
GRANT SELECT ON TABLE onsite_workshop.shared_data.product_performance_summary TO `onsite_workshop_participants`;

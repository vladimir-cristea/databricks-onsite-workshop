-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Setup Script 1: Create Catalog and Schema
-- MAGIC
-- MAGIC Creates the workshop catalog, schema, and volume for data files.

-- COMMAND ----------

-- Create catalog
CREATE CATALOG IF NOT EXISTS onsite_workshop;
USE CATALOG onsite_workshop;

-- COMMAND ----------

-- Create shared schema
CREATE SCHEMA IF NOT EXISTS shared_data
COMMENT 'Shared data for morning session';

-- COMMAND ----------

-- Create volume for data files
CREATE VOLUME IF NOT EXISTS shared_data.data
COMMENT 'Volume for workshop data files';

-- COMMAND ----------

-- Verify creation
SHOW SCHEMAS IN onsite_workshop;

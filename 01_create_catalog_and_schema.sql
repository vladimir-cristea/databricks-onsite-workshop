-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Setup Script 1: Create Catalog and Schema
-- MAGIC
-- MAGIC Creates the workshop catalog, schema, and volume for data files.

-- COMMAND ----------

-- Create catalog
CREATE CATALOG IF NOT EXISTS onsite_workshop
MANAGED LOCATION '<S3_BUCKET>'  -- Optional: specify your S3 bucket location
COMMENT 'Workshop catalog for onsite training';
USE CATALOG onsite_workshop;

-- COMMAND ----------

-- Create shared schema
CREATE SCHEMA IF NOT EXISTS shared_data
COMMENT 'Shared data for morning session';

-- COMMAND ----------

-- Create volume for data files
CREATE VOLUME IF NOT EXISTS shared_data.data
COMMENT 'Volume for workshop data files';

-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Setup Script 4: Share Pipeline with Participants
-- MAGIC
-- MAGIC Copies the pipeline file to Shared workspace so participants can access it.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Copy Pipeline to Shared Workspace
-- MAGIC
-- MAGIC This will make the pipeline accessible to all participants without giving them access to your setup notebooks.

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Get the current user's email/username
-- MAGIC username = spark.sql("SELECT current_user() as user").collect()[0]['user']
-- MAGIC 
-- MAGIC # Source: Your private Repos location
-- MAGIC source_path = f"/Workspace/Repos/{username}/databricks-onsite-workshop/sales_analytics_pipeline.sql"
-- MAGIC 
-- MAGIC # Destination: Shared workspace
-- MAGIC dest_path = "/Workspace/Shared/workshop/sales_analytics_pipeline.sql"
-- MAGIC 
-- MAGIC # Create the directory if it doesn't exist
-- MAGIC dbutils.fs.mkdirs("file:/Workspace/Shared/workshop/")
-- MAGIC 
-- MAGIC # Copy the file
-- MAGIC dbutils.fs.cp(f"file:{source_path}", f"file:{dest_path}")
-- MAGIC 
-- MAGIC print(f"✅ Pipeline copied to: {dest_path}")
-- MAGIC print(f"Participants can now access it from /Workspace/Shared/workshop/")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Verify
-- MAGIC
-- MAGIC Check that the file exists in Shared workspace:

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # List files in Shared/workshop
-- MAGIC display(dbutils.fs.ls("file:/Workspace/Shared/workshop/"))

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Next Steps
-- MAGIC
-- MAGIC Participants should:
-- MAGIC 1. Navigate to `/Workspace/Shared/workshop/sales_analytics_pipeline.sql`
-- MAGIC 2. Copy it to their own workspace
-- MAGIC 3. Create a DLT pipeline pointing to their copy
-- MAGIC 4. Set target schema to `onsite_workshop.{their_username}`


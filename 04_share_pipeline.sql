-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Setup Script 4: Share Pipeline with Participants
-- MAGIC
-- MAGIC Copies the pipeline file to Shared workspace so participants can access it.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Copy Pipeline to Shared Workspace

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Get the current user's email/username
-- MAGIC username = spark.sql("SELECT current_user() as user").collect()[0]['user']
-- MAGIC 
-- MAGIC # Source: Your private Repos location
-- MAGIC source = f"file:/Workspace/Repos/{username}/databricks-onsite-workshop/sales_analytics_pipeline.sql"
-- MAGIC 
-- MAGIC # Destination: Shared workspace
-- MAGIC dest = "file:/Workspace/Shared/workshop/sales_analytics_pipeline.sql"
-- MAGIC 
-- MAGIC # Create destination directory if it doesn't exist
-- MAGIC try:
-- MAGIC     dbutils.fs.mkdirs("file:/Workspace/Shared/workshop/")
-- MAGIC except:
-- MAGIC     pass  # Directory might already exist
-- MAGIC 
-- MAGIC # Copy the file
-- MAGIC result = dbutils.fs.cp(source, dest, recurse=False)
-- MAGIC 
-- MAGIC if result:
-- MAGIC     print(f"✅ Pipeline copied successfully!")
-- MAGIC     print(f"Source: {source}")
-- MAGIC     print(f"Destination: {dest}")
-- MAGIC     print(f"\nParticipants can access it at: /Workspace/Shared/workshop/sales_analytics_pipeline.sql")
-- MAGIC else:
-- MAGIC     print("❌ Copy failed")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Verify Copy

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # List files in Shared/workshop to verify
-- MAGIC files = dbutils.fs.ls("file:/Workspace/Shared/workshop/")
-- MAGIC display(files)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Set Permissions
-- MAGIC
-- MAGIC After copying, set permissions on the folder:
-- MAGIC 1. Navigate to `/Workspace/Shared/workshop/` in the UI
-- MAGIC 2. Right-click → **Permissions**
-- MAGIC 3. Add `onsite_workshop_participants` group with **CAN READ** access

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Next Steps for Participants
-- MAGIC
-- MAGIC Participants should:
-- MAGIC 1. Navigate to `/Workspace/Shared/workshop/sales_analytics_pipeline.sql`
-- MAGIC 2. Copy it to their own workspace
-- MAGIC 3. Edit to complete TODO sections
-- MAGIC 4. Create DLT pipeline pointing to their copy
-- MAGIC 5. Set target: `onsite_workshop.{their_username}`

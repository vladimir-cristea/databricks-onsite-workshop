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
-- MAGIC import shutil
-- MAGIC import os
-- MAGIC 
-- MAGIC # Get the current user's email/username
-- MAGIC username = spark.sql("SELECT current_user() as user").collect()[0]['user']
-- MAGIC 
-- MAGIC # Source: Your private Repos location
-- MAGIC source = f"/Workspace/Repos/{username}/databricks-onsite-workshop/sales_analytics_pipeline.sql"
-- MAGIC 
-- MAGIC # Destination: Shared workspace
-- MAGIC dest = "/Workspace/Shared/workshop/sales_analytics_pipeline.sql"
-- MAGIC dest_dir = "/Workspace/Shared/workshop/"
-- MAGIC 
-- MAGIC # Create destination directory if it doesn't exist
-- MAGIC os.makedirs(dest_dir, exist_ok=True)
-- MAGIC 
-- MAGIC # Copy the file
-- MAGIC shutil.copy(source, dest)
-- MAGIC 
-- MAGIC print(f"✅ Pipeline copied successfully!")
-- MAGIC print(f"Source: {source}")
-- MAGIC print(f"Destination: {dest}")
-- MAGIC print(f"\nParticipants can access it at: /Workspace/Shared/workshop/sales_analytics_pipeline.sql")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Verify Copy

-- COMMAND ----------

-- MAGIC %python
-- MAGIC import os
-- MAGIC 
-- MAGIC # List files in Shared/workshop to verify
-- MAGIC files = os.listdir("/Workspace/Shared/workshop/")
-- MAGIC print("Files in /Workspace/Shared/workshop/:")
-- MAGIC for f in files:
-- MAGIC     print(f"  - {f}")

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

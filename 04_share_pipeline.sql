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
-- MAGIC # Source: Your private Users location
-- MAGIC source_dir = f"/Workspace/Users/{username}/databricks-onsite-workshop/sdp_pipeline"
-- MAGIC 
-- MAGIC # Check if source directory exists
-- MAGIC if not os.path.exists(source_dir):
-- MAGIC     print(f"❌ Could not find sdp_pipeline directory at: {source_dir}")
-- MAGIC     print(f"\nPlease ensure you've imported the repo to /Workspace/Users/{username}/")
-- MAGIC     dbutils.notebook.exit("Source directory not found")
-- MAGIC 
-- MAGIC # Destination: Shared workspace
-- MAGIC dest_dir = "/Workspace/Shared/workshop/sdp_pipeline"
-- MAGIC 
-- MAGIC # Remove existing destination if it exists, then copy
-- MAGIC if os.path.exists(dest_dir):
-- MAGIC     shutil.rmtree(dest_dir)
-- MAGIC 
-- MAGIC # Copy the entire directory
-- MAGIC shutil.copytree(source_dir, dest_dir)
-- MAGIC 
-- MAGIC print(f"✅ Pipeline directory copied successfully!")
-- MAGIC print(f"Source: {source_dir}")
-- MAGIC print(f"Destination: {dest_dir}")
-- MAGIC print(f"\nParticipants can access it at: /Workspace/Shared/workshop/sdp_pipeline/")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Verify Copy

-- COMMAND ----------

-- MAGIC %python
-- MAGIC import os
-- MAGIC 
-- MAGIC # List files in Shared/workshop/sdp_pipeline to verify
-- MAGIC files = os.listdir("/Workspace/Shared/workshop/sdp_pipeline/")
-- MAGIC print("Files in /Workspace/Shared/workshop/sdp_pipeline/:")
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
-- MAGIC 1. Navigate to `/Workspace/Shared/workshop/sdp_pipeline/`
-- MAGIC 2. Copy the folder to their own workspace
-- MAGIC 3. Edit `sales_analytics_pipeline.sql` to complete TODO sections
-- MAGIC 4. Create Spark Declarative Pipeline pointing to their copy
-- MAGIC 5. Set target: `onsite_workshop.{their_username}`

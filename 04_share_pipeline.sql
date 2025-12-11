-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Setup Script 4: Share Pipeline with Participants

-- COMMAND ----------

-- MAGIC %python
-- MAGIC import shutil
-- MAGIC import os
-- MAGIC 
-- MAGIC username = spark.sql("SELECT current_user() as user").collect()[0]['user']
-- MAGIC source_dir = f"/Workspace/Users/{username}/databricks-onsite-workshop/sdp_pipeline"
-- MAGIC dest_dir = "/Workspace/Shared/workshop/sdp_pipeline"
-- MAGIC 
-- MAGIC if not os.path.exists(source_dir):
-- MAGIC     print(f"❌ Source not found: {source_dir}")
-- MAGIC     dbutils.notebook.exit("Source directory not found")
-- MAGIC 
-- MAGIC if os.path.exists(dest_dir):
-- MAGIC     shutil.rmtree(dest_dir)
-- MAGIC 
-- MAGIC shutil.copytree(source_dir, dest_dir)
-- MAGIC 
-- MAGIC print(f"✅ Pipeline copied to /Workspace/Shared/workshop/sdp_pipeline/")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC import os
-- MAGIC 
-- MAGIC files = os.listdir("/Workspace/Shared/workshop/sdp_pipeline/")
-- MAGIC print("✅ Files copied:")
-- MAGIC for f in files:
-- MAGIC     print(f"  - {f}")

# Databricks Onsite Workshop

Workshop setup for SQL analytics and Spark Declarative Pipelines (SDP) exercises using partner/transaction data.

## Contents

**Admin Setup (Private):**
- `01_create_catalog_and_schema.sql` - Creates catalog and schema
- `02_load_data.sql` - Loads sample data (51 partners, 201 transactions, 6 products)
- `03_grant_permissions.sql` - Grants participant access
- `04_share_pipeline.sql` - Copies sdp_pipeline folder to shared workspace
- `data/` - JSON source files

**Participant Materials (Shared):**
- `sdp_pipeline/sales_analytics_pipeline.sql` - Afternoon hands-on exercise (8-node medallion pipeline)

## Setup

### 1. Create User Group
Go to **Settings → Identity and Access → Groups**, create group `onsite_workshop_participants`, add all participant emails.

### 2. Create Workspace
Create a new Databricks workspace if needed.

### 3. Configure SQL Warehouse
1. Edit the default **Serverless Starter Warehouse**:
   - Size: **Small**
   - Auto stop: **60 minutes** of inactivity
   - Scaling: Min **1**, Max **4** clusters
   - Type: **Serverless** (if available), otherwise **Pro**
2. Grant **Can use** permission to `onsite_workshop_participants` group

### 4. Import Repository
1. Navigate to `/Workspace/Users/{your_email}/`
2. Click **Create** → **Git Folder**
3. Paste URL: `https://github.com/vladimir-cristea/databricks-onsite-workshop`
4. Name: `databricks-onsite-workshop`

### 5. Run Setup Script 01
Open and run `01_create_catalog_and_schema.sql` - creates catalog, schema, and volume.

### 6. Upload Data to Volume
1. Navigate to **Catalog** → `onsite_workshop` → `shared_data` → `data` volume
2. Upload the entire `data/` folder from your imported repo
3. Verify structure: `/Volumes/onsite_workshop/shared_data/data/data/{partners|transactions|products}/`

### 7. Run Setup Script 02
Open and run `02_load_data.sql` - loads data from volume into tables.

### 8. Run Setup Script 03
Open and run `03_grant_permissions.sql` - grants access to participants.

### 9. Run Setup Script 04
Open and run `04_share_pipeline.sql` - copies `sdp_pipeline/` folder to `/Workspace/Shared/workshop/`.

### 10. Verify

```sql
USE CATALOG onsite_workshop;
USE SCHEMA shared_data;

SELECT 'partners' as table_name, COUNT(*) as row_count FROM partners
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL SELECT 'partner_revenue_summary', COUNT(*) FROM partner_revenue_summary
UNION ALL SELECT 'product_performance_summary', COUNT(*) FROM product_performance_summary;
```

Expected: partners (51), products (6), transactions (201), summaries (~48-50 rows)

## Workshop Day

**Morning**: Participants query the shared tables in `onsite_workshop.shared_data`

**Afternoon**: Participants work with the pipeline:
1. Navigate to `/Workspace/Shared/workshop/sdp_pipeline/` 
2. Copy the folder to their own workspace for editing
3. Edit `sales_analytics_pipeline.sql` to complete TODO sections in Gold layer
4. Create SDP pipeline:
   - Go to **Workflows** → **Delta Live Tables** → **Create Pipeline**
   - Add their `sales_analytics_pipeline.sql` file as source
   - Set target: `onsite_workshop.{their_username}`
5. Run pipeline

Pipeline creates 8 nodes: 3 Bronze streaming tables, 3 Silver streaming tables, 2 Gold materialized views

## Troubleshooting

**"Permission denied"**: Verify group name is exactly `onsite_workshop_participants` and participants are members

**"Path not found"**: Verify data folder is copied to volume with structure `/Volumes/onsite_workshop/shared_data/data/data/{partners|transactions|products}/`

## Cleanup

```sql
DROP CATALOG IF EXISTS onsite_workshop CASCADE;
```

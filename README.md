# Databricks Onsite Workshop

Workshop setup for SQL analytics and Delta Live Tables pipeline exercises using partner/transaction data.

## Contents

**Admin Setup (Private):**
- `01_create_catalog_and_schema.sql` - Creates catalog and schema
- `02_load_data.sql` - Loads sample data (51 partners, 201 transactions, 6 products)
- `03_grant_permissions.sql` - Grants participant access
- `04_share_pipeline.sql` - Copies pipeline to shared workspace
- `data/` - JSON source files

**Participant Materials (Shared):**
- `sales_analytics_pipeline.sql` - Afternoon hands-on exercise (8-node medallion pipeline)

## Prerequisites

- Databricks workspace with Serverless SQL and Serverless Pipelines enabled
- Admin access to create catalogs and grant permissions

## Setup (10 minutes)

### 1. Create User Group
Go to **Settings → Identity and Access → Groups**, create group `onsite_workshop_participants`, add all participant emails.

### 2. Clone Repository
Go to **Repos** → **Add Repo** → Enter URL: `https://github.com/vladimir-cristea/databricks-onsite-workshop` → **Create Repo**

### 3. Upload Data to Volume
After creating the volume:
1. Navigate to **Catalog** → `onsite_workshop` → `shared_data` → `data` volume
2. Upload the entire `data/` folder from your cloned repo (partners/, transactions/, products/ folders)
3. Verify the structure is: `/Volumes/onsite_workshop/shared_data/data/data/{partners|transactions|products}/`

### 4. Run Admin Setup Scripts
Clone repo to YOUR private Repos space, then run in order:
1. `01_create_catalog_and_schema.sql`
2. `02_load_data.sql`
3. `03_grant_permissions.sql`
4. `04_share_pipeline.sql` - Copies pipeline to `/Workspace/Shared/workshop/`

### 5. Verify

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
1. Navigate to `/Workspace/Shared/workshop/sales_analytics_pipeline.sql` 
2. Copy it to their own workspace for editing
3. Complete TODO sections in Gold layer
4. Create DLT pipeline:
   - Go to **Workflows** → **Delta Live Tables** → **Create Pipeline**
   - Add their copy of the SQL file as source
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

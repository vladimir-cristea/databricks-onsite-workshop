# Databricks Onsite Workshop

Workshop setup for SQL analytics and Delta Live Tables pipeline exercises using partner/transaction data.

## Contents

- `01_create_catalog_and_schema.sql` - Creates catalog and schema
- `02_load_data.sql` - Loads sample data (21 partners, 50 transactions, 6 products)
- `03_grant_permissions.sql` - Grants participant access
- `sales_analytics_pipeline.sql` - Afternoon hands-on exercise (8-node medallion pipeline)
- `data/` - JSON source files

## Prerequisites

- Databricks workspace with Serverless SQL and Serverless Pipelines enabled
- Admin access to create catalogs and grant permissions

## Setup (10 minutes)

### 1. Create User Group
Go to **Settings → Identity and Access → Groups**, create group `onsite_workshop_participants`, add all participant emails.

### 2. Clone Repository
Go to **Repos** → **Add Repo** → Enter URL: `https://github.com/vladimir-cristea/databricks-onsite-workshop` → **Create Repo**

### 3. Copy Data Files to Volume
After creating the volume, copy data folders from your cloned repo to the volume:

```sql
COPY FILES 'file:/Workspace/Repos/{your_username}/databricks-onsite-workshop/data/partners/' 
TO '/Volumes/onsite_workshop/shared_data/data/partners/';

COPY FILES 'file:/Workspace/Repos/{your_username}/databricks-onsite-workshop/data/transactions/' 
TO '/Volumes/onsite_workshop/shared_data/data/transactions/';

COPY FILES 'file:/Workspace/Repos/{your_username}/databricks-onsite-workshop/data/products/' 
TO '/Volumes/onsite_workshop/shared_data/data/products/';
```

Replace `{your_username}` with your actual username.

### 4. Run Setup Scripts
Open SQL Editor and run in order:
1. `01_create_catalog_and_schema.sql`
2. Copy files command above
3. `02_load_data.sql`
4. `03_grant_permissions.sql`

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

**Afternoon**: Participants create DLT pipeline from `sales_analytics_pipeline.sql`:
1. Go to **Workflows** → **Delta Live Tables** → **Create Pipeline**
2. Add `sales_analytics_pipeline.sql` as file source
3. Set target catalog: `onsite_workshop`, schema: `{your_username}`
4. Complete TODO sections in Gold layer (edit the SQL file)
5. Run pipeline

Pipeline creates 8 nodes: 3 Bronze streaming tables, 3 Silver streaming tables, 2 Gold materialized views

## Troubleshooting

**"Permission denied"**: Verify group name is exactly `onsite_workshop_participants` and participants are members

**"Path not found"**: Verify data folders are copied to volume with structure `/Volumes/onsite_workshop/shared_data/data/{partners|transactions|products}/`

## Cleanup

```sql
DROP CATALOG IF EXISTS onsite_workshop CASCADE;
```

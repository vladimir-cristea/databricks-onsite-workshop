-- Sales Analytics Pipeline - 8-Node Medallion Architecture
-- Setup: Configure pipeline target as 'onsite_workshop.{username}' in SDP UI

-- Bronze Layer: Raw Ingestion

CREATE OR REFRESH STREAMING TABLE bronze_partners
COMMENT "Raw partner master data"
AS SELECT 
  partner_id,
  partner_name,
  region,
  tier,
  join_date,
  account_manager,
  current_timestamp() as ingestion_timestamp
FROM STREAM read_files(
  '/Volumes/onsite_workshop/shared_data/data/data/partners/',
  format => 'json',
  schemaHints => 'partner_id INT, join_date DATE'
);

CREATE OR REFRESH STREAMING TABLE bronze_transactions
COMMENT "Raw transaction data"
AS SELECT 
  transaction_id,
  partner_id,
  product_id,
  transaction_date,
  quantity,
  unit_price,
  discount_pct,
  currency,
  current_timestamp() as ingestion_timestamp
FROM STREAM read_files(
  '/Volumes/onsite_workshop/shared_data/data/data/transactions/',
  format => 'json',
  schemaHints => 'transaction_id INT, partner_id INT, quantity INT, transaction_date DATE, unit_price DECIMAL(10,2), discount_pct DECIMAL(5,2)'
);

CREATE OR REFRESH STREAMING TABLE bronze_products
COMMENT "Raw product catalog"
AS SELECT 
  product_id,
  product_name,
  category,
  list_price,
  cost,
  launch_date,
  current_timestamp() as ingestion_timestamp
FROM STREAM read_files(
  '/Volumes/onsite_workshop/shared_data/data/data/products/',
  format => 'json',
  schemaHints => 'list_price DECIMAL(10,2), cost DECIMAL(10,2), launch_date DATE'
);

-- Silver Layer: Cleaned & Validated

CREATE OR REFRESH STREAMING TABLE silver_partners (
  CONSTRAINT valid_partner_id EXPECT (partner_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_region EXPECT (region IN ('EMEA', 'AMER', 'APAC')) ON VIOLATION DROP ROW,
  CONSTRAINT valid_tier EXPECT (tier IN ('Premium', 'Standard', 'Basic', 'TEST'))
)
COMMENT "Validated partners - TEST partners filtered"
AS SELECT 
  partner_id,
  partner_name,
  region,
  tier,
  join_date,
  account_manager,
  DATEDIFF(CURRENT_DATE(), join_date) as days_since_joining,
  CASE 
    WHEN tier = 'Premium' THEN 1
    WHEN tier = 'Standard' THEN 2
    WHEN tier = 'Basic' THEN 3
    ELSE 99
  END as tier_rank,
  ingestion_timestamp
FROM STREAM(bronze_partners)
WHERE tier != 'TEST';

CREATE OR REFRESH STREAMING TABLE silver_products (
  CONSTRAINT valid_product_id EXPECT (product_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_list_price EXPECT (list_price > 0) ON VIOLATION DROP ROW
)
COMMENT "Validated products with margins"
AS SELECT 
  product_id,
  product_name,
  category,
  list_price,
  cost,
  launch_date,
  ROUND((list_price - cost) / list_price * 100, 2) as margin_pct,
  DATEDIFF(CURRENT_DATE(), launch_date) as days_since_launch,
  ingestion_timestamp
FROM STREAM(bronze_products);

CREATE OR REFRESH STREAMING TABLE silver_transactions (
  CONSTRAINT valid_quantity EXPECT (quantity > 0) ON VIOLATION DROP ROW,
  CONSTRAINT valid_partner_ref EXPECT (partner_id IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_product_ref EXPECT (product_id IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT "Validated enriched transactions with revenue and profit"
AS SELECT 
  t.transaction_id,
  t.partner_id,
  p.partner_name,
  p.region,
  p.tier,
  t.product_id,
  prod.product_name,
  prod.category,
  t.transaction_date,
  t.quantity,
  t.unit_price,
  t.discount_pct,
  t.currency,
  ROUND(t.quantity * t.unit_price * (1 - t.discount_pct / 100), 2) as revenue,
  ROUND(t.quantity * prod.cost, 2) as total_cost,
  ROUND(t.quantity * t.unit_price * (1 - t.discount_pct / 100) - t.quantity * prod.cost, 2) as profit,
  t.ingestion_timestamp
FROM STREAM(bronze_transactions) t
INNER JOIN silver_partners p ON t.partner_id = p.partner_id
INNER JOIN silver_products prod ON t.product_id = prod.product_id;

-- Gold Layer: Business Metrics (TODO sections for participants)

CREATE OR REFRESH MATERIALIZED VIEW gold_partner_revenue_summary
COMMENT "Monthly partner revenue and profit"
AS SELECT 
  DATE_TRUNC('MONTH', transaction_date) as month,
  DATE_FORMAT(transaction_date, 'MMMM') as month_name,
  partner_id,
  partner_name,
  region,
  tier,
  0 as total_revenue,  -- TODO: Calculate total revenue for the partner-month
  0 as total_profit,   -- TODO: Calculate total profit for the partner-month
  COUNT(transaction_id) as num_transactions,
  SUM(quantity) as total_units_sold,
  AVG(revenue) as avg_transaction_value,
  MAX(revenue) as largest_deal,
  0.0 as profit_margin_pct  -- TODO: Calculate profit as percentage of revenue (handle division by zero)
FROM silver_transactions
GROUP BY 
  DATE_TRUNC('MONTH', transaction_date),
  DATE_FORMAT(transaction_date, 'MMMM'),
  partner_id,
  partner_name,
  region,
  tier;

CREATE OR REFRESH MATERIALIZED VIEW gold_product_performance
COMMENT "Monthly product performance metrics"
AS SELECT 
  DATE_TRUNC('MONTH', transaction_date) as month,
  DATE_FORMAT(transaction_date, 'MMMM') as month_name,
  category,
  product_id,
  product_name,
  0 as total_revenue,      -- TODO: Calculate total revenue for this product-month
  0 as total_profit,       -- TODO: Calculate total profit for this product-month
  0 as unique_customers,   -- TODO: Count how many different partners bought this product
  SUM(quantity) as total_units_sold,
  COUNT(transaction_id) as num_transactions,
  AVG(discount_pct) as avg_discount_pct,
  0.0 as profit_margin_pct  -- TODO: Calculate profit margin percentage (watch for zero revenue)
FROM silver_transactions
GROUP BY 
  DATE_TRUNC('MONTH', transaction_date),
  DATE_FORMAT(transaction_date, 'MMMM'),
  category,
  product_id,
  product_name;

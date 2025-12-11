USE CATALOG onsite_workshop;
USE SCHEMA shared_data;

-- Partners table
DROP TABLE IF EXISTS partners;
CREATE TABLE partners (
  partner_id INT,
  partner_name STRING,
  region STRING,
  tier STRING,
  join_date DATE,
  account_manager STRING
);

COPY INTO partners
FROM '/Workspace/Shared/databricks_onsite_workshop/data/partners.json'
FILEFORMAT = JSON
COPY_OPTIONS ('mergeSchema' = 'true');

SELECT COUNT(*) as partner_count FROM partners;  -- Expected: 21

-- Products table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_id STRING,
  product_name STRING,
  category STRING,
  list_price DECIMAL(10,2),
  cost DECIMAL(10,2),
  launch_date DATE
);

COPY INTO products
FROM '/Workspace/Shared/databricks_onsite_workshop/data/products.json'
FILEFORMAT = JSON
COPY_OPTIONS ('mergeSchema' = 'true');

SELECT COUNT(*) as product_count FROM products;  -- Expected: 6

-- Transactions table
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
  transaction_id INT,
  partner_id INT,
  product_id STRING,
  transaction_date DATE,
  quantity INT,
  unit_price DECIMAL(10,2),
  discount_pct DECIMAL(5,2),
  currency STRING
);

COPY INTO transactions
FROM '/Workspace/Shared/databricks_onsite_workshop/data/transactions.json'
FILEFORMAT = JSON
COPY_OPTIONS ('mergeSchema' = 'true');

SELECT COUNT(*) as transaction_count FROM transactions;  -- Expected: 50

-- Partner revenue summary (pre-aggregated)
DROP TABLE IF EXISTS partner_revenue_summary;
CREATE TABLE partner_revenue_summary (
  partner_id INT,
  partner_name STRING,
  region STRING,
  tier STRING,
  total_revenue DECIMAL(12,2),
  total_profit DECIMAL(12,2),
  num_deals INT,
  total_units INT,
  avg_deal_size DECIMAL(10,2),
  first_transaction_date DATE,
  last_transaction_date DATE
);

INSERT INTO partner_revenue_summary
SELECT 
  p.partner_id,
  p.partner_name,
  p.region,
  p.tier,
  SUM(t.quantity * t.unit_price * (1 - t.discount_pct / 100)) as total_revenue,
  SUM(t.quantity * t.unit_price * (1 - t.discount_pct / 100) - t.quantity * prod.cost) as total_profit,
  COUNT(t.transaction_id) as num_deals,
  SUM(t.quantity) as total_units,
  AVG(t.quantity * t.unit_price * (1 - t.discount_pct / 100)) as avg_deal_size,
  MIN(t.transaction_date) as first_transaction_date,
  MAX(t.transaction_date) as last_transaction_date
FROM partners p
LEFT JOIN transactions t ON p.partner_id = t.partner_id
LEFT JOIN products prod ON t.product_id = prod.product_id
WHERE t.quantity > 0
  AND t.partner_id IS NOT NULL
  AND t.product_id IS NOT NULL
GROUP BY p.partner_id, p.partner_name, p.region, p.tier;

SELECT COUNT(*) as summary_count FROM partner_revenue_summary;  -- Expected: ~20

-- Product performance summary (pre-aggregated)
DROP TABLE IF EXISTS product_performance_summary;
CREATE TABLE product_performance_summary (
  product_id STRING,
  product_name STRING,
  category STRING,
  total_revenue DECIMAL(12,2),
  total_units_sold INT,
  num_transactions INT,
  unique_partners INT,
  avg_discount_pct DECIMAL(5,2),
  total_profit DECIMAL(12,2),
  profit_margin_pct DECIMAL(5,2)
);

INSERT INTO product_performance_summary
SELECT 
  prod.product_id,
  prod.product_name,
  prod.category,
  SUM(t.quantity * t.unit_price * (1 - t.discount_pct / 100)) as total_revenue,
  SUM(t.quantity) as total_units_sold,
  COUNT(t.transaction_id) as num_transactions,
  COUNT(DISTINCT t.partner_id) as unique_partners,
  AVG(t.discount_pct) as avg_discount_pct,
  SUM(t.quantity * t.unit_price * (1 - t.discount_pct / 100) - t.quantity * prod.cost) as total_profit,
  ROUND(AVG((t.quantity * t.unit_price * (1 - t.discount_pct / 100) - t.quantity * prod.cost) / 
            (t.quantity * t.unit_price * (1 - t.discount_pct / 100)) * 100), 2) as profit_margin_pct
FROM products prod
LEFT JOIN transactions t ON prod.product_id = t.product_id
WHERE t.quantity > 0
  AND t.partner_id IS NOT NULL
GROUP BY prod.product_id, prod.product_name, prod.category;

SELECT COUNT(*) as product_summary_count FROM product_performance_summary;  -- Expected: ~5

-- Verify all tables loaded
SHOW TABLES IN onsite_workshop.shared_data;

SELECT 
  (SELECT COUNT(*) FROM partners) as partners,
  (SELECT COUNT(*) FROM products) as products,
  (SELECT COUNT(*) FROM transactions) as transactions,
  (SELECT COUNT(*) FROM partner_revenue_summary) as partner_summary,
  (SELECT COUNT(*) FROM product_performance_summary) as product_summary;

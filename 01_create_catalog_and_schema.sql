-- Create catalog and schema for workshop
CREATE CATALOG IF NOT EXISTS onsite_workshop;
USE CATALOG onsite_workshop;

CREATE SCHEMA IF NOT EXISTS shared_data
COMMENT 'Shared data for morning session';

SHOW SCHEMAS IN onsite_workshop;

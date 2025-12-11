-- Create catalog and schema for workshop
CREATE CATALOG IF NOT EXISTS onsite_workshop;
USE CATALOG onsite_workshop;

CREATE SCHEMA IF NOT EXISTS shared_data
COMMENT 'Shared data for morning session';

-- Create volume for data files
CREATE VOLUME IF NOT EXISTS shared_data.data
COMMENT 'Volume for workshop data files';

SHOW SCHEMAS IN onsite_workshop;

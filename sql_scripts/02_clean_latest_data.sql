-- 02_clean_latest_data.sql
-- Cleans and standardizes the latest daily mandi prices table.

CREATE OR REPLACE TABLE `latest_data_cleaned` AS
SELECT
    -- Standardize column names
    state,
    district,
    market,
    LOWER(commodity) AS commodity, -- Standardize to lowercase
    variety,
    grade,
    Arrival_Date AS price_date, -- The column is already a DATE type
    SAFE_CAST(`Min_x0020_Price` AS FLOAT64) AS min_price, -- Corrected column name and used SAFE_CAST
    SAFE_CAST(`Max_x0020_Price` AS FLOAT64) AS max_price, -- Corrected column name and used SAFE_CAST
    SAFE_CAST(`Modal_x0020_Price` AS FLOAT64) AS modal_price -- Corrected column name and used SAFE_CAST
FROM
    `bcb-blr-abu.agri_dataset.agri_latest_data`;

-- Best Practice: Handle Parsing Errors
-- Check for values that failed to cast.
-- SELECT * FROM `bcb-blr-abu.agri_dataset.agri_latest_data`
-- WHERE `Min_x0020_Price` IS NOT NULL AND SAFE_CAST(`Min_x0020_Price` AS FLOAT64) IS NULL;

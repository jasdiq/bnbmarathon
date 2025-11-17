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
    -- Parse the date, assuming 'DD/MM/YYYY' format. Adjust if needed.
    PARSE_DATE('%d/%m/%Y', arrival_date) AS price_date,
    CAST(mix_price AS FLOAT64) AS min_price, -- Assuming mix_price is min_price
    CAST(max_price AS FLOAT64) AS max_price,
    CAST(modalprice AS FLOAT64) AS modal_price
FROM
    `latest_data`;

-- Best Practice: Handle Parsing Errors
-- Check for dates that failed to parse.
-- SELECT arrival_date FROM `latest_data`
-- WHERE PARSE_DATE('%d/%m/%Y', arrival_date) IS NULL;

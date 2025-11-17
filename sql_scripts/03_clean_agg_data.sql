-- 03_clean_agg_data.sql
-- Cleans and standardizes the aggregated price data table.

CREATE OR REPLACE TABLE `agg_data_cleaned` AS
SELECT
    -- Standardize column names
    districtname AS district,
    marketname AS market,
    LOWER(commodity) AS commodity, -- Standardize to lowercase
    variety,
    grade,
    CAST(min AS FLOAT64) AS min_price,
    CAST(max AS FLOAT64) AS max_price,
    CAST(modalprice AS FLOAT64) AS modal_price,
    -- Assuming priceDate is already a DATE. If not, parse it.
    -- For example: PARSE_DATE('%Y-%m-%d', priceDate)
    priceDate AS price_date
FROM
    `agg_data`;

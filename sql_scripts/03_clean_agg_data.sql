-- 03_clean_agg_data.sql
-- Cleans and standardizes the aggregated price data table.

CREATE OR REPLACE TABLE `agg_data_cleaned` AS
SELECT
    -- Standardize column names
    DistrictName AS district,
    MarketName AS market,
    LOWER(commodity) AS commodity, -- Standardize to lowercase
    variety,
    grade,
    SAFE_CAST(MinPriceperquintal AS FLOAT64) AS min_price,
    SAFE_CAST(MaxPricequital AS FLOAT64) AS max_price,
    SAFE_CAST(ModalPricequintal AS FLOAT64) AS modal_price,
    -- PriceDate is a string, so we parse it into a DATE.
    SAFE.PARSE_DATE('%Y-%m-%d', PriceDate) AS price_date
FROM
    `bcb-blr-abu.agri_dataset.agri_data`;

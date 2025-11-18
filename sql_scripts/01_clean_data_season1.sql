-- 01_clean_data_season1.sql
-- Cleans and standardizes the historical farming data table.

CREATE OR REPLACE TABLE `data_season1_cleaned` AS
SELECT
    -- Standardize column names and cast to appropriate data types
    SAFE_CAST(year AS INT64) AS year,
    location,
    SAFE_CAST(area AS FLOAT64) AS area,
    SAFE_CAST(rainfall AS FLOAT64) AS rainfall,
    SAFE_CAST(temperature AS FLOAT64) AS temperature,
    soiltype,
    irrigation,
    SAFE_CAST(yeilds AS FLOAT64) AS yield, -- Corrected column name from 'yield' to 'yeilds'
    SAFE_CAST(humidity AS FLOAT64) AS humidity,
    LOWER(crops) AS commodity, -- Standardize to lowercase
    SAFE_CAST(price AS FLOAT64) AS price,
    season
FROM
    `bcb-blr-abu.agri_dataset.data_season`;

-- Best Practice: Data Quality Check
-- After running this, you should check for NULLs or unexpected values.
-- For example:
-- SELECT * FROM `data_season1_cleaned` WHERE commodity IS NULL;
-- SELECT DISTINCT soiltype FROM `data_season1_cleaned`;

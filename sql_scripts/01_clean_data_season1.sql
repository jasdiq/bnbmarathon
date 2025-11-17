-- 01_clean_data_season1.sql
-- Cleans and standardizes the historical farming data table.

CREATE OR REPLACE TABLE `data_season1_cleaned` AS
SELECT
    -- Standardize column names and cast to appropriate data types
    CAST(year AS INT64) AS year,
    location,
    CAST(area AS FLOAT64) AS area,
    CAST(rainfall AS FLOAT64) AS rainfall,
    CAST(temperature AS FLOAT64) AS temperature,
    soiltype,
    irrigation,
    CAST(yield AS FLOAT64) AS yield,
    CAST(humidity AS FLOAT64) AS humidity,
    LOWER(crops) AS commodity, -- Standardize to lowercase
    CAST(price AS FLOAT64) AS price,
    season
FROM
    `data_season1`;

-- Best Practice: Data Quality Check
-- After running this, you should check for NULLs or unexpected values.
-- For example:
-- SELECT * FROM `data_season1_cleaned` WHERE commodity IS NULL;
-- SELECT DISTINCT soiltype FROM `data_season1_cleaned`;

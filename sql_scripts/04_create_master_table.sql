-- 04_create_master_table.sql
-- Creates a master table for model training by joining the cleaned tables.

CREATE OR REPLACE TABLE `master_table` AS
WITH all_prices AS (
    -- Union the two price tables to get a complete price history
    SELECT district, market, commodity, variety, grade, price_date, min_price, max_price, modal_price FROM `latest_data_cleaned`
    UNION ALL
    SELECT district, market, commodity, variety, grade, price_date, min_price, max_price, modal_price FROM `agg_data_cleaned`
)
SELECT
    p.price_date,
    p.district,
    p.market,
    p.commodity,
    p.variety,
    p.grade,
    p.min_price,
    p.max_price,
    p.modal_price,
    s.area,
    s.rainfall,
    s.temperature,
    s.soiltype,
    s.irrigation,
    s.yield,
    s.humidity,
    s.season
FROM
    all_prices p
LEFT JOIN
    `data_season1_cleaned` s
ON
    TRIM(LOWER(p.district)) = TRIM(LOWER(s.location)) -- Standardize join keys
    AND EXTRACT(YEAR FROM p.price_date) = s.year
    AND p.commodity = s.commodity;

-- Best Practice: Joining Logic
-- The join with `data_season1_cleaned` assumes that the seasonal data (like rainfall, temperature)
-- is constant for a given year, location, and commodity. This is a reasonable simplification.
-- A more complex model could interpolate these values.

-- Best Practice: Handle Missing Values
-- After this join, you will likely have missing values for the seasonal features,
-- especially for recent data if `data_season1` is not up-to-date.
-- You should have a strategy to fill them (e.g., using the average of the last known season).
-- Example check:
-- SELECT * FROM `master_table` WHERE rainfall IS NULL;

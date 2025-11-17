-- 05_feature_engineering.sql
-- Creates features for the time-series model.

CREATE OR REPLACE TABLE `training_data`
PARTITION BY
  price_date_partition -- Partition by month for performance
CLUSTER BY
  district, market, commodity -- Cluster by frequently filtered columns
AS
SELECT
    *,
    -- Create a date column for partitioning
    DATE_TRUNC(price_date, MONTH) AS price_date_partition,

    -- Feature Engineering
    -- Lag features (price from the previous day)
    LAG(modal_price, 1) OVER (PARTITION BY district, market, commodity, variety, grade ORDER BY price_date) AS lag1_modal_price,

    -- Moving averages (e.g., 7-day and 30-day moving average of modal_price)
    AVG(modal_price) OVER (PARTITION BY district, market, commodity, variety, grade ORDER BY price_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg7_modal_price,
    AVG(modal_price) OVER (PARTITION BY district, market, commodity, variety, grade ORDER BY price_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS avg30_modal_price,

    -- Seasonality flags
    EXTRACT(MONTH FROM price_date) AS month,
    EXTRACT(DAYOFWEEK FROM price_date) AS day_of_week,
    EXTRACT(QUARTER FROM price_date) AS quarter

FROM
    `master_table`
WHERE
    modal_price IS NOT NULL;

-- Best Practice: Partitioning and Clustering
-- Partitioning by date (e.g., by month) is crucial for time-series data. It makes queries
-- that filter by a date range much faster and cheaper.
-- Clustering by district, market, and commodity will co-locate data for the same
-- time-series, improving performance for window functions and training.

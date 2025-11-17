-- 07_predict.sql
-- Makes predictions and generates recommendations.

-- This query forecasts the next 1 day.
-- You can change the horizon value to predict further into the future.
DECLARE HORIZON = 1;

-- This is the recommendation logic.
-- If predicted price is higher, sell. Otherwise, wait.
CREATE OR REPLACE TABLE `predictions` AS
WITH
  forecast AS (
    SELECT
      *
    FROM
      ML.FORECAST(MODEL `price_prediction_model`,
                  STRUCT(HORIZON AS horizon))
  ),
  current_prices AS (
    -- Get the latest price for each time series
    SELECT
        *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER(PARTITION BY district, market, commodity, variety, grade ORDER BY price_date DESC) as rn
        FROM `training_data`
    )
    WHERE rn = 1
  )
SELECT
  f.district,
  f.market,
  f.commodity,
  f.variety,
  f.grade,
  c.modal_price AS current_price,
  f.forecast_timestamp AS prediction_date,
  f.forecast_value AS predicted_tomorrow_price,
  -- Recommendation Logic
  CASE
    WHEN f.forecast_value > c.modal_price THEN 'Sell'
    ELSE 'Wait'
  END AS recommendation
FROM
  forecast f
JOIN
  current_prices c
ON
  f.district = c.district
  AND f.market = c.market
  AND f.commodity = c.commodity
  AND f.variety = c.variety
  AND f.grade = c.grade;

-- View the predictions
SELECT * FROM `predictions` LIMIT 100;

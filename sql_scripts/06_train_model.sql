-- 06_train_model.sql
-- Trains a time-series model using BigQuery ML.

CREATE OR REPLACE MODEL `price_prediction_model`
OPTIONS(
    MODEL_TYPE='ARIMA_PLUS',
    TIME_SERIES_TIMESTAMP_COL='price_date',
    TIME_SERIES_DATA_COL='modal_price',
    TIME_SERIES_ID_COL=['district', 'market', 'commodity', 'variety', 'grade'],
    AUTO_ARIMA_MAX_ORDER=5
) AS
SELECT
    price_date,
    modal_price,
    district,
    market,
    commodity,
    variety,
    grade
FROM
    `training_data`
WHERE
    price_date <= '2024-12-31' -- Train on data up to a certain point
;

-- Best Practice: Model Training and Evaluation
-- 1. Splitting Data: It's a good practice to split your data into training, validation, and test sets.
--    Here, I'm using data before a certain date for training. You should use a separate
--    dataset for evaluation that the model has not seen.
-- 2. Hyperparameter Tuning: `AUTO_ARIMA_MAX_ORDER` is a hyperparameter. You can tune it
--    to find the best model. BQML also provides automatic hyperparameter tuning.
-- 3. Evaluation: After training, use `ML.EVALUATE` to check the model's performance.
--    For example:
--    SELECT * FROM ML.EVALUATE(MODEL `price_prediction_model`)

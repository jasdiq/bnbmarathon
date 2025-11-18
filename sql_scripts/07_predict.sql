-- 07_predict.sql
-- Makes predictions using a remote Vertex AI model and generates recommendations.

-- This script is corrected to use a remote Vertex AI model endpoint.
-- The original script was using a model trained inside BigQuery (BigQuery ML).

-- PREREQUISITE 1: Create a BigQuery connection to Vertex AI in your project.
-- This allows BigQuery to call the Vertex AI model.
-- You can do this in the Google Cloud Console or with gcloud.
-- See: https://cloud.google.com/bigquery/docs/create-cloud-resource-connection

-- PREREQUISITE 2: Create a BigQuery remote model that points to your Vertex AI endpoint.
-- The model should be created in your dataset, e.g., `bcb-blr-abu.agri_dataset`.
/*
CREATE OR REPLACE MODEL `bcb-blr-abu.agri_dataset.price_prediction_vertex_model`
  REMOTE WITH CONNECTION `projects/your-gcp-project/locations/your-region/connections/your-connection-id`
  OPTIONS (endpoint = 'your-vertex-ai-endpoint-url');
*/

-- Step 1: Get the latest data for each item to pass to the model for prediction.
-- The features here should match what your Vertex AI model was trained on.
CREATE OR REPLACE TABLE `bcb-blr-abu.agri_dataset.predictions` AS
WITH
  latest_feature_data AS (
    SELECT
      *
    FROM (
      SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY district, market, commodity, variety, grade ORDER BY price_date DESC) as rn
      FROM
        `bcb-blr-abu.agri_dataset.training_data` -- Using feature-engineered data
    )
    WHERE
      rn = 1
  ),
  -- Step 2: Call the remote Vertex AI model to get predictions.
  vertex_predictions AS (
    SELECT
      *
    FROM
      ML.PREDICT(
        MODEL `bcb-blr-abu.agri_dataset.price_prediction_vertex_model`,
        (
          SELECT
            *
          FROM
            latest_feature_data
        )
      )
  )
-- Step 3: Join predictions with current price and generate recommendation.
SELECT
  p.district,
  p.market,
  p.commodity,
  p.variety,
  p.grade,
  d.modal_price AS current_price,
  -- IMPORTANT: Replace 'predicted_price' with the actual name of the prediction field
  -- from your Vertex AI model's output.
  p.predicted_price AS predicted_tomorrow_price,
  -- Recommendation Logic
  CASE
    WHEN p.predicted_price > d.modal_price THEN 'Sell'
    ELSE 'Wait'
  END AS recommendation
FROM
  vertex_predictions p
  JOIN latest_feature_data d ON p.district = d.district
  AND p.market = d.market
  AND p.commodity = d.commodity
  AND p.variety = d.variety
  AND p.grade = d.grade;

-- View the generated predictions
SELECT
  *
FROM
  `bcb-blr-abu.agri_dataset.predictions`
LIMIT
  100;
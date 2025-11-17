# preprocessing_notebook.py
# This script shows how to do preprocessing in a Vertex AI Notebook.

import pandas as pd
from google.cloud import bigquery

# Initialize BigQuery client
client = bigquery.Client()

# --- 1. Load Data ---
# Load the cleaned master table into a Pandas DataFrame.
query = "SELECT * FROM `master_table`"
df = client.query(query).to_dataframe()

# --- 2. Handle Missing Values ---
# For simplicity, we'll fill missing seasonal features with the mean.
# A better approach would be to use forward/backward fill or a more
# sophisticated imputation method.
for col in ['area', 'rainfall', 'temperature', 'yield', 'humidity']:
    df[col] = df.groupby(['district', 'commodity'])['season'].transform(
        lambda x: x.fillna(x.mean())
    )

# Drop rows where modal_price is missing
df.dropna(subset=['modal_price'], inplace=True)


# --- 3. Feature Engineering ---
# Create lag and moving average features.
df['price_date'] = pd.to_datetime(df['price_date'])
df = df.sort_values(by=['district', 'market', 'commodity', 'variety', 'grade', 'price_date'])

df['lag1_modal_price'] = df.groupby(['district', 'market', 'commodity', 'variety', 'grade'])['modal_price'].shift(1)
df['avg7_modal_price'] = df.groupby(['district', 'market', 'commodity', 'variety', 'grade'])['modal_price'].transform(lambda x: x.rolling(7, 1).mean())
df['avg30_modal_price'] = df.groupby(['district', 'market', 'commodity', 'variety', 'grade'])['modal_price'].transform(lambda x: x.rolling(30, 1).mean())

# Create seasonality features
df['month'] = df['price_date'].dt.month
df['day_of_week'] = df['price_date'].dt.dayofweek
df['quarter'] = df['price_date'].dt.quarter


# --- 4. Save Processed Data ---
# Save the processed DataFrame back to a new BigQuery table.
# This table can then be used for training a model in BQML or Vertex AI.
processed_table_id = "training_data_python"
job_config = bigquery.LoadJobConfig(
    write_disposition="WRITE_TRUNCATE",
)

client.load_table_from_dataframe(
    df, processed_table_id, job_config=job_config
).result()

print(f"Successfully created table {processed_table_id}")

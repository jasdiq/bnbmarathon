# AI Price Prediction Pipeline

This directory contains the scripts to build a complete AI price prediction pipeline using BigQuery ML.

## Pipeline Steps

1.  **Data Cleaning and Standardization**:
    *   `01_clean_data_season1.sql`: Cleans historical farming data.
    *   `02_clean_latest_data.sql`: Cleans latest daily prices.
    *   `03_clean_agg_data.sql`: Cleans aggregated price data.

2.  **Create Master Table**:
    *   `04_create_master_table.sql`: Joins the three sources into a single table.

3.  **Feature Engineering**:
    *   `05_feature_engineering.sql`: Creates lag features, moving averages, and seasonality flags.

4.  **Model Training**:
    *   `06_train_model.sql`: Trains a time-series model using BigQuery ML (`ARIMA_PLUS`).

5.  **Prediction**:
    *   `07_predict.sql`: Generates predictions and a "Sell/Wait" recommendation.

6.  **Optional Python Preprocessing**:
    *   `preprocessing_notebook.py`: A Python script for preprocessing in a Vertex AI Notebook.

## Best Practices and Recommendations

### Data Quality and Missing Values
*   **Check for NULLs**: After each cleaning and join step, check for `NULL` values in important columns.
*   **Handle Date Parsing Errors**: When parsing dates, always check for rows that failed to parse.
*   **Imputation Strategy**: You will have missing values, especially for the seasonal features in recent data. The `master_table` script uses a `LEFT JOIN`, which will result in `NULL`s. You need a strategy to fill these.
    *   **Simple**: Fill with the mean of the last known season.
    *   **Better**: Use forward fill (`FFILL`) to carry the last known value forward.
    *   **Advanced**: Use a more sophisticated imputation model.
    The optional Python script shows a simple mean-based imputation.

### Joining Logic
*   The current logic joins seasonal data based on the year. This is a reasonable simplification. For a more granular model, you could try to interpolate seasonal data across the year.
*   Ensure that the join keys (district, market, commodity) are clean and consistent across all tables. The cleaning scripts standardize commodity to lowercase, which helps. You should do a similar check for district and market names.

### Partitioning and Clustering
*   The `training_data` table is partitioned by month (`price_date_partition`) and clustered by `district`, `market`, and `commodity`.
*   **Partitioning** is crucial for time-series data. It prunes the data scanned in queries that have a date filter, which saves costs and improves performance.
*   **Clustering** co-locates data within a partition. Since you will be running queries that group by `district`, `market`, and `commodity` (e.g., for window functions or training), clustering on these columns will significantly improve performance.

### Model Training and Evaluation
*   **Train/Test Split**: Always split your data into training and testing sets. The training script uses a simple date-based split. You can also use the `DATA_SPLIT_METHOD` option in `CREATE MODEL`.
*   **Evaluation**: Use `ML.EVALUATE` to assess your model's performance on the test set. For time-series models, look at metrics like `mean_absolute_percentage_error`.
*   **Hyperparameter Tuning**: The `ARIMA_PLUS` model has hyperparameters you can tune. You can manually try different values or use BigQuery ML's automatic hyperparameter tuning.

### Running the Scripts
You can run these SQL scripts directly in the BigQuery console or use a tool like `bq` command-line tool to execute them. Make sure to run them in the numbered order.

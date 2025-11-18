import os
from pathlib import Path
import pandas as pd
from typing import Optional, Union

from dotenv import load_dotenv
from google.adk.agents import Agent
from google.adk.models.lite_llm import LiteLlm
import google.auth
from google.cloud import bigquery

# Load environment variables
root_dir = Path(__file__).parent.parent
dotenv_path = root_dir / ".env"
load_dotenv(dotenv_path=dotenv_path)

# Configure Google Cloud
try:
    credentials, project_id = google.auth.default()
    os.environ.setdefault("GOOGLE_CLOUD_PROJECT", project_id)
except Exception:
    project_id = "gcp-project-id" # replace with your project ID
    pass

os.environ.setdefault("GOOGLE_CLOUD_LOCATION", "us-central1")
os.environ.setdefault("BIGQUERY_DATASET", "agri_dataset")


# Configure model connection
# gemma_model_name = os.getenv("GEMMA_MODEL_NAME", "gemma-2b-it-quant")
# api_base = os.getenv("OLLAMA_API_BASE", "http://localhost:11434")  # Location of Ollama server


def query_predictions(
    commodity: str, district: Optional[str] = None, market: Optional[str] = None
) -> Union[pd.DataFrame, str]:
    """Queries the BigQuery `predictions` table to get price predictions.

    Args:
        commodity: The commodity to get the price prediction for.
        district: The district to filter by.
        market: The market to filter by.

    Returns:
        A pandas DataFrame with the query results or an error message.
    """
    try:
        client = bigquery.Client(project=project_id)
        dataset_id = os.environ["BIGQUERY_DATASET"]
        table_id = "predictions"

        # Construct the query
        query = f"""
            SELECT
                current_price,
                predicted_tomorrow_price,
                recommendation
            FROM
                `{project_id}.{dataset_id}.{table_id}`
            WHERE
                commodity = @commodity
        """
        params = [bigquery.ScalarQueryParameter("commodity", "STRING", commodity)]

        if district:
            query += " AND district = @district"
            params.append(bigquery.ScalarQueryParameter("district", "STRING", district))
        if market:
            query += " AND market = @market"
            params.append(bigquery.ScalarQueryParameter("market", "STRING", market))

        # Execute the query
        job_config = bigquery.QueryJobConfig(query_parameters=params)
        query_job = client.query(query, job_config=job_config)
        return query_job.to_dataframe()

    except Exception as e:
        return f"An error occurred: {e}"


# Production Gemma Agent - GPU-accelerated conversational assistant
production_agent = Agent(
    model=LiteLlm(model="gemini/gemini-1.5-flash-latest"),
    name="agri_advisor",
    description="A conversational assistant for agricultural price prediction.",
    instruction="""Your task is to answer user questions about agricultural prices.
You have one tool: `query_predictions`.
This tool takes `commodity`, `district`, and `market` as arguments.
When a user asks for a price, call the `query_predictions` tool with the arguments from the user's question.
Do not make up answers. Only use the tool.""",
    tools=[query_predictions],
)

# Set as root agent
root_agent = production_agent
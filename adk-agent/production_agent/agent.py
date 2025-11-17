import os
from pathlib import Path

from dotenv import load_dotenv
from google.adk.agents import Agent
from google.adk.models.lite_llm import LiteLlm
import google.auth

# Load environment variables
root_dir = Path(__file__).parent.parent
dotenv_path = root_dir / ".env"
load_dotenv(dotenv_path=dotenv_path)

# Configure Google Cloud
try:
    _, project_id = google.auth.default()
    os.environ.setdefault("GOOGLE_CLOUD_PROJECT", project_id)
except Exception:
    pass

os.environ.setdefault("GOOGLE_CLOUD_LOCATION", "europe-west1")

# Configure model connection
gemma_model_name = os.getenv("GEMMA_MODEL_NAME", "gemma3:270m")
api_base = os.getenv("OLLAMA_API_BASE", "localhost:10010")  # Location of Ollama server

from google.adk.tools.bigquery import BigQuery

# Production Gemma Agent - GPU-accelerated conversational assistant
production_agent = Agent(
   model=LiteLlm(model=f"ollama_chat/{gemma_model_name}", api_base=api_base),
   name="agri_advisor",
   description="A production-ready conversational assistant for agricultural price prediction.",
   instruction="""You are 'Agri-Advisor', a friendly and knowledgeable agricultural assistant.
   Your main goal is to provide farmers with price predictions and recommendations.

   You have access to a BigQuery tool that can query a `predictions` table.
   This table contains the following columns:
   - district
   - market
   - commodity
   - variety
   - grade
   - current_price
   - predicted_tomorrow_price
   - recommendation (Sell / Wait)

   When a user asks for a price prediction, you should:
   1. Ask for the commodity, district, and market if they are not provided.
   2. Use the BigQuery tool to query the `predictions` table. For example:
      `SELECT current_price, predicted_tomorrow_price, recommendation FROM `predictions` WHERE commodity = 'wheat' AND district = 'some-district' AND market = 'some-market'`
   3. Provide the user with the current price, the predicted price for tomorrow, and the recommendation.

   Keep your tone helpful and professional. 🌾📈""",
   tools=[BigQuery()],
)

# Set as root agent
root_agent = production_agent
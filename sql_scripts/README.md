# 🌾 PriceGenie AI – Agricultural Price Prediction & Decision Support  
AI-driven price forecasting using BigQuery ML, Cloud Run, and the Google ADK Agent

PriceGenie AI is an end-to-end agricultural market intelligence system that predicts commodity prices and provides actionable recommendations such as **Sell** or **Wait** for farmers, traders, grocery owners, and local markets.

This project uses **BigQuery ML (ARIMA+ Model)**, **SQL-based ETL pipelines**, **Python preprocessing**, and a **Cloud Run–deployed ADK Agent** to deliver real-time price insights.

## 🚀 Key Features

### ✔️ AI Price Forecasting
Predicts future commodity prices using BigQuery’s ARIMA_PLUS time-series modeling.

### ✔️ Sell / Wait Recommendation Engine
Generates actionable recommendations based on predicted price movements.

### ✔️ Fully Automated Pipeline
- Cleans raw agricultural datasets  
- Builds master tables  
- Engineers time-series features  
- Trains models  
- Generates predictions  

### ✔️ ADK Agent Deployment
A conversational agent serves predictions via a FastAPI backend running on Cloud Run.

### ✔️ Scalable Cloud Architecture
- BigQuery storage & ML  
- ADK agent on Cloud Run  
- Load testing using autoscaling tests  
- Containerized builds with Cloud Build  

---

# 📁 Project Structure

```
adk-agent/
├── cloudbuild.yaml              # Cloud Build for deploying PriceGenie AI agent
├── Dockerfile                   # Container for Cloud Run deployment
├── elasticity_test.py           # Load test for autoscaling
├── pyproject.toml               # Dependencies for ADK agent
├── server.py                    # FastAPI server exposing prediction/chat endpoints
├── test_gemini.py               # Model integration test
├── production_adk_agent.egg-info/
│   ├── PKG-INFO
│   ├── requires.txt
│   └── SOURCES.txt
├── production_agent/
│   ├── agent.py                 # Core ADK agent logic for PriceGenie AI
│   └── __init__.py
└── __pycache__/
```

---

# 🔄 AI Pipeline Overview

PriceGenie AI follows a structured BigQuery ML pipeline built using SQL scripts:

### 1. Data Cleaning
- `01_clean_data_season1.sql`
- `02_clean_latest_data.sql`
- `03_clean_agg_data.sql`

### 2. Master Table Creation
- `04_create_master_table.sql`  

### 3. Feature Engineering
- `05_feature_engineering.sql`

### 4. Model Training (BigQuery ML)
- `06_train_model.sql`  

### 5. Prediction + Recommendation
- `07_predict.sql`

### 6. Optional Python Preprocessing
`preprocessing_notebook.py`

---

# 🧠 Best Practices Used in PriceGenie AI

### ✔️ Data Quality Checks
- NULL checks after joins  
- Seasonal data validation  
- Forward fill and mean-based imputation  

### ✔️ BigQuery Optimizations
- Partitioning on `price_date_partition`  
- Clustering on `district`, `market`, `commodity`  

### ✔️ ML Evaluation
Metrics used:  
- MAPE  
- RMSE  

---

# ☁️ Cloud Run + ADK Agent Deployment

### ADK Agent Responsibilities
- Answer price questions  
- Trigger model predictions  
- Explain Sell/Wait recommendations  
- Chat interface integration  

### Deployment Steps
1. Build using `cloudbuild.yaml`  
2. Deploy container to Cloud Run  
3. Expose FastAPI server (`server.py`)  
4. Test with ADK Web interface  
5. Run `elasticity_test.py` for autoscaling  

---

# 📊 End-to-End Flow Diagram (Text Version)

```
Raw Price Data
      ↓
SQL Cleaning Scripts
      ↓
Master Table
      ↓
Feature Engineering
      ↓
BigQuery ML (ARIMA+)
      ↓
Predictions Table
      ↓
ADK Agent via Cloud Run
      ↓
User gets: Price Prediction + Sell/Wait Recommendation
```

---

# 📜 How This Aligns With the "PriceGenie AI" Project Goals

This repository directly supports:  
✔️ Agricultural price prediction  
✔️ Market decision support (Sell/Wait engine)  
✔️ BigQuery ML model pipeline  
✔️ Cloud-based agent for end users  
✔️ Complete ETL + ML + API architecture  
✔️ Solving real-world farmer and grocery market problems  

---

# 📞 Contact / Notes
Maintained by: **Abubakar Siddique**  
Project: **PriceGenie AI – Agricultural Price Intelligence System**  

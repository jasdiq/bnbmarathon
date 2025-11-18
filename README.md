# 🌾 PriceGenie AI – Agricultural Price Prediction & Decision Support  
AI-driven price forecasting using BigQuery ML, Cloud Run, and ADK Agent

PriceGenie AI is an end-to-end agricultural price intelligence platform that predicts commodity prices and provides actionable recommendations such as **Sell** or **Wait**.

This repository includes:
- A full **BigQuery ML pipeline**
- A deployable **ADK Agent** running on Cloud Run
- A **GPU backend (Ollama)** for LLM inference
- Load testing, containerization, and automation setups

---

# 📁 Repository Structure

```
accelerate-ai-lab3-starter/
├── README.md                         # Main documentation
│
├── adk-agent/
│   ├── cloudbuild.yaml
│   ├── Dockerfile
│   ├── elasticity_test.py
│   ├── pyproject.toml
│   ├── server.py
│   ├── test_gemini.py
│   ├── uv.lock
│   ├── production_adk_agent.egg-info/
│   └── production_agent/
│       ├── agent.py
│       └── __init__.py
│
├── ollama-backend/
│   └── Dockerfile
│
└── sql_scripts/
    ├── 01_clean_data_season1.sql
    ├── 02_clean_latest_data.sql
    ├── 03_clean_agg_data.sql
    ├── 04_create_master_table.sql
    ├── 05_feature_engineering.sql
    ├── 06_train_model.sql
    ├── 07_predict.sql
    ├── preprocessing_notebook.py
    └── README.md
```

---

# 🔄 Pipeline Overview

### 1️⃣ Cleaning – SQL  
### 2️⃣ Master Table  
### 3️⃣ Feature Engineering  
### 4️⃣ Model Training – ARIMA_PLUS  
### 5️⃣ Prediction + Sell/Wait  
### 6️⃣ ADK Agent Deployment  
### 7️⃣ GPU Backend for LLM Reasoning  

---

# 📞 Maintainer  
**Abubakar Siddique**  

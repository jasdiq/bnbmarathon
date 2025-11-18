# 🌾 AI Price Prediction Pipeline (BigQuery ML)

This project contains a complete **AI-powered agricultural price prediction pipeline** built using **BigQuery ML**, along with supporting scripts, cleaning workflows, and production-ready components deployed using an ADK agent.

## 📌 Key Components

### ✔️ Data Cleaning  
Scripts to standardize, normalize, and clean raw price datasets.

| Script | Purpose |
|--------|---------|
| `01_clean_data_season1.sql` | Cleans historical farming data |
| `02_clean_latest_data.sql` | Cleans latest daily market prices |
| `03_clean_agg_data.sql` | Cleans aggregated commodity-level pricing data |

---

### ✔️ Master Table Creation  
| Script | Purpose |
|--------|---------|
| `04_create_master_table.sql` | Joins cleaned tables → creates a single unified training dataset |

---

### ✔️ Feature Engineering  
| Script | Purpose |
|--------|---------|
| `05_feature_engineering.sql` | Creates lag features, moving averages, seasonal flags, and trend features |

---

### ✔️ Model Training (BigQuery ML)  
| Script | Purpose |
|--------|---------|
| `06_train_model.sql` | Trains ARIMA_PLUS / time-series model using BigQuery ML |

---

### ✔️ Prediction  
| Script | Purpose |
|--------|---------|
| `07_predict.sql` | Generates predictions + Sell/Wait recommendation |

---

### ✔️ Optional Preprocessing (Python)

`preprocessing_notebook.py` – runs inside Vertex AI Notebook to preprocess, visualize, and fix missing values.

---

## 🧠 Best Practices & Recommendations

### 🔍 1. Data Quality  
- Always check for **NULLs after cleaning & joining**  
- Validate date formats  
- Standardize commodity, district, and market names  

**Missing Value Strategy**  
- Simple: Fill season gaps using historical mean  
- Better: Forward fill (FFILL)  
- Advanced: ML-based imputation

---

### 🔗 2. Joining Logic  
- Ensure consistent keys across all tables  
- Seasonal table joined by year (acceptable simplification)

---

### 🗂️ 3. Partitioning & Clustering  
- Partition by: `price_date_partition`  
- Cluster by: `district`, `market`, `commodity`  

Benefits:  
- Faster queries  
- Lower BigQuery cost  
- Better performance for window functions

---

### 🤖 4. Model Training & Evaluation  
- Use date-based train/test split  
- Evaluate with metrics like:  
  - mean_absolute_percentage_error  
  - root_mean_squared_error  
- Tune ARIMA_PLUS hyperparameters

---

## ▶️ 5. Running the Pipeline  

Run scripts in this order:

```
01_clean_data_season1.sql
02_clean_latest_data.sql
03_clean_agg_data.sql
04_create_master_table.sql
05_feature_engineering.sql
06_train_model.sql
07_predict.sql
```

Run via console or:

```bash
bq query --use_legacy_sql=false < script.sql
```

---

# 📁 Project File Structure

```
adk-agent/
├── cloudbuild.yaml
├── Dockerfile
├── elasticity_test.py
├── pyproject.toml
├── server.py
├── test_gemini.py
├── uv.lock
├── production_adk_agent.egg-info/
│   ├── dependency_links.txt
│   ├── PKG-INFO
│   ├── requires.txt
│   ├── SOURCES.txt
│   └── top_level.txt
├── production_agent/
│   ├── agent.py
│   └── __init__.py
└── __pycache__/
```

---

# 🚀 End-to-End Flow

1. Clean raw farming data  
2. Build master dataset  
3. Engineer features  
4. Train ARIMA+ model  
5. Predict prices  
6. Recommend “Sell / Wait”  
7. Deploy ADK agent  
8. Run load tests on Cloud Run  

---

# 📦 Deployment Notes

### Cloud Run  
- Containerized via Dockerfile  
- Auto-scaling tested using elasticity_test.py

### Cloud Build  
- Build & push using cloudbuild.yaml

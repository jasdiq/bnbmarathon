FROM python:3.13-slim

# Copy uv from the official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Install system dependencies
RUN apt-get update && apt-get install -y curl build-essential pkg-config && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application files
COPY pyproject.toml uv.lock ./
COPY production_agent/ ./production_agent/
COPY server.py .

# Install Python dependencies
RUN uv sync

# Expose port
EXPOSE 8080

# Run the application
CMD ["uv", "run", "uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install minimal build deps for Pillow and other packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libjpeg-dev \
       zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . /app

ENV PORT=5000
EXPOSE 5000

# Use Gunicorn to serve the Flask app defined in run.py
CMD ["gunicorn", "run:app", "--bind", "0.0.0.0:5000", "--workers", "2"]

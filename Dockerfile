# Stage 1: Builder
FROM python:3.11 AS builder

WORKDIR /app

# Create virtual environment
RUN python -m venv venv

# Install dependencies into venv
COPY requirements.txt .
RUN venv/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim

WORKDIR /app

# Copy the venv
COPY --from=builder /app/venv ./venv

# Copy your application
COPY app.py .

# Use venv's Python
ENV PATH="/app/venv/bin:$PATH"

EXPOSE 3000

CMD ["gunicorn", "--bind", "0.0.0.0:3000", "app:app"]
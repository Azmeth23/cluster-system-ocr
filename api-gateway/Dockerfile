FROM python:3.11-slim

# system environment variables for poetry and python optimization
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    POETRY_VERSION=1.8.2 \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

ENV PATH="$POETRY_HOME/bin:$PATH"

# installs system dependencies and poetry 
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gcc \
    python3-dev \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# leverage docker layer caching
COPY pyproject.toml poetry.lock ./

# installs just the production dependencies
RUN poetry install --no-root --only main

# copy apps source code
COPY api-gateway.py ./

EXPOSE 8000

CMD ["uvicorn", "api-gateway:app", "--host", "0.0.0.0", "--port", "8000"]
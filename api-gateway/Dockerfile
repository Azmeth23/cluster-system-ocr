FROM python:3.11-slim

# irradicates the interruptions or unnessary builds during setup + 
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
    && curl -sSL https://install.python-poetry.org | python3 - \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# layer caching
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --only main

COPY api-gateway.py ./

EXPOSE 8000

CMD ["uvicorn", "api-gateway:app", "--host", "0.0.0.0", "--port", "8000"]

#references:
#https://github.com/wemake-services/wemake-django-template/blob/master/%7B%7Bcookiecutter.project_name%7D%7D/docker/django/Dockerfile
#https://stackoverflow.com/questions/53835198/integrating-python-poetry-with-docker
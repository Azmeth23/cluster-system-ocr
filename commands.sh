#!/bin/bash
set -e

# install poetry
pipx install poetry --force

# install tesseract
sudo apt update && sudo apt install -y tesseract-ocr tesseract-ocr-eng

# install poetry dependencies
cd ocr-model && poetry install --no-root && cd ..
cd api-gateway && poetry install --no-root && cd ..

# starts ocr
cd ocr-model && poetry run python model.py &

# starts the Fastapi
cd api-gateway && poetry run python api-gateway.py
SHELL := /bin/bash
.PHONY: help install data process train clean

# Python interpreter - use python from a virtualenv if it exists
PYTHON := $(shell command -v $(shell cat .python-version 2>/dev/null || echo python3) 2>/dev/null || echo python3)

help:
	@echo "Available commands:"
	@echo "  make install      - Install dependencies"
	@echo "  make data         - Run data processing scripts (e.g., download, generate features)"
	@echo "  make process      - Alias for make data"
	@echo "  make train        - Train the model"
	@echo "  make clean        - Clean up temporary files"

install: requirements.txt environment.yml
	@if [ -f "environment.yml" ]; then \
		echo ">>> Creating environment from environment.yml (Conda)"; \
		conda env create -f environment.yml || echo "Conda environment creation failed or already exists. Try 'conda env update -f environment.yml --prune'"; \
	elif [ -f "requirements.txt" ]; then \
		echo ">>> Installing dependencies from requirements.txt (pip)"; \
		$(PYTHON) -m venv venv; \
		source venv/bin/activate; \
		pip install --upgrade pip; \
		pip install -r requirements.txt; \
	else \
		echo "No requirements.txt or environment.yml found."; \
	fi

data:
	@echo "Running data processing scripts... (customize this command)"
	# $(PYTHON) src/data_processing/make_dataset.py

process: data

train:
	@echo "Training model... (customize this command)"
	# $(PYTHON) src/modeling/train_model.py

clean:
	@echo "Cleaning up..."
	find . -type f -name '*.py[co]' -delete
	find . -type d -name '__pycache__' -delete
	# Ajoutez d'autres commandes de nettoyage ici


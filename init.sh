#!/bin/bash

# Script pour générer une architecture de projet de Machine Learning

# Nom du projet (peut être passé en argument, sinon utilise "mon_projet_ml")
#PROJECT_NAME=${1:-mon_projet_ml}

# Vérifier si le répertoire du projet existe déjà
#if [ -d "$PROJECT_NAME" ]; then
#  echo "Le répertoire '$PROJECT_NAME' existe déjà. Veuillez choisir un autre nom ou le supprimer."
#  exit 1
#fi

echo "Création de l'architecture"

# Création du répertoire racine du projet
#mkdir "$PROJECT_NAME"
#cd "$PROJECT_NAME" || exit # Navigue dans le répertoire du projet ou quitte si échec

# --- data ---
mkdir -p data/01_raw data/02_intermediate data/03_primary data/04_features data/05_model_input data/06_models_output
touch data/01_raw/.gitkeep # Pour que Git versionne le répertoire même vide
touch data/02_intermediate/.gitkeep
touch data/03_primary/.gitkeep
touch data/04_features/.gitkeep
touch data/05_model_input/.gitkeep
touch data/06_models_output/.gitkeep

# --- docs ---
mkdir -p docs/figures
touch docs/report.md

# --- models ---
mkdir models
touch models/.gitkeep

# --- notebooks ---
mkdir notebooks
touch notebooks/01_data_exploration.ipynb
touch notebooks/02_feature_engineering_tests.ipynb
touch notebooks/03_model_prototyping.ipynb

# --- src ---
mkdir -p src/data_processing src/features src/modeling src/visualization src/utils
touch src/__init__.py
touch src/data_processing/__init__.py src/data_processing/make_dataset.py src/data_processing/utils.py
touch src/features/__init__.py src/features/build_features.py
touch src/modeling/__init__.py src/modeling/train_model.py src/modeling/predict_model.py src/modeling/evaluate_model.py
touch src/visualization/__init__.py src/visualization/plot_utils.py
touch src/utils/__init__.py src/utils/helpers.py

# --- tests ---
mkdir tests
touch tests/__init__.py
touch tests/test_data_processing.py
touch tests/test_modeling.py

# --- config ---
mkdir config
touch config/main_config.yaml
touch config/logging_config.yaml

# --- Fichiers à la racine ---
touch .dockerignore
touch .env.example
touch Dockerfile
touch LICENSE
touch Makefile
touch setup.py

# --- Contenu de base pour certains fichiers ---

#echo "# Fichier README pour $PROJECT_NAME

## Description du Projet
#[Décrivez votre projet ici]

## Installation
#1. Clonez le dépôt : \`git clone <url_du_depot>\`
#2. Naviguez dans le répertoire : \`cd $PROJECT_NAME\`
#3. Créez l'environnement (exemple avec Conda) : \`conda env create -f environment.yml\`
#4. Activez l'environnement : \`conda activate <nom_env_conda>\`
#   (ou avec venv: \`python -m venv venv && source venv/bin/activate && pip install -r requirements.txt\`)

## Utilisation
#[Expliquez comment exécuter votre code, par exemple :]
#\`python src/modeling/train_model.py\`
#" > README.md

echo "# Fichiers et répertoires à ignorer par Git

# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
pip-wheel-metadata/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
.python-version

# poetry
poetry.lock

# PEP 582; __pypackages__
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# Data files
data/01_raw/*
data/02_intermediate/*
data/03_primary/*
# Commentez/décommentez selon si vous voulez versionner certains types de données nettoyées
# !data/03_primary/schema.json

# Modèles
models/*
!models/.gitkeep

# Logs
logs/
*.log

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
" > .gitignore

echo "# Exemple de contenu pour requirements.txt
# Ajoutez vos dépendances pip ici, ex:
# pandas
# scikit-learn
# matplotlib
# jupyterlab
" > requirements.txt

echo "# Exemple de contenu pour environment.yml (Conda)
name: ${PROJECT_NAME}_env # Nom de l'environnement conda
channels:
  - defaults
  - conda-forge # Souvent utile pour des packages plus récents
dependencies:
  - python=3.9 # Spécifiez votre version de Python
  - pip
#  - pandas
#  - numpy
#  - scikit-learn
#  - matplotlib
#  - jupyterlab
#  - pip:
#    - -r requirements.txt # Si vous voulez aussi utiliser pip pour certaines dépendances
" > environment.yml

echo "# Fichiers à ignorer lors de la construction de l'image Docker
__pycache__
*.pyc
*.pyo
*.pyd
.Python
.git
.gitignore
.env
env/
venv/
# Ajoutez d'autres fichiers ou dossiers que vous ne voulez pas dans votre image Docker
# Par exemple, de gros fichiers de données si elles sont montées autrement
data/01_raw
data/02_intermediate
" > .dockerignore


# Contenu de base pour Makefile (optionnel, mais utile)
echo "SHELL := /bin/bash
.PHONY: help install data process train clean

# Python interpreter - use python from a virtualenv if it exists
PYTHON := \$(shell command -v \$(shell cat .python-version 2>/dev/null || echo python3) 2>/dev/null || echo python3)

help:
	@echo \"Available commands:\"
	@echo \"  make install      - Install dependencies\"
	@echo \"  make data         - Run data processing scripts (e.g., download, generate features)\"
	@echo \"  make process      - Alias for make data\"
	@echo \"  make train        - Train the model\"
	@echo \"  make clean        - Clean up temporary files\"

install: requirements.txt environment.yml
	@if [ -f \"environment.yml\" ]; then \\
		echo \">>> Creating environment from environment.yml (Conda)\"; \\
		conda env create -f environment.yml || echo \"Conda environment creation failed or already exists. Try 'conda env update -f environment.yml --prune'\"; \\
	elif [ -f \"requirements.txt\" ]; then \\
		echo \">>> Installing dependencies from requirements.txt (pip)\"; \\
		\$(PYTHON) -m venv venv; \\
		source venv/bin/activate; \\
		pip install --upgrade pip; \\
		pip install -r requirements.txt; \\
	else \\
		echo \"No requirements.txt or environment.yml found.\"; \\
	fi

data:
	@echo \"Running data processing scripts... (customize this command)\"
	# \$(PYTHON) src/data_processing/make_dataset.py

process: data

train:
	@echo \"Training model... (customize this command)\"
	# \$(PYTHON) src/modeling/train_model.py

clean:
	@echo \"Cleaning up...\"
	find . -type f -name '*.py[co]' -delete
	find . -type d -name '__pycache__' -delete
	# Ajoutez d'autres commandes de nettoyage ici
" > Makefile


cd .. # Retourne au répertoire parent
echo "Architecture du projet '$PROJECT_NAME' créée avec succès."
echo "N'oubliez pas d'initialiser un dépôt Git si vous le souhaitez : cd $PROJECT_NAME && git init"

# DataHub Quickstart

## Setup with uv

Run the following commands from this directory:

```
# Create virtual environment in .venv
uv venv .

# Install project dependencies from pyproject.toml
uv sync

# Activate the virtual environment
source .venv/bin/activate
```

## Start DataHub (Docker)

```
datahub docker quickstart --quickstart-compose-file docker-compose.yml
```

## Stop

```
datahub docker quickstart stop
```

## Default Credentials
DataHub UI at http://localhost:9002 in your browser.

```
username: datahub
password: datahub
```
## Create Token from DataHub UI
1. Login to DataHub UI with default credentials.
2. Click on your username in the top right corner.
3. Select "Profile" from the dropdown menu.
4. Click on "Generate Token".
5. Copy the generated token.

#!/bin/bash

# Activate the virtual environment and run mcp-server-motherduck from the local installation
source .venv/bin/activate

# Run mcp-server-motherduck with the same parameters as before
mcp-server-motherduck \
    --transport sse \
    --port 8000 \
    --db-path federated.db \
    --init-sql connect.sql
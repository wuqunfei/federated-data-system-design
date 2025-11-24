# Federated Insurance Data System - Customer 360 View

This project demonstrates how to create a comprehensive customer 360 view by federating data across multiple insurance business units using DuckDB and DataHub.

## Overview

The solution integrates data from three major insurance lines:

| Insurance Line | Platform | Data Type |
|---|---|---|
| House Insurance | Snowflake | Customer demographics, policies, and claims |
| Travel Insurance | Databricks | Traveler profiles, policies, and claims |
| Vehicle Insurance | PostgreSQL | Vehicle information linked to policies |

## Architecture

### Data Sources
| Insurance Category | Platform | Schema/Database | Tables | Description |
|---|---|---|---|---|
| House Insurance | Snowflake | `pc.house_insurance` | `dim_customers`, `fact_policies`, `fact_claims` | Customer demographic and profile information, policy details, and claim records |
| Travel Insurance | Databricks | `workspace.travel_insurance` | `travelers`, `policies`, `claims` | Traveler profile information, policy details, and claim records |
| Vehicle Data | PostgreSQL | `public` | `vehicles` | Vehicle details linked to insurance policies |

### DataHub Integration
The solution leverages DataHub to:
- Discover insurance-related datasets across platforms
- Understand schema relationships and data models
- Identify common customer identifiers across different insurance lines

### DuckDB Federation
DuckDB's federated querying capabilities allow joining data from:
- Snowflake (house insurance)
- Databricks (travel insurance)
- PostgreSQL (vehicle data)
- All from a single query interface

## Solution Components

### 1. Customer 360 View Query (`src/customer_360_view.sql`)
A comprehensive SQL query that:
- Joins customer data across insurance lines
- Aggregates policy information from multiple sources
- Combines claims data for a complete view
- Includes vehicle information for customers with auto insurance

### 2. Python Application (`main.py`)
A Python application that:
- Uses DuckDB to execute federated queries
- Processes the customer 360 view results
- Outputs results in CSV format
- Provides summary statistics

## Usage

1. Ensure dependencies are installed:
   ```bash
   pip install -e .
   ```

2. Run the application:
   ```bash
   python main.py
   ```

3. The application will:
   - Execute the federated query
   - Display results in the console
   - Save results to `customer_360_view_results.csv`
   - Show summary statistics

## Key Features

| Feature | Description |
|---|---|
| Cross-Platform Federation | Seamlessly joins data from different database systems |
| Comprehensive Customer View | Combines information from house, travel, and vehicle insurance |
| Scalable Architecture | Designed to handle multiple data sources efficiently |
| DataHub Integration | Leverages data discovery and schema understanding capabilities |

## Output

The solution produces a unified customer view that includes:
- Personal information (name, contact details, demographics)
- House insurance policies and claims
- Travel insurance policies and claims
- Vehicle information (when applicable)
- Risk scores and credit information
- Policy status and coverage details

This enables insurance companies to have a complete view of their customers across all product lines, supporting better risk assessment, cross-selling opportunities, and customer service.


## Instructions to Run Locally for snowflake client
https://github.com/iqea-ai/duckdb-snowflake
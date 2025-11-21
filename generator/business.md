Role: Python Data Engineer.

Task: Write a Python script using DuckDB (or a similar OLAP engine) to build a federated query engine for a Customer 360 dashboard.

Input Data:

PostgreSQL: Table car_insurance (key: customer_id)

Snowflake: Table house_insurance (key: customer_id)

Databricks: Table travel_insurance (key: customer_id)

Kafka Topic: health_tracking (JSON stream with customer_id)

Functional Requirements:

Demonstrate how to configure the connectors for Postgres, Snowflake, and Databricks within the Python script.

Show a method to consume the Kafka stream and make it queryable (e.g., reading into a DuckDB table or a local Parquet file first).

Write a single SQL query that joins all four sources on customer_id.

Explain how to expose this result to a dashboard (e.g., via Streamlit or by exporting to a view).
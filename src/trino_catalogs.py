from __future__ import annotations
from typing import Dict, Optional
from src.settings import AppSettings


class CatalogPropertiesBuilder:
    def __init__(self, settings: AppSettings) -> None:
        self.s = settings

    def postgres_properties(self, catalog_name: Optional[str] = None) -> Dict[str, str]:
        url = f"jdbc:postgresql://{self.s.POSTGRES_HOST_PORT}/{self.s.POSTGRES_DATABASE}" if self.s.POSTGRES_DATABASE else f"jdbc:postgresql://{self.s.POSTGRES_HOST_PORT}"
        return {
            "connector.name": "postgresql",
            "connection-url": url,
            "connection-user": self.s.POSTGRES_USERNAME or "",
            "connection-password": self.s.POSTGRES_PASSWORD or "",
        }

    def snowflake_properties(self, catalog_name: Optional[str] = None) -> Dict[str, str]:
        account = self.s.SNOWFLAKE_ACCOUNT_ID or ""
        url = f"jdbc:snowflake://{account}.snowflakecomputing.com:443"
        props: Dict[str, str] = {
            "connector.name": "snowflake",
            "connection-url": url,
            "connection-user": self.s.SNOWFLAKE_USERNAME or "",
            "connection-password": self.s.SNOWFLAKE_PASSWORD or "",
        }
        if self.s.SNOWFLAKE_DATABASE:
            props["snowflake.database"] = self.s.SNOWFLAKE_DATABASE
        if self.s.SNOWFLAKE_SCHEMA:
            props["snowflake.schema"] = self.s.SNOWFLAKE_SCHEMA
        if self.s.SNOWFLAKE_WAREHOUSE:
            props["snowflake.warehouse"] = self.s.SNOWFLAKE_WAREHOUSE
        if self.s.SNOWFLAKE_ROLE:
            props["snowflake.role"] = self.s.SNOWFLAKE_ROLE
        return props

    def databricks_iceberg_properties(self, catalog_name: Optional[str] = None) -> Dict[str, str]:
        uri = f"{self.s.DATABRICKS_WORKSPACE_URL.rstrip('/')}/api/2.1/unity-catalog/"
        props: Dict[str, str] = {
            "connector.name": "iceberg",
            "iceberg.catalog.type": "rest",
            "iceberg.rest-catalog.uri": uri,
        }
        if self.s.DATABRICKS_TOKEN:
            props["iceberg.rest-catalog.oauth2.token"] = self.s.DATABRICKS_TOKEN
        if self.s.DATABRICKS_CATALOG:
            props["iceberg.rest-catalog.prefix"] = self.s.DATABRICKS_CATALOG
        return props

    def to_properties_text(self, props: Dict[str, str]) -> str:
        return "\n".join([f"{k}={v}" for k, v in props.items()]) + "\n"

    def create_catalog_sql(self, name: str, props: Dict[str, str], using: str) -> str:
        items = ",\n    ".join([f"\"{k}\" = '{v}'" for k, v in props.items()])
        return f"CREATE CATALOG {name}\n  USING {using}\n  WITH (\n    {items}\n  )"

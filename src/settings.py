from typing import Optional
from pydantic_settings import BaseSettings, SettingsConfigDict


class AppSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    DATAHUB_GMS_URL: str
    DATAHUB_TOKEN: Optional[str] = None

    POSTGRES_HOST_PORT: Optional[str] = None
    POSTGRES_USERNAME: Optional[str] = None
    POSTGRES_PASSWORD: Optional[str] = None
    POSTGRES_DATABASE: Optional[str] = None
    POSTGRES_PLATFORM_INSTANCE: Optional[str] = None
    POSTGRES_ENV: Optional[str] = "PROD"

    SNOWFLAKE_ACCOUNT_ID: Optional[str] = None
    SNOWFLAKE_USERNAME: Optional[str] = None
    SNOWFLAKE_PASSWORD: Optional[str] = None
    SNOWFLAKE_ROLE: Optional[str] = None
    SNOWFLAKE_WAREHOUSE: Optional[str] = None
    SNOWFLAKE_ENV: Optional[str] = "PROD"

    KAFKA_BOOTSTRAP: Optional[str] = None
    KAFKA_SCHEMA_REGISTRY_URL: Optional[str] = None
    KAFKA_PLATFORM_INSTANCE: Optional[str] = None
    KAFKA_ENV: Optional[str] = "PROD"
    KAFKA_SECURITY_PROTOCOL: Optional[str] = None
    KAFKA_SASL_MECHANISM: Optional[str] = None
    KAFKA_SASL_USERNAME: Optional[str] = None
    KAFKA_SASL_PASSWORD: Optional[str] = None
    SCHEMA_REGISTRY_BASIC_AUTH_USER_INFO: Optional[str] = None

    DATABRICKS_WORKSPACE_URL: Optional[str] = None
    DATABRICKS_TOKEN: Optional[str] = None
    DATABRICKS_ENV: Optional[str] = "PROD"

    def is_postgres_configured(self) -> bool:
        return all([
            self.POSTGRES_HOST_PORT,
            self.POSTGRES_USERNAME,
            self.POSTGRES_PASSWORD,
        ])

    def is_snowflake_configured(self) -> bool:
        return all([
            self.SNOWFLAKE_ACCOUNT_ID,
            self.SNOWFLAKE_USERNAME,
            self.SNOWFLAKE_PASSWORD,
            self.SNOWFLAKE_ROLE,
            self.SNOWFLAKE_WAREHOUSE,
        ])

    def is_kafka_configured(self) -> bool:
        return all([
            self.KAFKA_BOOTSTRAP,
            self.KAFKA_SCHEMA_REGISTRY_URL,
        ])

    def is_databricks_configured(self) -> bool:
        return all([
            self.DATABRICKS_WORKSPACE_URL,
            self.DATABRICKS_TOKEN,
        ])

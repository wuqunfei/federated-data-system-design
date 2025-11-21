from typing import Dict, Optional
from datahub.ingestion.run.pipeline import Pipeline
from settings import AppSettings


class DataHubRegistrar:
    def __init__(self, settings: Optional[AppSettings] = None) -> None:
        self.settings = settings or AppSettings()
        self.sink_cfg = self._build_sink_config()

    def _build_sink_config(self) -> Dict:
        cfg: Dict = {"server": self.settings.DATAHUB_GMS_URL}
        if self.settings.DATAHUB_TOKEN:
            cfg["token"] = self.settings.DATAHUB_TOKEN
        return cfg

    def build_postgres_source(self) -> Optional[Dict]:
        if not self.settings.is_postgres_configured():
            return None
        cfg: Dict = {
            "host_port": self.settings.POSTGRES_HOST_PORT,
            "username": self.settings.POSTGRES_USERNAME,
            "password": self.settings.POSTGRES_PASSWORD,
            "env": self.settings.POSTGRES_ENV,
        }
        if self.settings.POSTGRES_DATABASE:
            cfg["database"] = self.settings.POSTGRES_DATABASE
        if self.settings.POSTGRES_PLATFORM_INSTANCE:
            cfg["platform_instance"] = self.settings.POSTGRES_PLATFORM_INSTANCE
        return {"type": "postgres", "config": cfg}

    def build_snowflake_source(self) -> Optional[Dict]:
        if not self.settings.is_snowflake_configured():
            return None
        cfg: Dict = {
            "account_id": self.settings.SNOWFLAKE_ACCOUNT_ID,
            "username": self.settings.SNOWFLAKE_USERNAME,
            "password": self.settings.SNOWFLAKE_PASSWORD,
            "role": self.settings.SNOWFLAKE_ROLE,
            "warehouse": self.settings.SNOWFLAKE_WAREHOUSE,
            "env": self.settings.SNOWFLAKE_ENV,
        }
        return {"type": "snowflake", "config": cfg}

    def build_kafka_source(self) -> Optional[Dict]:
        if not self.settings.is_kafka_configured():
            return None
        cfg: Dict = {
            "env": self.settings.KAFKA_ENV,
            "platform_instance": self.settings.KAFKA_PLATFORM_INSTANCE,
            "connection": {
                "bootstrap": self.settings.KAFKA_BOOTSTRAP,
                "schema_registry_url": self.settings.KAFKA_SCHEMA_REGISTRY_URL,
            },
        }
        return {"type": "kafka", "config": cfg}

    def build_databricks_source(self) -> Optional[Dict]:
        if not self.settings.is_databricks_configured():
            return None
        cfg: Dict = {
            "workspace_url": self.settings.DATABRICKS_WORKSPACE_URL,
            "token": self.settings.DATABRICKS_TOKEN,
            "env": self.settings.DATABRICKS_ENV,
        }
        return {"type": "databricks", "config": cfg}

    def run_pipeline(self, source: Dict) -> None:
        recipe: Dict = {
            "source": source,
            "sink": {"type": "datahub-rest", "config": self.sink_cfg},
        }
        pipeline = Pipeline.create(recipe)
        pipeline.run()
        pipeline.raise_from_status()

    def register_all_sources(self) -> None:
        sources = [
            self.build_postgres_source(),
            self.build_snowflake_source(),
            self.build_kafka_source(),
            self.build_databricks_source(),
        ]
        for src in sources:
            if src:
                self.run_pipeline(src)


if __name__ == "__main__":
    DataHubRegistrar().register_all_sources()

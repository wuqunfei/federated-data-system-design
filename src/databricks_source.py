from src.data_sources import DataSource
from src.settings import AppSettings

class DatabricksDataSource(DataSource):
    def __init__(self, settings: AppSettings):
        super().__init__(settings)
        self.type = 'databricks'
        self.name = 'travel_insurance'

    def is_configured(self) -> bool:
        return self.settings.is_databricks_configured()

    def get_connection_string(self) -> str:
        if not self.is_configured():
            return ""
        # Databricks connection string format for DuckDB databricks_scanner extension
        return f"databricks://token:{self.settings.DATABRICKS_TOKEN}@{self.settings.DATABRICKS_WORKSPACE_URL}"

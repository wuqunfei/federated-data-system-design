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

    def get_connection_setup_commands(self) -> list[str]:
        """Returns the commands needed to set up the Databricks connection"""
        if not self.is_configured():
            return []
        conn_string = self.get_connection_string()
        return [f"ATTACH '{conn_string}' AS {self.name} (TYPE databricks, READ_ONLY);"]

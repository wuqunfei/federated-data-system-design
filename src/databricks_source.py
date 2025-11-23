from src.data_sources import DataSource
from src.settings import AppSettings

class DatabricksDataSource(DataSource):
    def __init__(self, settings: AppSettings):
        super().__init__(settings)
        self.type = 'databricks'
        self.name = 'travel_insurance'

    def is_configured(self) -> bool:
        return self.settings.is_databricks_configured()

    def get_spark_read_options(self) -> dict:
        if not self.is_configured():
            return {}
        
        workspace_url = self.settings.DATABRICKS_WORKSPACE_URL.replace("https://", "").replace("http://", "")
        
        # Using JDBC for Databricks SQL
        return {
            "format": "jdbc",
            "url": f"jdbc:databricks://{workspace_url}:443/default;transportMode=http;ssl=1;httpPath=/sql/1.0/warehouses/{self.settings.DATABRICKS_WAREHOUSE_ID};AuthMech=3;UID=token;PWD={self.settings.DATABRICKS_TOKEN};ConnCatalog={self.settings.DATABRICKS_CATALOG};ConnSchema={self.settings.DATABRICKS_SCHEMA}",
            "driver": "com.databricks.client.jdbc.Driver"
        }

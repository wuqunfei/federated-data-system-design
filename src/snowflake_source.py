from src.data_sources import DataSource
from src.settings import AppSettings

class SnowflakeDataSource(DataSource):
    def __init__(self, settings: AppSettings):
        super().__init__(settings)
        self.type = 'snowflake'
        self.name = 'house_insurance'

    def is_configured(self) -> bool:
        return self.settings.is_snowflake_configured()

    def get_connection_string(self) -> str:
        if not self.is_configured():
            return ""
        # Snowflake connection string format for DuckDB snowflake_scanner extension
        return f"snowflake://{self.settings.SNOWFLAKE_USERNAME}:{self.settings.SNOWFLAKE_PASSWORD}@{self.settings.SNOWFLAKE_ACCOUNT_ID}/{self.settings.SNOWFLAKE_WAREHOUSE}"

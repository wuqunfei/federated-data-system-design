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
        # Return empty string, as Snowflake will be connected using secret approach
        return ""

    def get_connection_setup_commands(self) -> list[str]:
        """Returns the commands needed to set up the Snowflake connection using secrets"""
        if not self.is_configured():
            return []
        return [
            f"CREATE SECRET my_snowflake (TYPE snowflake, ACCOUNT '{self.settings.SNOWFLAKE_ACCOUNT_ID}', USER '{self.settings.SNOWFLAKE_USERNAME}', PASSWORD '{self.settings.SNOWFLAKE_PASSWORD}', DATABASE '{self.settings.SNOWFLAKE_DATABASE}', WAREHOUSE  '{self.settings.SNOWFLAKE_WAREHOUSE}', SCHEMA '{self.settings.SNOWFLAKE_SCHEMA}'');",
            f"ATTACH '' AS {self.name} (TYPE snowflake, SECRET my_snowflake, READ_ONLY);"
        ]

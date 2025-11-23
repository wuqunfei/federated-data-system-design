from src.data_sources import DataSource
from src.settings import AppSettings


class SnowflakeDataSource(DataSource):
    def __init__(self, settings: AppSettings):
        super().__init__(settings)
        self.type = 'snowflake'
        self.name = 'house_insurance'

    def is_configured(self) -> bool:
        return self.settings.is_snowflake_configured()

    def get_spark_read_options(self) -> dict:
        if not self.is_configured():
            return {}
        options = {
            "format": "net.snowflake.spark.snowflake",
            "sfUrl": f"{self.settings.SNOWFLAKE_ACCOUNT_ID}.snowflakecomputing.com",
            "sfUser": self.settings.SNOWFLAKE_USERNAME,
            "sfPassword": self.settings.SNOWFLAKE_PASSWORD,
            "sfDatabase": self.settings.SNOWFLAKE_DATABASE,
            "sfSchema": self.settings.SNOWFLAKE_SCHEMA,
            "sfWarehouse": self.settings.SNOWFLAKE_WAREHOUSE,
            "sfRole": self.settings.SNOWFLAKE_ROLE
        }
        # Remove None values to prevent NPE in connector
        return {k: v for k, v in options.items() if v is not None}

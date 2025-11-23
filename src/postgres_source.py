from src.data_sources import DataSource
from src.settings import AppSettings

class PostgresDataSource(DataSource):
    def __init__(self, settings: AppSettings):
        super().__init__(settings)
        self.type = 'postgres'
        self.name = 'car_insurance'

    def is_configured(self) -> bool:
        return self.settings.is_postgres_configured()

    def get_spark_read_options(self) -> dict:
        if not self.is_configured():
            return {}
        return {
            "format": "jdbc",
            "url": f"jdbc:postgresql://{self.settings.POSTGRES_HOST_PORT}/{self.settings.POSTGRES_DATABASE}?currentSchema={self.settings.POSTGRES_SCHEMA}",
            "user": self.settings.POSTGRES_USERNAME,
            "password": self.settings.POSTGRES_PASSWORD,
            "driver": "org.postgresql.Driver"
        }

    def test_connection(self, spark) -> bool:
        try:
            options = self.get_spark_read_options()
            read_options = options.copy()
            # Use dbtable with a subquery for robust connectivity check
            read_options['dbtable'] = "(SELECT 1) as t"
            fmt = read_options.pop('format', None)
            reader = spark.read.options(**read_options)
            if fmt:
                reader = reader.format(fmt)
            reader.load().collect()
            return True
        except Exception as e:
            import sys
            print(f"Connection test failed for {self.name}: {e}", file=sys.stderr)
            return False

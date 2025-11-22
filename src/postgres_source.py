from src.data_sources import DataSource
from src.settings import AppSettings

class PostgresDataSource(DataSource):
    def __init__(self, settings: AppSettings):
        super().__init__(settings)
        self.type = 'postgres'
        self.name = 'car_insurance'

    def is_configured(self) -> bool:
        return self.settings.is_postgres_configured()

    def get_connection_string(self) -> str:
        if not self.is_configured():
            return ""
        return f"postgres://{self.settings.POSTGRES_USERNAME}:{self.settings.POSTGRES_PASSWORD}@{self.settings.POSTGRES_HOST_PORT}/{self.settings.POSTGRES_DATABASE}"

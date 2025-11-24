from src.data_sources import DataSource
from src.settings import AppSettings

class MySQLDataSource(DataSource):
    def __init__(self, settings: AppSettings):
        super().__init__(settings)
        self.type = 'mysql'
        self.name = 'travel_insurance'

    def is_configured(self) -> bool:
        return self.settings.is_mysql_configured()

    def get_connection_string(self) -> str:
        return f"host={self.settings.MYSQL_HOST} user={self.settings.MYSQL_USERNAME} port={self.settings.MYSQL_PORT} database={self.settings.MYSQL_DATABASE}"

    def get_connection_setup_commands(self) -> list[str]:
        """Returns the commands needed to set up the MySQL connection using DuckDB MySQL extension"""
        if not self.is_configured():
            return []
        
        conn_string = self.get_connection_string()
        
        # Attach MySQL database
        return [f"ATTACH '{conn_string}' AS {self.name} (TYPE mysql);"]
from typing import Dict


class DataSource:
    def __init__(self, settings):
        self.settings = settings
        self.type = ""
        self.name = ""

    def is_configured(self) -> bool:
        return False

    def get_spark_read_options(self) -> Dict:
        return {}

    def test_connection(self, spark) -> bool:
        return False


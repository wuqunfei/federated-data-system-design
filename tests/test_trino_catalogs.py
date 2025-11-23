import unittest
from src.settings import AppSettings
from src.trino_client import TrinoClient
from src.trino_catalogs import CatalogPropertiesBuilder


class TestTrinoCatalogs(unittest.TestCase):
    def setUp(self):
        self.settings = AppSettings()
        if not self.settings.is_trino_configured():
            self.skipTest("Trino not configured")
        self.client = TrinoClient(self.settings)
        self.builder = CatalogPropertiesBuilder(self.settings)

    def _exists(self, name: str) -> bool:
        row = self.client.query_one("SELECT catalog_name FROM system.metadata.catalogs WHERE catalog_name = ?", (name,))
        return bool(row)

    def _drop(self, name: str) -> None:
        try:
            self.client.execute(f"DROP CATALOG IF EXISTS {name}")
        except Exception as ex:
            print(f"Error dropping catalog {name}: {ex}")

    def test_postgres_catalog_create_check_drop(self):
        name = "ut_pg_catalog"
        self._drop(name)
        props = self.builder.postgres_properties()
        sql = self.builder.create_catalog_sql(name, props, "postgresql")
        try:
            self.client.execute(sql)
        except Exception as e:
            self._drop(name)
            print(f"Error creating catalog {name}: {e}")
        self.assertTrue(self._exists(name))

    def test_snowflake_catalog_create_check_drop(self):
        name = "ut_sf_catalog"
        self._drop(name)
        props = self.builder.snowflake_properties()
        sql = self.builder.create_catalog_sql(name, props, "snowflake")
        try:
            self.client.execute(sql)
        except Exception as e:
            self._drop(name)
            print(f"Error creating catalog {name}: {e}")
        self.assertTrue(self._exists(name))

    def test_databricks_catalog_create_check_drop(self):
        name = "ut_db_catalog"
        self._drop(name)
        props = self.builder.databricks_iceberg_properties()
        sql = self.builder.create_catalog_sql(name, props, "iceberg")
        try:
            self.client.execute(sql)
        except Exception as e:
            self._drop(name)
            print(f"Error creating catalog {name}: {e}")
        self.assertTrue(self._exists(name))


if __name__ == "__main__":
    unittest.main()

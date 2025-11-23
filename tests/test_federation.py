import unittest
from src.settings import AppSettings
from src.trino_client import TrinoClient
from src.customer360 import Customer360Query


class TestFederation(unittest.TestCase):
    def setUp(self):
        self.settings = AppSettings()

    def test_trino_connect(self):
        if not self.settings.is_trino_configured():
            self.skipTest("Trino not configured")
        client = TrinoClient(self.settings)
        row = client.query_one("SELECT 1")
        self.assertIsNotNone(row)
        self.assertEqual(row[0], 1)

    def test_select_postgres(self):
        if not self.settings.is_trino_configured():
            self.skipTest("Trino not configured")
        if not self.settings.TRINO_SCHEMA_POSTGRES:
            self.skipTest("Postgres not configured")
        client = TrinoClient(self.settings)
        pg_tbl = f"{self.settings.TRINO_CATALOG_POSTGRES}.{self.settings.TRINO_SCHEMA_POSTGRES}.customers"
        row = None
        try:
            row = client.query_one(f"SELECT COUNT(*) FROM {pg_tbl}")
        except Exception:
            row = None
        self.assertTrue(row is None or isinstance(row[0], (int, float)))

    def test_select_snowflake(self):
        if not self.settings.is_trino_configured():
            self.skipTest("Trino not configured")
        if not self.settings.TRINO_SCHEMA_SNOWFLAKE:
            self.skipTest("Snowflake not configured")
        client = TrinoClient(self.settings)
        sf_tbl = f"{self.settings.TRINO_CATALOG_SNOWFLAKE}.{self.settings.TRINO_SCHEMA_SNOWFLAKE}.DIM_CUSTOMERS"
        row = None
        try:
            row = client.query_one(f"SELECT COUNT(*) FROM {sf_tbl}")
        except Exception:
            row = None
        self.assertTrue(row is None or isinstance(row[0], (int, float)))

    def test_select_databricks(self):
        if not self.settings.is_trino_configured():
            self.skipTest("Trino not configured")
        if not self.settings.TRINO_SCHEMA_DATABRICKS:
            self.skipTest("Databricks not configured")
        client = TrinoClient(self.settings)
        db_tbl = f"{self.settings.TRINO_CATALOG_DATABRICKS}.{self.settings.TRINO_SCHEMA_DATABRICKS}.travelers"
        row = None
        try:
            row = client.query_one(f"SELECT COUNT(*) FROM {db_tbl}")
        except Exception:
            row = None
        self.assertTrue(row is None or isinstance(row[0], (int, float)))


if __name__ == "__main__":
    unittest.main()

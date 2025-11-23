import unittest
from src.settings import AppSettings
from src.customer360 import Customer360Query
from src.trino_client import TrinoClient


class TestCustomer360(unittest.TestCase):
    def setUp(self):
        self.settings = AppSettings()

    def test_query_unified_real_env_customer_101(self):
        if not self.settings.is_trino_configured():
            self.skipTest("Trino not configured")
        client = TrinoClient(self.settings)
        q = Customer360Query(self.settings, client)
        cols, rows = q.query_unified(101)
        self.assertIsInstance(cols, list)
        self.assertIsInstance(rows, list)


if __name__ == "__main__":
    unittest.main()


import unittest
from unittest.mock import MagicMock, patch
import pandas as pd
import duckdb
import os
from src.customer_360_view import Customer360View
from src.settings import AppSettings
from src.postgres_source import PostgresDataSource
from src.snowflake_source import SnowflakeDataSource


class TestCustomer360View(unittest.TestCase):

    def setUp(self):
        self.settings = AppSettings(env_file=".env")

    def test_create_view_no_data_sources(self):
        """Test that create_view returns an empty DataFrame when no data sources are configured."""
        customer_360_view = Customer360View(self.settings)
        df = customer_360_view.create_view()
        self.assertTrue(df.empty)





if __name__ == '__main__':
    unittest.main()

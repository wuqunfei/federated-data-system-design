
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

    @patch('src.customer_360_view.Customer360View._load_extensions')
    @patch('src.customer_360_view.duckdb.connect')
    def test_create_view_with_mock_data_sources(self, mock_duckdb_connect, mock_load_extensions):
        """Test that create_view returns a DataFrame with federated data when data sources are configured."""
        # Mock the duckdb connection and execute methods
        mock_con = MagicMock()
        mock_duckdb_connect.return_value = mock_con
        mock_con.execute.return_value.fetchdf.return_value = pd.DataFrame({'col1': [1, 2], 'col2': [3, 4]})

        customer_360_view = Customer360View(self.settings)

        # Mock data sources
        mock_postgres_source = MagicMock()
        mock_postgres_source.is_configured.return_value = True
        mock_postgres_source.get_connection_string.return_value = "postgresql://user:pass@host:port/db"
        mock_postgres_source.name = "postgres"
        mock_postgres_source.type = "postgres"

        mock_snowflake_source = MagicMock()
        mock_snowflake_source.is_configured.return_value = True
        mock_snowflake_source.get_connection_string.return_value = "snowflake://user:pass@account/db/schema?warehouse=wh"
        mock_snowflake_source.name = "snowflake"
        mock_snowflake_source.type = "snowflake"

        # Add mock data sources to the view
        customer_360_view.add_data_source(mock_postgres_source)
        customer_360_view.add_data_source(mock_snowflake_source)

        # Call the method to be tested
        df = customer_360_view.create_view()

        # Assertions
        self.assertFalse(df.empty)
        self.assertEqual(len(df), 2)
        self.assertIn('col1', df.columns)



if __name__ == '__main__':
    unittest.main()

import unittest
import os
import sys
from pathlib import Path

# Add src to path
sys.path.append(str(Path(__file__).parent.parent))

from src.settings import AppSettings
from src.customer_360_view import Customer360View

class TestCustomer360Real(unittest.TestCase):
    def setUp(self):
        print("\nSetting up TestCustomer360Real...")
        self.settings = AppSettings()
        try:
            self.view = Customer360View(self.settings)
        except Exception as e:
            self.skipTest(f"Setup failed: {e}")

    def test_1_postgres_connection(self):
        print("\nTesting Postgres connection...")
        targets = [s for s in self.view.data_sources if getattr(s, 'type', None) == 'postgres']
        if not targets:
            self.skipTest("Postgres not configured")
        for source in targets:
            ok = source.test_connection(self.view.spark)
            self.assertTrue(ok, f"Failed to connect to {source.name}")
            print(f"Successfully connected to {source.name}")

    def test_1_snowflake_connection(self):
        print("\nTesting Snowflake connection...")
        targets = [s for s in self.view.data_sources if getattr(s, 'type', None) == 'snowflake']
        if not targets:
            self.skipTest("Snowflake not configured")
        for source in targets:
            ok = source.test_connection(self.view.spark)
            self.assertTrue(ok, f"Failed to connect to {source.name}")
            print(f"Successfully connected to {source.name}")

    def test_1_databricks_connection(self):
        print("\nTesting Databricks connection...")
        targets = [s for s in self.view.data_sources if getattr(s, 'type', None) == 'databricks']
        if not targets:
            self.skipTest("Databricks not configured")
        for source in targets:
            ok = source.test_connection(self.view.spark)
            self.assertTrue(ok, f"Failed to connect to {source.name}")
            print(f"Successfully connected to {source.name}")

    def test_2_create_view(self):
        """Test creating the view and running a query"""
        print("\nTesting create_view...")
        # Use a dummy ID or a known ID if available. 
        # Since we don't know real IDs, we'll use a placeholder.
        # The query should still execute even if it returns empty results.
        customer_id = "C12345" 
        
        try:
            df = self.view.create_view(customer_id=customer_id)
            print(f"Query executed successfully. Rows returned: {len(df)}")
            
            # Basic validation
            self.assertIsNotNone(df)
            # We expect columns from the query to be present if the dataframe is not empty
            # If empty, columns might still be defined in schema
            if not df.empty:
                self.assertIn('master_customer_id', df.columns)
                
        except Exception as e:
            self.fail(f"create_view failed with exception: {e}")

if __name__ == '__main__':
    unittest.main()

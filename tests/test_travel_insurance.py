import unittest
import datetime
import pandas as pd

from generator.travel_insurance import DatabricksLoader, TravelDataGenerator
from src.settings import AppSettings


class FakeConn:
    def execution_options(self, autocommit=True):
        return self

    def execute(self, stmt, batch=None):
        self.last_batch = batch
        return None


class TestTravelInsuranceBulkInsert(unittest.TestCase):
    def test_bulk_insert_datetime_handling(self):
        tz_aware_dt = datetime.datetime(2021, 1, 1, 12, 0, 0, tzinfo=datetime.timezone.utc)
        tz_aware_ts = pd.Timestamp('2021-01-02T08:30:00+00:00')
        date_only = datetime.date(2021, 1, 3)

        df = pd.DataFrame([
            {
                'created_at': tz_aware_dt,
                'updated_at': tz_aware_ts,
                'incident_date': date_only,
                'other': 1,
            }
        ])

        loader = DatabricksLoader(AppSettings(), workspace_id="", schema="test")
        conn = FakeConn()

        # Should not raise
        loader._bulk_insert(conn, 'dummy_table', df, chunk_size=1)

        # Validate conversion result from captured batch
        self.assertTrue(hasattr(conn, 'last_batch'))
        self.assertEqual(len(conn.last_batch), 1)
        rec = conn.last_batch[0]
        self.assertIsNone(rec['created_at'].tzinfo)
        self.assertIsNone(rec['updated_at'].tzinfo)
        self.assertIsInstance(rec['incident_date'], str)


if __name__ == '__main__':
    unittest.main()

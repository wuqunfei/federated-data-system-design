import logging

import duckdb
import pandas as pd

from src.data_sources import DataSource
from src.postgres_source import PostgresDataSource
from src.settings import AppSettings

logger = logging.getLogger(__name__)

class Customer360View:
    def __init__(self, settings: AppSettings):
        self.settings = settings
        self.con = duckdb.connect()
        self.data_sources: list[DataSource] = [PostgresDataSource(self.settings)]

    def add_data_source(self, data_source: DataSource):
        if data_source.is_configured():
            self.data_sources.append(data_source)

    def _load_extensions(self):
        try:
            self.con.execute("INSTALL httpfs;")
            self.con.execute("LOAD httpfs;")

            if any(ds.type == 'postgres' for ds in self.data_sources):
                self.con.execute("INSTALL postgres;")
                self.con.execute("LOAD postgres;")
            if any(ds.type == 'snowflake' for ds in self.data_sources):
                self.con.execute("INSTALL snowflake;")
                self.con.execute("LOAD snowflake;")
            if any(ds.type == 'databricks' for ds in self.data_sources):
                self.con.execute("INSTALL delta;")
                self.con.execute("LOAD delta;")

            logger.info("Successfully loaded extensions for federated queries")
        except Exception as e:
            logger.warning(f"Could not load some extensions: {e}")

    def create_view(self) -> pd.DataFrame:
        self._load_extensions()
        
        if not self.data_sources:
            logger.info("No real data sources configured, returning empty DataFrame")
            return pd.DataFrame()

        query = self._build_federated_query()
        print(query)
        return self._execute_query(query)

    def _build_federated_query(self) -> str:
        attach_sqls = []
        for data_source in self.data_sources:
            attach_sqls.append(f"ATTACH '{data_source.get_connection_string()}' as postgresql (TYPE {data_source.type}, READ_ONLY);")

        attach_query = "\n".join(attach_sqls)
        
        return f"""
        {attach_query}

        -- Customer 360 View Query for Insurance Business
        -- Combines data from House Insurance, Travel Insurance, and Vehicle Insurance

        select * from postgres.public.customers as c;
        """


    def _execute_query(self, query: str) -> pd.DataFrame:
        try:
            return self.con.execute(query).fetchdf()
        except Exception as e:
            logger.error(f"Error executing query: {e}")
            return pd.DataFrame()

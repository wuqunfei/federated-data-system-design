from __future__ import annotations
from pathlib import Path
from typing import Optional
from src.settings import AppSettings
from src.trino_catalogs import CatalogPropertiesBuilder
from src.trino_client import TrinoClient


class FederationSetup:
    def __init__(self, settings: AppSettings) -> None:
        self.s = settings
        self.builder = CatalogPropertiesBuilder(settings)

    def write_properties_files(self, output_dir: str) -> dict[str, Path]:
        out = Path(output_dir)
        out.mkdir(parents=True, exist_ok=True)
        files: dict[str, Path] = {}
        pg_props = self.builder.postgres_properties()
        sf_props = self.builder.snowflake_properties()
        db_props = self.builder.databricks_iceberg_properties()
        pg_name = self.s.TRINO_CATALOG_POSTGRES or "car_insurance"
        sf_name = self.s.TRINO_CATALOG_SNOWFLAKE or "house_insurance"
        db_name = self.s.TRINO_CATALOG_DATABRICKS or "travel_insurance"
        files[pg_name] = out / f"{pg_name}.properties"
        files[sf_name] = out / f"{sf_name}.properties"
        files[db_name] = out / f"{db_name}.properties"
        (out / f"{pg_name}.properties").write_text(self.builder.to_properties_text(pg_props), encoding="utf-8")
        (out / f"{sf_name}.properties").write_text(self.builder.to_properties_text(sf_props), encoding="utf-8")
        (out / f"{db_name}.properties").write_text(self.builder.to_properties_text(db_props), encoding="utf-8")
        return files

    def create_catalogs_via_sql(self, client: TrinoClient) -> None:
        pg_props = self.builder.postgres_properties()
        sf_props = self.builder.snowflake_properties()
        db_props = self.builder.databricks_iceberg_properties()
        pg_name = self.s.TRINO_CATALOG_POSTGRES or "car_insurance"
        sf_name = self.s.TRINO_CATALOG_SNOWFLAKE or "house_insurance"
        db_name = self.s.TRINO_CATALOG_DATABRICKS or "travel_insurance"
        pg_sql = self.builder.create_catalog_sql(pg_name, pg_props, "postgresql")
        sf_sql = self.builder.create_catalog_sql(sf_name, sf_props, "snowflake")
        db_sql = self.builder.create_catalog_sql(db_name, db_props, "iceberg")
        client.execute(pg_sql)
        client.execute(sf_sql)
        client.execute(db_sql)


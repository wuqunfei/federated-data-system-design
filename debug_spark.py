import sys
from pathlib import Path
sys.path.append(str(Path(__file__).parent))

from src.settings import AppSettings
from src.customer_360_view import Customer360View
from src.postgres_source import PostgresDataSource

def debug():
    print("Initializing settings...")
    settings = AppSettings()
    
    print("Initializing Customer360View...")
    view = Customer360View(settings)
    spark = view.spark
    
    print(f"Spark Version: {spark.version}")
    try:
        scala_version = spark.sparkContext._jvm.scala.util.Properties.versionString()
        print(f"Scala Version: {scala_version}")
    except Exception as e:
        print(f"Could not get Scala version: {e}")

    print("\nTesting Postgres Connection...")
    if settings.is_postgres_configured():
        pg_source = PostgresDataSource(settings)
        try:
            success = pg_source.test_connection(spark)
            print(f"Postgres Result: {success}")
        except Exception as e:
            print(f"Postgres Exception: {e}")

    print("\nTesting Snowflake Connection...")
    if settings.is_snowflake_configured():
        print(f"Snowflake Account ID: '{settings.SNOWFLAKE_ACCOUNT_ID}'")
        from src.snowflake_source import SnowflakeDataSource
        sf_source = SnowflakeDataSource(settings)
        opts = sf_source.get_spark_read_options()
        # Mask secrets
        safe_opts = {k: (v if k not in ['sfPassword', 'sfToken'] else '***') for k, v in opts.items()}
        print(f"Snowflake Options: {safe_opts}")
        try:
            success = sf_source.test_connection(spark)
            print(f"Snowflake Result: {success}")
        except Exception as e:
            print(f"Snowflake Exception: {e}")

    print("\nTesting Databricks Connection...")
    if settings.is_databricks_configured():
        from src.databricks_source import DatabricksDataSource
        db_source = DatabricksDataSource(settings)
        opts = db_source.get_spark_read_options()
        # Mask secrets
        safe_opts = {k: (v if 'PWD' not in k and 'Token' not in k else '***') for k, v in opts.items()}
        # Databricks URL contains PWD, so mask it carefully or just print the URL start
        if 'url' in safe_opts:
            url = safe_opts['url']
            # Simple masking for debug
            safe_opts['url'] = url.split('PWD=')[0] + 'PWD=***' if 'PWD=' in url else url
            
        print(f"Databricks Options: {safe_opts}")
        try:
            success = db_source.test_connection(spark)
            print(f"Databricks Result: {success}")
        except Exception as e:
            print(f"Databricks Exception: {e}")

if __name__ == "__main__":
    debug()

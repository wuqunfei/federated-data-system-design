import logging
from typing import Optional

import pandas as pd
from pyspark.sql import SparkSession
import pyspark
import os
try:
    from delta import configure_spark_with_delta_pip
except Exception:
    configure_spark_with_delta_pip = None

from src.data_sources import DataSource
from src.postgres_source import PostgresDataSource
from src.settings import AppSettings

logger = logging.getLogger(__name__)

class Customer360View:
    def __init__(self, settings: AppSettings):
        self.settings = settings
        self.data_sources: list[DataSource] = []

        postgres_source = PostgresDataSource(self.settings)
        if postgres_source.is_configured():
            self.data_sources.append(postgres_source)

        try:
            from src.snowflake_source import SnowflakeDataSource
            snowflake_source = SnowflakeDataSource(self.settings)
            if snowflake_source.is_configured():
                self.data_sources.append(snowflake_source)
        except Exception:
            pass

        try:
            from src.databricks_source import DatabricksDataSource
            databricks_source = DatabricksDataSource(self.settings)
            if databricks_source.is_configured():
                self.data_sources.append(databricks_source)
        except Exception:
            pass
        self.spark = self._initialize_spark()

    def _initialize_spark(self) -> SparkSession:
        if self.settings.JAVA_HOME:
            os.environ["JAVA_HOME"] = self.settings.JAVA_HOME
        if os.getenv("SPARK_MIN_INIT", "1") == "1":
            builder = SparkSession.builder.appName("FederatedCustomer360")
            return builder.getOrCreate()
        else:
            builder = SparkSession.builder \
                .appName("FederatedCustomer360") \
                .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
                .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
            if configure_spark_with_delta_pip:
                return configure_spark_with_delta_pip(builder).getOrCreate()
            return builder.getOrCreate()

    def add_data_source(self, data_source: DataSource):
        if data_source.is_configured():
            self.data_sources.append(data_source)

    def create_view(self, customer_id: str = None) -> pd.DataFrame:
        self.test_connection()
        self.mapping_tables()
        if not self.data_sources:
            logger.info("No real data sources configured, returning empty DataFrame")
            return pd.DataFrame()
        return self.query_unifed_view(customer_id)

    def test_connection(self) -> None:
        for source in self.data_sources:
            logger.info(f"Testing connection to {source.name}...")
            if not source.test_connection(self.spark):
                logger.error(f"Failed to connect to {source.name}. Skipping.")

    def mapping_tables(self) -> None:
        self._load_data_sources()

    def query_unifed_view(self, customer_id: str | None = None) -> pd.DataFrame:
        query = self._build_federated_query(customer_id)
        print(query)
        return self._execute_query(query)

    def _load_data_sources(self):
        for source in self.data_sources:
            options = source.get_spark_read_options()
            if not options:
                continue
            
            # Define tables to load for each source type
            tables = []
            prefix = ""
            
            if source.type == 'postgres': # Car Insurance
                tables = ['customers', 'policies', 'vehicles', 'claims', 'policy_coverages']
                prefix = "car_"
            elif source.type == 'snowflake': # House Insurance
                tables = ['DIM_CUSTOMERS', 'DIM_PROPERTIES', 'FACT_POLICIES', 'FACT_CLAIMS']
                prefix = "house_"
            elif source.type == 'databricks': # Travel Insurance
                tables = ['travelers', 'trips', 'policies', 'claims']
                prefix = "travel_"

            for table in tables:
                try:
                    # For JDBC/Snowflake, we usually specify dbtable
                    read_options = options.copy()
                    if source.type == 'postgres':
                         # Schema is set in JDBC URL
                         read_options['dbtable'] = table
                    elif source.type == 'snowflake':
                         # Schema is set in sfSchema option
                         read_options['dbtable'] = table
                    elif source.type == 'databricks':
                         # Schema/Catalog set in JDBC URL
                         read_options['dbtable'] = table 

                    # Extract format if present
                    fmt = read_options.pop('format', None)
                    reader = self.spark.read.options(**read_options)
                    if fmt:
                        reader = reader.format(fmt)
                    
                    df = reader.load()
                    # Clean up view name (remove DIM_/FACT_ prefixes for cleaner SQL if desired, but let's keep it simple for now)
                    view_name = f"{prefix}{table}"
                    df.createOrReplaceTempView(view_name)
                    logger.info(f"Registered view {view_name} from {source.type}")
                except Exception as e:
                    logger.warning(f"Failed to load table {table} from {source.type}: {e}")

    def _build_federated_query(self, customer_id: str = None) -> str:
        return f"""
        -- Customer 360 View Query for Insurance Business
        -- Combines data from House Insurance (Snowflake), Travel Insurance (Databricks), and Car Insurance (Postgres)

        WITH 
        -- =========================================================
        -- HOUSE INSURANCE (Snowflake)
        -- =========================================================
        house_cust AS (
            SELECT 
                customer_id, first_name, last_name, email, phone_mobile, date_of_birth, 
                marital_status, gender, occupation_industry, education_level, 
                annual_income_bracket, credit_score_tier, insurance_score, 
                has_prior_claims, customer_since_date
            FROM house_DIM_CUSTOMERS
        ),
        house_props AS (
            SELECT 
                property_id, customer_id, address_street, city, state, zip_code, 
                year_built, sq_ft_living, roof_material, heating_system_type
            FROM house_DIM_PROPERTIES
        ),
        house_pols AS (
            SELECT 
                policy_id, policy_number, customer_id, property_id, 
                effective_date, expiration_date, total_annual_premium, policy_status,
                coverage_a_dwelling, coverage_e_liability
            FROM house_FACT_POLICIES
        ),
        house_clms AS (
            SELECT 
                claim_id, policy_id, date_of_loss, cause_of_loss, 
                amount_paid_building, amount_paid_contents, net_payout, claim_status
            FROM house_FACT_CLAIMS
        ),

        -- =========================================================
        -- CAR INSURANCE (Postgres)
        -- =========================================================
        car_cust AS (
            SELECT 
                customer_id, first_name, last_name, email, phone_number, 
                address_street, address_city, address_state, address_zip, 
                gender, marital_status, education_level, employment_status, 
                annual_income, credit_tier, customer_since
            FROM car_customers
        ),
        car_pols AS (
            SELECT 
                policy_id, customer_id, policy_number, policy_type, 
                start_date, end_date, premium_amount, is_active
            FROM car_policies
        ),
        car_vehs AS (
            SELECT 
                vehicle_id, policy_id, vin, make, model, year, plate_number
            FROM car_vehicles
        ),
        car_clms AS (
            SELECT 
                claim_id, policy_id, claim_date, description, claim_amount, status
            FROM car_claims
        ),

        -- =========================================================
        -- TRAVEL INSURANCE (Databricks)
        -- =========================================================
        travel_cust AS (
            SELECT 
                traveler_id as customer_id, first_name, last_name, email_primary as email, 
                phone_mobile, date_of_birth, gender, passport_number, 
                home_address_city, home_address_country, credit_risk_score
            FROM travel_travelers
        ),
        travel_trips AS (
            SELECT 
                trip_id, traveler_id, primary_destination_city, primary_destination_iso, 
                travel_start_date, travel_end_date, trip_duration_days, total_trip_cost
            FROM travel_trips
        ),
        travel_pols AS (
            SELECT 
                policy_id, traveler_id, trip_id, policy_number, plan_name, 
                total_premium_paid, policy_status
            FROM travel_policies
        ),
        travel_clms AS (
            SELECT 
                claim_id, policy_id, traveler_id, incident_date, loss_category, 
                claimed_amount, approved_amount, claim_status
            FROM travel_claims
        )

        -- =========================================================
        -- UNIFIED VIEW
        -- =========================================================
        SELECT DISTINCT
            -- Master ID
            COALESCE(hc.customer_id, cc.customer_id, tc.customer_id) as master_customer_id,

            -- Identity (Prioritize House -> Car -> Travel)
            COALESCE(hc.first_name, cc.first_name, tc.first_name) as first_name,
            COALESCE(hc.last_name, cc.last_name, tc.last_name) as last_name,
            COALESCE(hc.email, cc.email, tc.email) as email,
            COALESCE(hc.phone_mobile, cc.phone_number, tc.phone_mobile) as phone,
            COALESCE(hc.date_of_birth, tc.date_of_birth) as dob,

            -- House Insurance Data
            hp.address_street as house_address,
            hp.city as house_city,
            hp.state as house_state,
            hpol.policy_number as house_policy_num,
            hpol.total_annual_premium as house_premium,
            hpol.policy_status as house_policy_status,
            hcl.claim_id as house_claim_id,
            hcl.net_payout as house_claim_payout,

            -- Car Insurance Data
            cc.address_street as car_address,
            cpol.policy_number as car_policy_num,
            cpol.premium_amount as car_premium,
            cveh.make as car_make,
            cveh.model as car_model,
            cveh.year as car_year,
            ccl.claim_id as car_claim_id,
            ccl.claim_amount as car_claim_amount,

            -- Travel Insurance Data
            tc.passport_number as passport,
            tpol.policy_number as travel_policy_num,
            tpol.plan_name as travel_plan,
            tt.primary_destination_city as trip_dest_city,
            tt.travel_start_date as trip_start,
            tcl.claim_id as travel_claim_id,
            tcl.approved_amount as travel_claim_payout

        FROM house_cust hc
        -- House Joins
        LEFT JOIN house_props hp ON hc.customer_id = hp.customer_id
        LEFT JOIN house_pols hpol ON hc.customer_id = hpol.customer_id
        LEFT JOIN house_clms hcl ON hpol.policy_id = hcl.policy_id

        -- Full Outer Join to Car
        FULL OUTER JOIN car_cust cc ON hc.customer_id = cc.customer_id
        LEFT JOIN car_pols cpol ON cc.customer_id = cpol.customer_id
        LEFT JOIN car_vehs cveh ON cpol.policy_id = cveh.policy_id
        LEFT JOIN car_clms ccl ON cpol.policy_id = ccl.policy_id

        -- Full Outer Join to Travel
        FULL OUTER JOIN travel_cust tc ON COALESCE(hc.customer_id, cc.customer_id) = tc.customer_id
        LEFT JOIN travel_trips tt ON tc.customer_id = tt.traveler_id
        LEFT JOIN travel_pols tpol ON tc.customer_id = tpol.traveler_id
        LEFT JOIN travel_clms tcl ON tpol.policy_id = tcl.policy_id

        {f"WHERE COALESCE(hc.customer_id, cc.customer_id, tc.customer_id) = '{customer_id}'" if customer_id else ""}
        ORDER BY master_customer_id
        ;
        """

    def _execute_query(self, query: str) -> pd.DataFrame:
        try:
            return self.spark.sql(query).toPandas()
        except Exception as e:
            logger.error(f"Error executing query: {e}")
            return pd.DataFrame()

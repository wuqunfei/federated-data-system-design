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
        self.data_sources: list[DataSource] = []

        # Add all configured data sources by default
        postgres_source = PostgresDataSource(self.settings)
        if postgres_source.is_configured():
            self.data_sources.append(postgres_source)

        # Add Snowflake source for house insurance
        try:
            from src.snowflake_source import SnowflakeDataSource
            snowflake_source = SnowflakeDataSource(self.settings)
            if snowflake_source.is_configured():
                self.data_sources.append(snowflake_source)
        except ImportError:
            pass  # Snowflake source not available

        # Add Databricks source for travel insurance
        try:
            from src.databricks_source import DatabricksDataSource
            databricks_source = DatabricksDataSource(self.settings)
            if databricks_source.is_configured():
                self.data_sources.append(databricks_source)
        except ImportError:
            pass  # Databricks source not available

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
        setup_commands = []
        for data_source in self.data_sources:
            setup_commands.extend(data_source.get_connection_setup_commands())

        setup_query = "\n".join(setup_commands)

        # Define schema names based on data source names
        house_schema = "house_insurance.public"
        car_schema = "car_insurance.public"
        travel_schema = "travel_insurance.public"

        return f"""
        {setup_query}

        -- Customer 360 View Query for Insurance Business
        -- Combines data from House Insurance, Travel Insurance, and Car Insurance

        -- Get all customer data with their policies, claims, and related information
        WITH house_customers AS (
            SELECT
                customer_id,
                first_name,
                last_name,
                email,
                phone_mobile,
                date_of_birth,
                marital_status,
                gender,
                occupation_industry,
                education_level,
                annual_income_bracket,
                credit_score_tier,
                insurance_score,
                has_prior_claims,
                customer_since_date
            FROM {house_schema}.dim_customers
        ),

        house_policies AS (
            SELECT
                policy_id,
                policy_number,
                customer_id,
                effective_date,
                expiration_date,
                coverage_a_dwelling,
                coverage_b_other_structures,
                coverage_c_personal_property,
                coverage_d_loss_of_use,
                coverage_e_liability,
                coverage_f_med_pay,
                deductible_all_peril,
                total_annual_premium,
                policy_status
            FROM {house_schema}.fact_policies
        ),

        house_claims AS (
            SELECT
                policy_id,
                claim_id,
                date_of_loss,
                cause_of_loss,
                amount_paid_building,
                amount_paid_contents,
                net_payout,
                claim_status
            FROM {house_schema}.fact_claims
        ),

        car_customers AS (
            SELECT
                customer_id,
                first_name,
                last_name,
                email,
                phone_number,
                address_street,
                address_city,
                address_state,
                address_zip,
                gender,
                marital_status,
                education_level,
                employment_status,
                annual_income,
                credit_tier,
                customer_since
            FROM {car_schema}.customers
        ),

        car_policies AS (
            SELECT
                policy_id,
                customer_id,
                policy_number,
                policy_type,
                start_date,
                end_date,
                premium_amount,
                is_active
            FROM {car_schema}.policies
        ),

        car_vehicles AS (
            SELECT
                policy_id,
                vehicle_id,
                vin,
                make,
                model,
                year,
                plate_number
            FROM {car_schema}.vehicles
        ),

        car_claims AS (
            SELECT
                policy_id,
                claim_id,
                claim_date,
                claim_amount,
                status
            FROM {car_schema}.claims
        ),

        car_coverages AS (
            SELECT
                policy_id,
                coverage_type,
                coverage_limit,
                deductible
            FROM {car_schema}.policy_coverages
        ),

        travel_customers AS (
            SELECT
                traveler_id as customer_id,
                first_name,
                last_name,
                email_primary as email,
                date_of_birth,
                gender,
                passport_number,
                home_address_city,
                home_address_country,
                credit_risk_score
            FROM {travel_schema}.travelers
        ),

        travel_policies AS (
            SELECT
                policy_id,
                traveler_id as customer_id,
                policy_number,
                plan_name,
                plan_code,
                total_premium_paid,
                net_premium,
                policy_status
            FROM {travel_schema}.policies
        ),

        travel_claims AS (
            SELECT
                claim_id,
                policy_id,
                traveler_id as customer_id,
                incident_date,
                loss_category,
                claimed_amount,
                approved_amount,
                claim_status
            FROM {travel_schema}.claims
        )

        SELECT DISTINCT
            COALESCE(hc.customer_id, cc.customer_id, tc.customer_id) as customer_id,

            -- House Insurance Customer Information
            hc.first_name as house_first_name,
            hc.last_name as house_last_name,
            hc.email as house_email,
            hc.phone_mobile as house_phone,
            hc.date_of_birth as house_dob,
            hc.gender as house_gender,
            hc.marital_status as house_marital_status,
            hc.occupation_industry as house_occupation,
            hc.education_level as house_education,
            hc.annual_income_bracket as house_income_bracket,
            hc.credit_score_tier as house_credit_score_tier,
            hc.insurance_score as house_insurance_score,
            hc.has_prior_claims as house_has_prior_claims,
            hc.customer_since_date as house_customer_since,

            -- House Insurance Policy Information
            hp.policy_number as house_policy_number,
            hp.effective_date as house_policy_start,
            hp.expiration_date as house_policy_end,
            hp.coverage_a_dwelling as house_coverage_dwelling,
            hp.coverage_b_other_structures as house_coverage_other_structures,
            hp.coverage_c_personal_property as house_coverage_personal_property,
            hp.coverage_d_loss_of_use as house_coverage_loss_of_use,
            hp.coverage_e_liability as house_coverage_liability,
            hp.coverage_f_med_pay as house_coverage_med_pay,
            hp.deductible_all_peril as house_deductible,
            hp.total_annual_premium as house_annual_premium,
            hp.policy_status as house_policy_status,

            -- House Insurance Claims Information
            hc_cl.claim_id as house_claim_id,
            hc_cl.date_of_loss as house_date_of_loss,
            hc_cl.cause_of_loss as house_cause_of_loss,
            hc_cl.amount_paid_building as house_claim_building_paid,
            hc_cl.amount_paid_contents as house_claim_contents_paid,
            hc_cl.net_payout as house_claim_net_payout,
            hc_cl.claim_status as house_claim_status,

            -- Car Insurance Customer Information
            cc.first_name as car_first_name,
            cc.last_name as car_last_name,
            cc.email as car_email,
            cc.phone_number as car_phone,
            cc.address_street as car_address_street,
            cc.address_city as car_address_city,
            cc.address_state as car_address_state,
            cc.address_zip as car_address_zip,
            cc.gender as car_gender,
            cc.marital_status as car_marital_status,
            cc.education_level as car_education,
            cc.employment_status as car_employment_status,
            cc.annual_income as car_annual_income,
            cc.credit_tier as car_credit_tier,
            cc.customer_since as car_customer_since,

            -- Car Insurance Policy Information
            cp.policy_number as car_policy_number,
            cp.policy_type as car_policy_type,
            cp.start_date as car_policy_start,
            cp.end_date as car_policy_end,
            cp.premium_amount as car_premium_amount,
            cp.is_active as car_is_active,

            -- Car Insurance Vehicle Information
            cv.vin as car_vin,
            cv.make as car_make,
            cv.model as car_model,
            cv.year as car_year,
            cv.plate_number as car_plate_number,

            -- Car Insurance Claims Information
            cc_cl.claim_id as car_claim_id,
            cc_cl.claim_date as car_claim_date,
            cc_cl.claim_amount as car_claim_amount,
            cc_cl.status as car_claim_status,

            -- Car Insurance Coverage Information
            cco.coverage_type as car_coverage_type,
            cco.coverage_limit as car_coverage_limit,
            cco.deductible as car_deductible,

            -- Travel Insurance Customer Information
            tc.first_name as travel_first_name,
            tc.last_name as travel_last_name,
            tc.email as travel_email,
            tc.date_of_birth as travel_dob,
            tc.gender as travel_gender,
            tc.passport_number as travel_passport_number,
            tc.home_address_city as travel_home_city,
            tc.home_address_country as travel_home_country,
            tc.credit_risk_score as travel_credit_risk_score,

            -- Travel Insurance Policy Information
            tp.policy_number as travel_policy_number,
            tp.plan_name as travel_plan_name,
            tp.plan_code as travel_plan_code,
            tp.total_premium_paid as travel_total_premium_paid,
            tp.net_premium as travel_net_premium,
            tp.policy_status as travel_policy_status,

            -- Travel Insurance Claims Information
            tc_cl.claim_id as travel_claim_id,
            tc_cl.incident_date as travel_incident_date,
            tc_cl.loss_category as travel_loss_category,
            tc_cl.claimed_amount as travel_claimed_amount,
            tc_cl.approved_amount as travel_approved_amount,
            tc_cl.claim_status as travel_claim_status

        FROM
            house_customers hc
        FULL OUTER JOIN house_policies hp ON hc.customer_id = hp.customer_id
        FULL OUTER JOIN house_claims hc_cl ON hp.policy_id = hc_cl.policy_id
        FULL OUTER JOIN car_customers cc ON hc.customer_id = cc.customer_id
        FULL OUTER JOIN car_policies cp ON COALESCE(hc.customer_id, cc.customer_id) = cp.customer_id
        FULL OUTER JOIN car_vehicles cv ON cp.policy_id = cv.policy_id
        FULL OUTER JOIN car_claims cc_cl ON cp.policy_id = cc_cl.policy_id
        FULL OUTER JOIN car_coverages cco ON cp.policy_id = cco.policy_id
        FULL OUTER JOIN travel_customers tc ON COALESCE(hc.customer_id, cc.customer_id) = tc.customer_id
        FULL OUTER JOIN travel_policies tp ON tc.customer_id = tp.customer_id
        FULL OUTER JOIN travel_claims tc_cl ON tp.policy_id = tc_cl.policy_id
        ORDER BY
            COALESCE(hc.customer_id, cc.customer_id, tc.customer_id);
        """


    def _execute_query(self, query: str) -> pd.DataFrame:
        try:
            return self.con.execute(query).fetchdf()
        except Exception as e:
            logger.error(f"Error executing query: {e}")
            return pd.DataFrame()

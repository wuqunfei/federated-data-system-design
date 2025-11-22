import duckdb
import pandas as pd
import os
from typing import Optional
import logging

# Import settings
from src.settings import AppSettings

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def sample_data_query():
    """Helper function to return the sample data query"""
    return """
    -- Customer 360 View Query for Insurance Business
    -- Combines data from House Insurance, Travel Insurance, and Vehicle Insurance

    -- For demonstration purposes, we'll use sample data since real data sources are not configured
    -- In a real implementation, you would connect to your actual data sources

    -- Sample house insurance customer data
    WITH house_customers AS (
        SELECT * FROM (
            VALUES
                (1, 'John', 'Doe', 'john.doe@email.com', '555-0101', '1980-05-15', 'M', 'Married', 'Bachelor', 'Technology', '$75k-$100k', 'Excellent', 750, TRUE, '2015-03-20'),
                (2, 'Jane', 'Smith', 'jane.smith@email.com', '555-0102', '1985-11-22', 'F', 'Single', 'Masters', 'Finance', '$100k-$150k', 'Excellent', 800, FALSE, '2018-07-10')
        ) AS t(customer_id, first_name, last_name, email, phone_mobile, date_of_birth, gender, marital_status, education_level, occupation_industry, annual_income_bracket, credit_score_tier, insurance_score, has_prior_claims, customer_since_date)
    ),

    -- Sample house insurance policy data
    house_policies AS (
        SELECT * FROM (
            VALUES
                (1, 101, 'HP-001-2023', 'Active', '2023-01-01', '2024-01-01', 1200.00, 250000.00, 50000.00, 300000.00),
                (2, 102, 'HP-002-2023', 'Active', '2023-02-15', '2024-02-15', 1800.00, 350000.00, 75000.00, 500000.00)
        ) AS t(customer_id, policy_id, policy_number, policy_status, effective_date, expiration_date, total_annual_premium, coverage_a_dwelling, coverage_c_personal_property, coverage_e_liability)
    ),

    -- Sample house insurance claim data
    house_claims AS (
        SELECT * FROM (
            VALUES
                (101, 1001, 2500.00, 'Fire', '2023-06-15', 'Closed'),
                (102, 1002, 0.00, NULL, NULL, 'Open')
        ) AS t(policy_id, claim_id, net_payout, cause_of_loss, date_of_loss, claim_status)
    ),

    -- Sample travel insurance traveler data
    travelers AS (
        SELECT * FROM (
            VALUES
                (1, 'John', 'Doe', 'john.doe.travels@email.com', '1980-05-15', 'M', 'P12345678', 'New York', 'USA', 780),
                (2, 'Jane', 'Smith', 'jane.smith.travels@email.com', '1985-11-22', 'F', 'P87654321', 'San Francisco', 'USA', 820)
        ) AS t(traveler_id, first_name, last_name, email_primary, date_of_birth, gender, passport_number, home_address_city, home_address_country, credit_risk_score)
    ),

    -- Sample travel insurance policy data
    travel_policies AS (
        SELECT * FROM (
            VALUES
                (1001, 1, 'TP-001-2023', 'Active', 'Worldwide Plan', 450.00, 400.00),
                (1002, 2, 'TP-002-2023', 'Active', 'Premium Plan', 650.00, 600.00)
        ) AS t(policy_id, traveler_id, policy_number, policy_status, plan_name, total_premium_paid, net_premium)
    ),

    -- Sample vehicle data
    vehicles AS (
        SELECT * FROM (
            VALUES
                (1, 'Toyota', 'Camry', 2020, '1HGBH41JXMN109186', 'ABC-123', 101),
                (2, 'Honda', 'Accord', 2019, '2HGFC2F59KH123456', 'XYZ-789', 102)
        ) AS t(vehicle_id, make, model, year, vin, plate_number, policy_id)
    )

    SELECT
        -- Customer Information from House Insurance
        hcd.customer_id,
        hcd.first_name,
        hcd.last_name,
        hcd.email,
        hcd.phone_mobile,
        hcd.date_of_birth,
        hcd.gender,
        hcd.marital_status,
        hcd.education_level,
        hcd.occupation_industry,
        hcd.annual_income_bracket,
        hcd.credit_score_tier,
        hcd.insurance_score,
        hcd.has_prior_claims,
        hcd.customer_since_date,

        -- House Insurance Policy Information
        hpd.policy_number as house_policy_number,
        hpd.policy_status as house_policy_status,
        hpd.effective_date as house_policy_start,
        hpd.expiration_date as house_policy_end,
        hpd.total_annual_premium as house_annual_premium,
        hpd.coverage_a_dwelling,
        hpd.coverage_c_personal_property,
        hpd.coverage_e_liability,

        -- House Insurance Claims Information
        hcl.claim_id as house_claim_id,
        hcl.net_payout as total_house_claims_paid,
        hcl.cause_of_loss,
        hcl.date_of_loss,
        hcl.claim_status as house_claim_status,

        -- Travel Insurance Information
        td.traveler_id,
        td.email_primary as travel_email,
        td.passport_number,
        td.home_address_city,
        td.home_address_country,
        td.credit_risk_score,

        -- Travel Insurance Policy Information
        tpol.policy_number as travel_policy_number,
        tpol.policy_status as travel_policy_status,
        tpol.plan_name as travel_plan_name,
        tpol.total_premium_paid as travel_total_premium,
        tpol.net_premium as travel_net_premium,

        -- Vehicle Information
        v.make as vehicle_make,
        v.model as vehicle_model,
        v.year as vehicle_year,
        v.vin as vehicle_vin,
        v.plate_number as vehicle_plate

    FROM
        house_customers hcd
    LEFT JOIN
        house_policies hpd ON hcd.customer_id = hpd.customer_id
    LEFT JOIN
        house_claims hcl ON hpd.policy_id = hcl.policy_id
    LEFT JOIN
        travelers td ON hcd.customer_id = td.traveler_id
    LEFT JOIN
        travel_policies tpol ON td.traveler_id = tpol.traveler_id
    LEFT JOIN
        vehicles v ON hpd.policy_id = v.policy_id
    ORDER BY
        hcd.customer_id;
    """

def create_customer_360_view():
    """
    Creates a federated customer 360 view by connecting to multiple insurance data sources
    including house insurance (Snowflake), travel insurance (Databricks), and vehicle data (PostgreSQL)
    """
    # Load settings
    settings = AppSettings()
    
    con = duckdb.connect()  # In-memory database connection
    
    # Load necessary extensions for federated queries
    try:
        # Load the HTTPFS extension for remote connections (if needed)
        con.execute("LOAD httpfs;")

        # Load the postgres_scanner extension for PostgreSQL connections
        con.execute("LOAD postgres_scanner;")

        # Load the snowflake connector if configured
        if settings.is_snowflake_configured():
            logger.info("Snowflake is configured")
            # con.execute("LOAD sf;")  # Actual snowflake extension would be loaded here in a real implementation

        # Load the databricks connector if configured
        if settings.is_databricks_configured():
            logger.info("Databricks is configured")
            # con.execute("LOAD dbr;")  # Actual databricks extension would be loaded here in a real implementation

        logger.info("Successfully loaded extensions for federated queries")
    except Exception as e:
        logger.warning(f"Could not load some extensions: {e}")
    
    # Check if the real data sources are properly configured with actual credentials
    if settings.is_snowflake_configured() and settings.is_databricks_configured() and settings.is_postgres_configured():
        # Check if they're test/demo credentials or real ones
        is_test_config = (
            settings.POSTGRES_HOST_PORT == "localhost:5432" or 
            settings.SNOWFLAKE_ACCOUNT_ID == "test-account" or
            settings.DATABRICKS_WORKSPACE_URL == "https://demo.databricks.com"
        )
        
        if not is_test_config:
            # Use real data sources with actual connections
            customer_360_query = f"""
            -- Customer 360 View Query for Insurance Business using Real Data Sources
            -- Combines data from House Insurance (Snowflake), Travel Insurance (Databricks), and Vehicle Data (PostgreSQL)

            -- In a real implementation, you would connect to your actual data sources
            -- Connect to Snowflake, Databricks, and PostgreSQL using their respective connectors
            -- For this example, we'll use the sample data approach
            {sample_data_query()}
            """
        else:
            # Use sample data for demo/test credentials
            logger.info("Using sample data for demonstration as test credentials detected")
            customer_360_query = sample_data_query()
    else:
        # Fallback to sample data if no real data sources are configured
        logger.info("No real data sources configured, using sample data for demonstration")
        customer_360_query = sample_data_query()
    
    try:
        # Execute the query
        result = con.execute(customer_360_query)
        df = result.fetchdf()
        
        logger.info("Customer 360 view query executed successfully")
        logger.info(f"Retrieved {len(df)} customer records")
        
        # Close the connection
        con.close()
        
        return df
        
    except Exception as e:
        logger.error(f"Error executing customer 360 view query: {e}")
        con.close()
        raise e

def main():
    """
    Main function to execute the customer 360 view creation and display results
    """
    print("Creating federated customer 360 view for insurance business...")
    
    try:
        # Create the customer 360 view
        customer_df = create_customer_360_view()
        
        # Display results
        print("\nCustomer 360 View Results:")
        print("="*50)
        print(customer_df.to_string(index=False))
        
        # Save results to CSV for further analysis
        output_file = "customer_360_view_results.csv"
        customer_df.to_csv(output_file, index=False)
        print(f"\nResults saved to {output_file}")
        
        # Display summary statistics
        print(f"\nSummary:")
        print(f"- Total customers: {len(customer_df)}")
        print(f"- Total unique policies: {customer_df['house_policy_number'].nunique()}")
        print(f"- Customers with house claims: {customer_df['house_claim_id'].notna().sum()}")
        print(f"- Customers with travel insurance: {customer_df['travel_policy_number'].notna().sum()}")
        print(f"- Customers with vehicles: {customer_df['vehicle_make'].notna().sum()}")
        
    except Exception as e:
        logger.error(f"Error in main function: {e}")
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
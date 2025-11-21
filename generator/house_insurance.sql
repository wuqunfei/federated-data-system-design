-- =========================================================
-- 1. SETUP ENVIRONMENT
-- =========================================================


-- =========================================================
-- 2. TABLE: DIM_CUSTOMERS (Expanded Profile)
-- =========================================================
CREATE OR REPLACE TABLE DIM_CUSTOMERS (
    customer_id INT PRIMARY KEY, -- Linked to your 360 ID

    -- Identity & Contact
    first_name STRING NOT NULL,
    last_name STRING NOT NULL,
    email STRING,
    phone_mobile STRING,
    phone_home STRING,
    preferred_contact_method STRING, -- 'EMAIL', 'SMS', 'MAIL'

    -- Demographics (For Actuarial Analysis)
    date_of_birth DATE,
    marital_status STRING, -- 'MARRIED', 'SINGLE', 'WIDOWED'
    gender STRING,
    occupation_industry STRING, -- 'TECH', 'CONSTRUCTION', 'MEDICAL'
    education_level STRING,
    annual_income_bracket STRING, -- '50k-100k', '100k-200k'

    -- Insurance Risk Score (Crucial for Pricing)
    credit_score_tier STRING, -- 'POOR', 'FAIR', 'GOOD', 'EXCELLENT'
    insurance_score INT,      -- 300-900 score specific to insurance risk
    has_prior_claims BOOLEAN, -- 5-year lookback

    -- Metadata
    customer_since_date DATE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- =========================================================
-- 3. TABLE: DIM_PROPERTIES (Real World Risk Attributes)
-- =========================================================
CREATE OR REPLACE TABLE DIM_PROPERTIES (
    property_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,

    -- Location
    address_street STRING,
    city STRING,
    state STRING,
    zip_code STRING,
    county STRING,
    geo_location GEOGRAPHY, -- Snowflake native type for Distance calcs

    -- Physical Construction (The "Real" Data)
    year_built INT,
    sq_ft_living INT,
    sq_ft_lot INT,
    num_stories INT,
    num_bedrooms INT,
    num_bathrooms FLOAT,
    foundation_type STRING, -- 'SLAB', 'BASEMENT', 'CRAWLSPACE'

    -- High Impact Risk Factors (Affects Premium most)
    roof_material STRING,   -- 'ASPHALT SHINGLE', 'METAL', 'TILE', 'SLATE'
    roof_install_year INT,  -- Old roofs = high risk
    exterior_wall_type STRING, -- 'VINYL', 'BRICK', 'STUCCO', 'WOOD'
    heating_system_type STRING, -- 'FORCED AIR', 'RADIANT', 'OIL'
    plumbing_material STRING, -- 'COPPER', 'PVC', 'GALVANIZED', 'PEX'

    -- External Risk Data
    distance_to_fire_hydrant_feet INT,
    distance_to_fire_station_miles FLOAT,
    distance_to_coast_miles FLOAT,
    flood_zone_code STRING, -- 'X', 'AE', 'VE'

    -- Protection Devices (JSON for flexibility)
    -- Ex: {"alarm_monitored": true, "sprinklers": false, "deadbolts": true}
    protection_devices VARIANT,

    -- Hazards (JSON)
    -- Ex: {"has_pool": true, "has_trampoline": false, "dog_breed": "Pitbull"}
    property_hazards VARIANT,

    CONSTRAINT fk_prop_cust FOREIGN KEY (customer_id) REFERENCES DIM_CUSTOMERS(customer_id)
)
-- Clustering helps query performance on large datasets
CLUSTER BY (zip_code, state);

-- =========================================================
-- 4. TABLE: FACT_POLICIES
-- =========================================================
CREATE OR REPLACE TABLE FACT_POLICIES (
    policy_id INT IDENTITY(1,1) PRIMARY KEY,
    policy_number STRING,
    customer_id INT,
    property_id INT,

    -- Contract Details
    policy_form_type STRING, -- 'HO-3 (Special)', 'HO-5 (Comprehensive)', 'DP-3 (Landlord)'
    effective_date DATE,
    expiration_date DATE,
    term_months INT,

    -- Coverage Limits (Financials)
    coverage_a_dwelling NUMERIC(12,2),
    coverage_b_other_structures NUMERIC(12,2),
    coverage_c_personal_property NUMERIC(12,2),
    coverage_d_loss_of_use NUMERIC(12,2),
    coverage_e_liability NUMERIC(12,2),
    coverage_f_med_pay NUMERIC(12,2),

    -- Pricing
    deductible_all_peril NUMERIC(10,2),
    deductible_wind_hail_pct FLOAT, -- 1%, 2%, or 5%
    total_annual_premium NUMERIC(12,2),

    policy_status STRING, -- 'ACTIVE', 'CANCELLED', 'LAPSED'

    CONSTRAINT fk_pol_cust FOREIGN KEY (customer_id) REFERENCES DIM_CUSTOMERS(customer_id),
    CONSTRAINT fk_pol_prop FOREIGN KEY (property_id) REFERENCES DIM_PROPERTIES(property_id)
);

-- =========================================================
-- 5. TABLE: FACT_CLAIMS
-- =========================================================
CREATE OR REPLACE TABLE FACT_CLAIMS (
    claim_id INT IDENTITY(1,1) PRIMARY KEY,
    policy_id INT,

    -- Dates
    date_of_loss DATE,
    date_reported DATE,
    date_closed DATE,

    -- Details
    cause_of_loss STRING, -- 'WIND', 'HAIL', 'FIRE', 'THEFT', 'WATER_BACKUP'
    catastrophe_code STRING, -- If part of a named Hurricane/Storm
    description STRING,

    -- Financials
    amount_paid_building NUMERIC(12,2),
    amount_paid_contents NUMERIC(12,2),
    amount_paid_ale NUMERIC(12,2), -- Additional Living Expenses
    expenses_paid NUMERIC(12,2),   -- Adjuster fees, legal
    deductible_applied NUMERIC(12,2),
    net_payout NUMERIC(12,2),

    claim_status STRING,

    CONSTRAINT fk_clm_pol FOREIGN KEY (policy_id) REFERENCES FACT_POLICIES(policy_id)
);
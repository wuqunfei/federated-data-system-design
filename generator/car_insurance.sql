-- =========================================================
-- 2. RICH TABLE DEFINITIONS (DDL)
-- =========================================================

-- A. CUSTOMERS (Expanded Profile)
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    -- Basic Identity
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    dob DATE,
    gender VARCHAR(20),             -- New

    -- Contact Info
    email VARCHAR(150),             -- New
    phone_number VARCHAR(20),       -- New
    address_street VARCHAR(200),    -- New
    address_city VARCHAR(100),      -- New
    address_state VARCHAR(50),      -- New
    address_zip VARCHAR(20),        -- New

    -- Insurance Risk Factors
    marital_status VARCHAR(20),     -- New (Married often cheaper)
    education_level VARCHAR(50),    -- New (PhD/Masters often cheaper)
    employment_status VARCHAR(50),  -- New
    annual_income INT,              -- New
    credit_tier VARCHAR(20),        -- New (Poor, Fair, Good, Excellent)

    -- System Info
    drivers_license_no VARCHAR(50) UNIQUE,
    customer_since DATE DEFAULT CURRENT_DATE
);

-- B. POLICIES (10 Types Supported)
CREATE TABLE policies (
    policy_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    policy_number VARCHAR(50) UNIQUE,
    policy_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    premium_amount DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT TRUE
);

-- C. VEHICLES
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    policy_id INT REFERENCES policies(policy_id) ON DELETE CASCADE,
    vin VARCHAR(50) UNIQUE,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    plate_number VARCHAR(20)
);

-- D. CLAIMS
CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    policy_id INT REFERENCES policies(policy_id) ON DELETE CASCADE,
    claim_date DATE,
    description TEXT,
    claim_amount DECIMAL(12, 2),
    status VARCHAR(20)
);

-- E. COVERAGES
CREATE TABLE policy_coverages (
    coverage_id SERIAL PRIMARY KEY,
    policy_id INT REFERENCES policies(policy_id) ON DELETE CASCADE,
    coverage_type VARCHAR(100),
    coverage_limit DECIMAL(12,2),
    deductible DECIMAL(10,2),
    is_optional BOOLEAN DEFAULT FALSE,
    description TEXT
);
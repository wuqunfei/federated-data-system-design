-- =========================================================
-- ddl.sql
-- MySQL DDL for the Travel Insurance Data Model
-- Converted from Databricks Delta Lake Schema
-- =========================================================

-- 1. DATABASE SETUP
-- ---------------------------------------------------------
CREATE DATABASE IF NOT EXISTS travel_insurance;
USE travel_insurance;


-- 2. TABLE: TRAVELERS (Deep Profile)
-- Complex types (ARRAY, MAP) are converted to JSON.
-- ---------------------------------------------------------
CREATE TABLE travelers (
    traveler_id INT NOT NULL, -- Links to Central 360 ID

    -- Identity & Passport Data (Critical for Claims/Assistance)
    first_name VARCHAR(100),
    middle_name VARCHAR(100),
    last_name VARCHAR(100),
    gender VARCHAR(10),
    date_of_birth DATE,

    passport_number VARCHAR(50),
    passport_expiry_date DATE,
    passport_issuing_country VARCHAR(50),
    dual_citizenship_country VARCHAR(50), -- Nullable

    -- Contact & Location
    email_primary VARCHAR(255),
    phone_mobile VARCHAR(50),
    home_address_street VARCHAR(255),
    home_address_city VARCHAR(100),
    home_address_state VARCHAR(100),
    home_address_zip VARCHAR(20),
    home_address_country VARCHAR(100),

    -- Emergency Contact
    emergency_contact_name VARCHAR(200),
    emergency_contact_relation VARCHAR(50),
    emergency_contact_phone VARCHAR(50),

    -- Risk & Loyalty Profile (Stored as JSON in MySQL)
    medical_conditions_list JSON,  -- JSON Array: ['Asthma', 'Diabetes']
    vaccination_record JSON,   -- JSON Map: {"YellowFever": "2020-01-01"}

    -- Loyalty Programs (Map: Airline -> Status) (Stored as JSON in MySQL)
    loyalty_program_status JSON, -- Ex: {"Delta": "Diamond", "Marriott": "Titanium"}

    credit_risk_score INT, -- 300-850
    marketing_consent BOOLEAN,

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_traveler PRIMARY KEY (traveler_id)
);



-- 3. TABLE: TRIPS (Logistics & Itinerary)
-- Array type (layover_airport_codes) is converted to JSON.
-- ---------------------------------------------------------
CREATE TABLE trips (
    trip_id BIGINT AUTO_INCREMENT,
    traveler_id INT,

    -- Booking Metadata
    booking_reference_pnr VARCHAR(50), -- The Airline "Record Locator"
    booking_date DATE,
    booking_channel VARCHAR(50), -- 'Expedia', 'Direct', 'CorporateAgent'
    travel_agency_name VARCHAR(100),

    -- Timeline
    travel_start_date DATE,
    travel_end_date DATE,
    trip_duration_days INT,
    days_until_travel INT, -- Calculated at booking (Risk factor)

    -- Geography
    primary_destination_iso VARCHAR(10),
    primary_destination_city VARCHAR(100),
    layover_airport_codes JSON, -- JSON Array: ['LHR', 'DXB']

    -- Logistics Details
    trip_type_category VARCHAR(50), -- 'LEISURE', 'BUSINESS', 'VOLUNTEER', 'CRUISE'
    accommodation_type VARCHAR(50), -- 'HOTEL', 'AIRBNB', 'FRIENDS_FAMILY', 'RESORT'

    -- Transport Specifics
    inbound_airline_code VARCHAR(10),
    inbound_flight_number VARCHAR(20),
    outbound_airline_code VARCHAR(10),
    outbound_flight_number VARCHAR(20),
    cruise_line_name VARCHAR(100),
    cruise_ship_name VARCHAR(100),

    -- Financials
    total_trip_cost DECIMAL(10,2),
    non_refundable_cost DECIMAL(10,2), -- The amount actually insured
    deposit_date DATE,

    CONSTRAINT pk_trip PRIMARY KEY (trip_id),
    CONSTRAINT fk_trip_traveler FOREIGN KEY (traveler_id) REFERENCES travelers(traveler_id)
);

-- Recommended index for the Databricks partition column
CREATE INDEX idx_trip_start_date ON trips (travel_start_date);



-- 4. TABLE: POLICIES (Coverage)
-- Map type (coverage_limits_map) is converted to JSON.
-- ---------------------------------------------------------
CREATE TABLE policies (
    policy_id BIGINT AUTO_INCREMENT,
    policy_number VARCHAR(50),
    trip_id BIGINT,
    traveler_id INT,

    -- Product Configuration
    plan_name VARCHAR(100), -- 'Global Voyager', 'Cruise Defender'
    plan_code VARCHAR(50),
    underwriter VARCHAR(100),

    -- Coverage Limits (Flexible Map - Stored as JSON)
    coverage_limits_map JSON,
    deductible_amount DECIMAL(10,2),

    -- Riders (Boolean flags for special coverage)
    rider_cancel_for_any_reason BOOLEAN,
    rider_extreme_sports BOOLEAN,
    rider_rental_car_collision BOOLEAN,
    rider_pre_existing_waiver BOOLEAN,

    -- Pricing Breakdown
    net_premium DECIMAL(10,2),
    commission_amount DECIMAL(10,2),
    taxes_fees DECIMAL(10,2),
    total_premium_paid DECIMAL(10,2),
    currency_code VARCHAR(10),

    policy_status VARCHAR(50),
    bind_date DATETIME,

    CONSTRAINT pk_policy PRIMARY KEY (policy_id),
    CONSTRAINT fk_policy_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
    CONSTRAINT fk_policy_traveler FOREIGN KEY (traveler_id) REFERENCES travelers(traveler_id)
);



-- 5. TABLE: CLAIMS
-- ---------------------------------------------------------
CREATE TABLE claims (
    claim_id BIGINT AUTO_INCREMENT,
    policy_id BIGINT,
    traveler_id INT,

    incident_date DATE,
    incident_time DATETIME,
    incident_location_city VARCHAR(100),
    incident_country_iso VARCHAR(10),

    loss_category VARCHAR(50), -- 'MEDICAL', 'DELAY', 'BAGGAGE'
    loss_description TEXT, -- Use TEXT for longer descriptions

    -- Evidence Data
    treating_facility_name VARCHAR(100),
    police_report_number VARCHAR(50),
    airline_delay_reason VARCHAR(50), -- 'WEATHER', 'MECHANICAL', 'STRIKE'

    -- Financials
    claimed_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    denied_amount DECIMAL(12,2),
    payout_date DATE,

    claim_status VARCHAR(50),

    CONSTRAINT pk_claim PRIMARY KEY (claim_id),
    CONSTRAINT fk_claim_policy FOREIGN KEY (policy_id) REFERENCES policies(policy_id),
    CONSTRAINT fk_claim_traveler FOREIGN KEY (traveler_id) REFERENCES travelers(traveler_id)
);
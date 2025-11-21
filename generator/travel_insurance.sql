-- =========================================================
-- 1. DATABASE SETUP
-- =========================================================
CREATE DATABASE IF NOT EXISTS travel_insurance_db;
USE travel_insurance_db;

-- =========================================================
-- 2. TABLE: TRAVELERS (Deep Profile)
-- =========================================================
CREATE OR REPLACE TABLE travelers (
    traveler_id INT NOT NULL, -- Links to Central 360 ID

    -- Identity & Passport Data (Critical for Claims/Assistance)
    first_name STRING,
    middle_name STRING,
    last_name STRING,
    gender STRING,
    date_of_birth DATE,

    passport_number STRING,
    passport_expiry_date DATE,
    passport_issuing_country STRING,
    dual_citizenship_country STRING, -- Nullable

    -- Contact & Location
    email_primary STRING,
    phone_mobile STRING,
    home_address_street STRING,
    home_address_city STRING,
    home_address_state STRING,
    home_address_zip STRING,
    home_address_country STRING,

    -- Emergency Contact
    emergency_contact_name STRING,
    emergency_contact_relation STRING,
    emergency_contact_phone STRING,

    -- Risk & Loyalty Profile
    medical_conditions_list ARRAY<STRING>,  -- ['Asthma', 'Diabetes']
    vaccination_record MAP<STRING, DATE>,   -- {'YellowFever': '2020-01-01'}

    -- Loyalty Programs (Map: Airline -> Status)
    -- Ex: {'Delta': 'Diamond', 'Marriott': 'Titanium'}
    loyalty_program_status MAP<STRING, STRING>,

    credit_risk_score INT, -- 300-850
    marketing_consent BOOLEAN,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
USING DELTA
TBLPROPERTIES ('delta.feature.allowColumnDefaults' = 'supported');

-- =========================================================
-- 3. TABLE: TRIPS (Logistics & Itinerary)
-- =========================================================
CREATE OR REPLACE TABLE trips (
    trip_id BIGINT GENERATED ALWAYS AS IDENTITY,
    traveler_id INT,

    -- Booking Metadata
    booking_reference_pnr STRING, -- The Airline "Record Locator"
    booking_date DATE,
    booking_channel STRING, -- 'Expedia', 'Direct', 'CorporateAgent'
    travel_agency_name STRING,

    -- Timeline
    travel_start_date DATE,
    travel_end_date DATE,
    trip_duration_days INT,
    days_until_travel INT, -- Calculated at booking (Risk factor)

    -- Geography
    primary_destination_iso STRING,
    primary_destination_city STRING,
    layover_airport_codes ARRAY<STRING>, -- ['LHR', 'DXB']

    -- Logistics Details
    trip_type_category STRING, -- 'LEISURE', 'BUSINESS', 'VOLUNTEER', 'CRUISE'
    accommodation_type STRING, -- 'HOTEL', 'AIRBNB', 'FRIENDS_FAMILY', 'RESORT'

    -- Transport Specifics
    inbound_airline_code STRING,
    inbound_flight_number STRING,
    outbound_airline_code STRING,
    outbound_flight_number STRING,
    cruise_line_name STRING,
    cruise_ship_name STRING,

    -- Financials
    total_trip_cost DECIMAL(10,2),
    non_refundable_cost DECIMAL(10,2), -- The amount actually insured
    deposit_date DATE,

    CONSTRAINT pk_trip PRIMARY KEY (trip_id)
)
USING DELTA
PARTITIONED BY (travel_start_date);

-- =========================================================
-- 4. TABLE: POLICIES (Coverage)
-- =========================================================
CREATE OR REPLACE TABLE policies (
    policy_id BIGINT GENERATED ALWAYS AS IDENTITY,
    policy_number STRING,
    trip_id BIGINT,
    traveler_id INT,

    -- Product Configuration
    plan_name STRING, -- 'Global Voyager', 'Cruise Defender'
    plan_code STRING,
    underwriter STRING,

    -- Coverage Limits (Flexible Map)
    -- {'Medical': 100000.00, 'Evac': 500000.00, 'Baggage': 2000.00}
    coverage_limits_map MAP<STRING, DECIMAL(12,2)>,
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
    currency_code STRING,

    policy_status STRING,
    bind_date TIMESTAMP
)
USING DELTA;

-- =========================================================
-- 5. TABLE: CLAIMS
-- =========================================================
CREATE OR REPLACE TABLE claims (
    claim_id BIGINT GENERATED ALWAYS AS IDENTITY,
    policy_id BIGINT,
    traveler_id INT,

    incident_date DATE,
    incident_time TIMESTAMP,
    incident_location_city STRING,
    incident_country_iso STRING,

    loss_category STRING, -- 'MEDICAL', 'DELAY', 'BAGGAGE'
    loss_description STRING,

    -- Evidence Data
    treating_facility_name STRING,
    police_report_number STRING,
    airline_delay_reason STRING, -- 'WEATHER', 'MECHANICAL', 'STRIKE'

    -- Financials
    claimed_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    denied_amount DECIMAL(12,2),
    payout_date DATE,

    claim_status STRING
)
USING DELTA;
-- =========================================================
-- HOUSE INSURANCE - Snowflake DML (FIXED)
-- Customer: Qunfei Wu (ID: 11)
-- =========================================================

-- =========================================================
-- 1. DIM_CUSTOMER - Qunfei Wu (NO CHANGE REQUIRED)
-- =========================================================
INSERT INTO DIM_CUSTOMERS (customer_id, first_name, last_name, email, phone_mobile, phone_home,
    preferred_contact_method, date_of_birth, marital_status, gender, occupation_industry,
    education_level, annual_income_bracket, credit_score_tier, insurance_score, has_prior_claims,
    customer_since_date)
VALUES
    (11, 'Qunfei', 'Wu', 'qunfei.wu@email.de', '+49 176 31088798', '+49 89 31088799',
        'EMAIL', '1984-01-02', 'SINGLE', 'Male', 'TECH', 'Masters', '50k-100k',
        'GOOD', 715, TRUE, '2021-08-15');

-- =========================================================
-- 2. DIM_PROPERTY - Munich Apartment (FIXED)
-- NOTE: Changed to INSERT INTO ... SELECT ... to safely use PARSE_JSON.
-- =========================================================
INSERT INTO DIM_PROPERTIES (property_id, customer_id, address_street, city, state, zip_code, county,
    year_built, sq_ft_living, sq_ft_lot, num_stories, num_bedrooms, num_bathrooms,
    foundation_type, roof_material, roof_install_year, exterior_wall_type, heating_system_type,
    plumbing_material, distance_to_fire_hydrant_feet, distance_to_fire_station_miles,
    distance_to_coast_miles, flood_zone_code, protection_devices, property_hazards)
SELECT
    17, 11, 'Sommerstraße 3', 'Munich', 'Bavaria', '81543', 'Munich',
    2015, 950, 0, 3, 2, 1.0, 'SLAB', 'METAL', 2015,
    'STUCCO', 'FORCED AIR', 'PEX', 80, 0.6, 480.0, 'X',
    PARSE_JSON('{"alarm_monitored": "true", "sprinklers": "false", "deadbolts": "true", "smoke_detectors": "true"}'),
    PARSE_JSON('{"has_pool": "false", "has_trampoline": "false", "dog_breed": "true"}');


-- =========================================================
-- 3. FACT_POLICIES - Active House Insurance (NO CHANGE REQUIRED)
-- =========================================================
INSERT INTO FACT_POLICIES (policy_id, policy_number, customer_id, property_id, policy_form_type,
    effective_date, expiration_date, term_months, coverage_a_dwelling, coverage_b_other_structures,
    coverage_c_personal_property, coverage_d_loss_of_use, coverage_e_liability, coverage_f_med_pay,
    deductible_all_peril, deductible_wind_hail_pct, total_annual_premium, policy_status)
VALUES
    -- First policy (when claim happened)
    (29, 'HOME-2022-029-QW', 11, 17, 'HO-3 (Special)', '2022-09-01', '2023-09-01', 12,
        230000.00, 23000.00, 115000.00, 46000.00, 300000.00, 5000.00,
        1000.00, 1.0, 1180.00, 'LAPSED'),

    -- Second policy (renewed after claim)
    (30, 'HOME-2023-030-QW', 11, 17, 'HO-3 (Special)', '2023-09-01', '2024-09-01', 12,
        240000.00, 24000.00, 120000.00, 48000.00, 300000.00, 5000.00,
        1000.00, 1.0, 1250.00, 'LAPSED'),

    -- Current policy
    (31, 'HOME-2024-031-QW', 11, 17, 'HO-3 (Special)', '2024-09-01', '2025-09-01', 12,
        250000.00, 25000.00, 125000.00, 50000.00, 300000.00, 5000.00,
        1000.00, 1.0, 1290.00, 'ACTIVE');


-- =========================================================
-- 4. FACT_CLAIM - Water Pipeline Damage (NO CHANGE REQUIRED)
-- =========================================================
INSERT INTO FACT_CLAIMS (claim_id, policy_id, date_of_loss, date_reported, date_closed,
    cause_of_loss, catastrophe_code, description, amount_paid_building, amount_paid_contents,
    amount_paid_ale, expenses_paid, deductible_applied, net_payout, claim_status)
VALUES
    (44, 29, '2023-02-15', '2023-02-16', '2023-04-20', 'WATER_BACKUP', NULL,
        'Water pipeline burst in bathroom wall. Extensive water damage to bathroom floor, walls, and ceiling. Water leaked into living room below causing damage to hardwood floors and ceiling. Plumbing repairs and restoration required.',
        6800.00, 2400.00, 1800.00, 950.00, 1000.00, 10950.00, 'CLOSED');


-- =========================================================
-- END OF QUNFEI WU HOUSE INSURANCE DATA
-- =========================================================
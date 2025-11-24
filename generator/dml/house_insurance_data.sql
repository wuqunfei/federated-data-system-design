-- =========================================================
-- HOUSE INSURANCE - Snowflake DML (FIXED)
-- 10 German Customers with Properties, Policies & Claims
-- =========================================================

-- =========================================================
-- 1. DIM_CUSTOMERS (10 German Customers) - NO CHANGE
-- =========================================================
INSERT INTO DIM_CUSTOMERS (customer_id, first_name, last_name, email, phone_mobile, phone_home,
    preferred_contact_method, date_of_birth, marital_status, gender, occupation_industry,
    education_level, annual_income_bracket, credit_score_tier, insurance_score, has_prior_claims,
    customer_since_date)
VALUES
    (1, 'Klaus', 'Müller', 'klaus.mueller@email.de', '+49 30 12345678', '+49 30 12345679',
        'EMAIL', '1975-03-15', 'MARRIED', 'Male', 'TECH', 'Masters', '50k-100k',
        'GOOD', 720, TRUE, '2015-06-12'),
    (2, 'Anna', 'Schmidt', 'anna.schmidt@gmail.de', '+49 89 23456789', '+49 89 23456790',
        'EMAIL', '1982-07-22', 'SINGLE', 'Female', 'MEDICAL', 'Bachelors', '50k-100k',
        'EXCELLENT', 780, FALSE, '2017-02-18'),
    (3, 'Thomas', 'Weber', 'thomas.weber@outlook.de', '+49 40 34567890', '+49 40 34567891',
        'EMAIL', '1968-11-08', 'MARRIED', 'Male', 'CONSTRUCTION', 'PhD', '100k-200k',
        'EXCELLENT', 810, TRUE, '2014-09-25'),
    (4, 'Sabine', 'Fischer', 'sabine.fischer@web.de', '+49 221 45678901', '+49 221 45678902',
        'SMS', '1990-05-14', 'SINGLE', 'Female', 'TECH', 'Bachelors', '50k-100k',
        'FAIR', 650, FALSE, '2018-11-03'),
    (5, 'Jürgen', 'Wagner', 'juergen.wagner@t-online.de', '+49 69 56789012', '+49 69 56789013',
        'EMAIL', '1965-09-30', 'MARRIED', 'Male', 'MEDICAL', 'Masters', '100k-200k',
        'GOOD', 740, TRUE, '2013-04-17'),
    (6, 'Petra', 'Becker', 'petra.becker@gmx.de', '+49 711 67890123', '+49 711 67890124',
        'EMAIL', '1978-01-25', 'WIDOWED', 'Female', 'TECH', 'Bachelors', '50k-100k',
        'GOOD', 710, TRUE, '2016-08-09'),
    (7, 'Michael', 'Hoffmann', 'michael.hoffmann@yahoo.de', '+49 351 78901234', '+49 351 78901235',
        'SMS', '1985-12-03', 'MARRIED', 'Male', 'CONSTRUCTION', 'Masters', '50k-100k',
        'GOOD', 725, FALSE, '2019-01-22'),
    (8, 'Stefanie', 'Koch', 'stefanie.koch@mail.de', '+49 511 89012345', '+49 511 89012346',
        'EMAIL', '1973-06-18', 'MARRIED', 'Female', 'MEDICAL', 'Bachelors', '50k-100k',
        'FAIR', 680, TRUE, '2015-12-14'),
    (9, 'Andreas', 'Richter', 'andreas.richter@posteo.de', '+49 341 90123456', '+49 341 90123457',
        'EMAIL', '1992-04-07', 'SINGLE', 'Male', 'TECH', 'Bachelors', '50k-100k',
        'FAIR', 660, FALSE, '2020-05-30'),
    (10, 'Martina', 'Schäfer', 'martina.schaefer@freenet.de', '+49 421 01234567', '+49 421 01234568',
        'MAIL', '1970-08-29', 'WIDOWED', 'Female', 'MEDICAL', 'Masters', '50k-100k',
        'EXCELLENT', 790, TRUE, '2014-03-08');

---

-- =========================================================
-- 2. DIM_PROPERTIES (FIXED: Using INSERT INTO ... SELECT)
-- =========================================================
INSERT INTO DIM_PROPERTIES (property_id, customer_id, address_street, city, state, zip_code, county,
    year_built, sq_ft_living, sq_ft_lot, num_stories, num_bedrooms, num_bathrooms,
    foundation_type, roof_material, roof_install_year, exterior_wall_type, heating_system_type,
    plumbing_material, distance_to_fire_hydrant_feet, distance_to_fire_station_miles,
    distance_to_coast_miles, flood_zone_code, protection_devices, property_hazards)
SELECT
    -- Customer 1 (Klaus) - 2 properties
    1, 1, 'Unter den Linden 25', 'Berlin', 'Berlin', '10117', 'Mitte',
        1985, 1850, 4200, 2, 4, 2.5, 'BASEMENT', 'ASPHALT SHINGLE', 2018,
        'BRICK', 'FORCED AIR', 'COPPER', 120, 0.8, 180.5, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}')
UNION ALL SELECT
    2, 1, 'Spandauer Damm 88', 'Berlin', 'Berlin', '14059', 'Charlottenburg',
        2010, 1200, 2500, 2, 2, 1.5, 'SLAB', 'METAL', 2010,
        'VINYL', 'RADIANT', 'PEX', 85, 1.2, 185.0, 'X',
        PARSE_JSON('{"alarm_monitored": false, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}')
UNION ALL SELECT
    -- Customer 2 (Anna) - 1 property
    3, 2, 'Leopoldstraße 156', 'Munich', 'Bavaria', '80804', 'Munich',
        1995, 1650, 3800, 2, 3, 2.0, 'BASEMENT', 'TILE', 2015,
        'STUCCO', 'FORCED AIR', 'COPPER', 95, 0.5, 520.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": true, "dog_breed": "Golden Retriever"}')
UNION ALL SELECT
    -- Customer 3 (Thomas) - 3 properties
    4, 3, 'Elbchaussee 427', 'Hamburg', 'Hamburg', '22609', 'Altona',
        1978, 2800, 6500, 2, 5, 3.5, 'BASEMENT', 'SLATE', 2012,
        'BRICK', 'FORCED AIR', 'COPPER', 140, 1.5, 12.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": true, "deadbolts": true, "smoke_detectors": true, "security_cameras": true}'),
        PARSE_JSON('{"has_pool": true, "has_trampoline": false, "dog_breed": "German Shepherd"}')
UNION ALL SELECT
    5, 3, 'Strandweg 23', 'Timmendorfer Strand', 'Schleswig-Holstein', '23669', 'Ostholstein',
        2005, 1400, 3000, 1, 3, 2.0, 'SLAB', 'METAL', 2005,
        'WOOD', 'RADIANT', 'PEX', 280, 3.5, 0.3, 'AE',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}')
UNION ALL SELECT
    6, 3, 'Lüneburger Straße 45', 'Hamburg', 'Hamburg', '21339', 'Harburg',
        2015, 950, 1800, 1, 2, 1.0, 'SLAB', 'ASPHALT SHINGLE', 2015,
        'VINYL', 'FORCED AIR', 'PEX', 70, 0.9, 18.0, 'X',
        PARSE_JSON('{"alarm_monitored": false, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}')
UNION ALL SELECT
    -- Customer 4 (Sabine) - 1 property
    7, 4, 'Friesenplatz 12', 'Cologne', 'North Rhine-Westphalia', '50672', 'Cologne',
        2012, 1100, 2200, 2, 2, 1.5, 'BASEMENT', 'METAL', 2012,
        'VINYL', 'FORCED AIR', 'PEX', 90, 1.1, 450.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": "Cat"}')
UNION ALL SELECT
    -- Customer 5 (Jürgen) - 2 properties
    8, 5, 'Bockenheimer Landstraße 91', 'Frankfurt', 'Hesse', '60325', 'Frankfurt',
        1988, 2100, 4500, 2, 4, 2.5, 'BASEMENT', 'TILE', 2016,
        'BRICK', 'FORCED AIR', 'COPPER', 110, 0.7, 320.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": "Labrador"}')
UNION ALL SELECT
    9, 5, 'Weinbergstraße 7', 'Wiesbaden', 'Hesse', '65183', 'Wiesbaden',
        2008, 1350, 2800, 2, 3, 2.0, 'BASEMENT', 'ASPHALT SHINGLE', 2020,
        'STUCCO', 'RADIANT', 'PEX', 125, 1.8, 310.0, 'X',
        PARSE_JSON('{"alarm_monitored": false, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": true, "dog_breed": null}')
UNION ALL SELECT
    -- Customer 6 (Petra) - 1 property
    10, 6, 'Rotebühlplatz 28', 'Stuttgart', 'Baden-Württemberg', '70178', 'Stuttgart',
        1992, 1750, 3600, 2, 3, 2.0, 'BASEMENT', 'ASPHALT SHINGLE', 2017,
        'BRICK', 'FORCED AIR', 'COPPER', 105, 1.0, 280.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}')
UNION ALL SELECT
    -- Customer 7 (Michael) - 2 properties
    11, 7, 'Bautzner Straße 130', 'Dresden', 'Saxony', '01099', 'Dresden',
        1998, 1550, 3200, 2, 3, 2.0, 'BASEMENT', 'ASPHALT SHINGLE', 2019,
        'VINYL', 'FORCED AIR', 'COPPER', 115, 1.3, 420.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": "Beagle"}')
UNION ALL SELECT
    12, 7, 'Loschwitzer Straße 56', 'Dresden', 'Saxony', '01309', 'Dresden',
        2018, 1250, 2400, 2, 2, 1.5, 'SLAB', 'METAL', 2018,
        'VINYL', 'RADIANT', 'PEX', 80, 1.5, 425.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}')
UNION ALL SELECT
    -- Customer 8 (Stefanie) - 1 property
    13, 8, 'Lister Meile 34', 'Hanover', 'Lower Saxony', '30161', 'Hanover',
        1990, 1680, 3400, 2, 3, 2.0, 'BASEMENT', 'TILE', 2014,
        'BRICK', 'FORCED AIR', 'COPPER', 100, 0.9, 250.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": "Poodle"}')
UNION ALL SELECT
    -- Customer 9 (Andreas) - 1 property
    14, 9, 'Karl-Liebknecht-Straße 143', 'Leipzig', 'Saxony', '04277', 'Leipzig',
        2016, 980, 1900, 1, 2, 1.0, 'SLAB', 'ASPHALT SHINGLE', 2016,
        'VINYL', 'FORCED AIR', 'PEX', 75, 0.6, 380.0, 'X',
        PARSE_JSON('{"alarm_monitored": false, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}')
UNION ALL SELECT
    -- Customer 10 (Martina) - 2 properties
    15, 10, 'Am Wall 201', 'Bremen', 'Bremen', '28195', 'Bremen',
        1986, 1900, 4000, 2, 4, 2.5, 'BASEMENT', 'ASPHALT SHINGLE', 2015,
        'BRICK', 'FORCED AIR', 'COPPER', 130, 1.2, 45.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": true, "dog_breed": "Terrier"}')
UNION ALL SELECT
    16, 10, 'Schwachhauser Heerstraße 88', 'Bremen', 'Bremen', '28211', 'Bremen',
        2011, 1450, 2900, 2, 3, 2.0, 'BASEMENT', 'METAL', 2011,
        'STUCCO', 'RADIANT', 'PEX', 95, 1.4, 48.0, 'X',
        PARSE_JSON('{"alarm_monitored": true, "sprinklers": false, "deadbolts": true, "smoke_detectors": true}'),
        PARSE_JSON('{"has_pool": false, "has_trampoline": false, "dog_breed": null}');

---

-- =========================================================
-- 3. FACT_POLICIES (1-3 policies per property) - NO CHANGE
-- =========================================================
INSERT INTO FACT_POLICIES (policy_id, policy_number, customer_id, property_id, policy_form_type,
    effective_date, expiration_date, term_months, coverage_a_dwelling, coverage_b_other_structures,
    coverage_c_personal_property, coverage_d_loss_of_use, coverage_e_liability, coverage_f_med_pay,
    deductible_all_peril, deductible_wind_hail_pct, total_annual_premium, policy_status)
VALUES
    -- Property 1 policies
    (1, 'HOME-2023-001-KM', 1, 1, 'HO-3 (Special)', '2023-01-01', '2024-01-01', 12, 350000.00, 35000.00, 175000.00, 70000.00, 300000.00, 5000.00, 1000.00, 2.0, 1850.00, 'ACTIVE'),
    (2, 'HOME-2024-002-KM', 1, 1, 'HO-3 (Special)', '2024-01-01', '2025-01-01', 12, 365000.00, 36500.00, 182500.00, 73000.00, 300000.00, 5000.00, 1000.00, 2.0, 1920.00, 'ACTIVE'),
    -- Property 2 policies
    (3, 'HOME-2023-003-KM', 1, 2, 'HO-3 (Special)', '2023-06-01', '2024-06-01', 12, 280000.00, 28000.00, 140000.00, 56000.00, 300000.00, 5000.00, 500.00, 1.0, 1380.00, 'LAPSED'),
    (4, 'HOME-2024-004-KM', 1, 2, 'HO-3 (Special)', '2024-06-01', '2025-06-01', 12, 290000.00, 29000.00, 145000.00, 58000.00, 300000.00, 5000.00, 500.00, 1.0, 1425.00, 'ACTIVE'),
    -- Property 3 policies
    (5, 'HOME-2023-005-AS', 2, 3, 'HO-3 (Special)', '2023-02-15', '2024-02-15', 12, 320000.00, 32000.00, 160000.00, 64000.00, 500000.00, 5000.00, 750.00, 1.0, 1680.00, 'ACTIVE'),
    -- Property 4 policies
    (6, 'HOME-2022-006-TW', 3, 4, 'HO-5 (Comprehensive)', '2022-03-01', '2023-03-01', 12, 550000.00, 55000.00, 275000.00, 110000.00, 1000000.00, 10000.00, 2500.00, 2.0, 2850.00, 'LAPSED'),
    (7, 'HOME-2023-007-TW', 3, 4, 'HO-5 (Comprehensive)', '2023-03-01', '2024-03-01', 12, 575000.00, 57500.00, 287500.00, 115000.00, 1000000.00, 10000.00, 2500.00, 2.0, 2980.00, 'LAPSED'),
    (8, 'HOME-2024-008-TW', 3, 4, 'HO-5 (Comprehensive)', '2024-03-01', '2025-03-01', 12, 600000.00, 60000.00, 300000.00, 120000.00, 1000000.00, 10000.00, 2500.00, 2.0, 3120.00, 'ACTIVE'),
    -- Property 5 policies
    (9, 'HOME-2023-009-TW', 3, 5, 'HO-3 (Special)', '2023-04-01', '2024-04-01', 12, 380000.00, 38000.00, 190000.00, 76000.00, 500000.00, 5000.00, 2000.00, 5.0, 2450.00, 'LAPSED'),
    (10, 'HOME-2024-010-TW', 3, 5, 'HO-3 (Special)', '2024-04-01', '2025-04-01', 12, 395000.00, 39500.00, 197500.00, 79000.00, 500000.00, 5000.00, 2000.00, 5.0, 2580.00, 'ACTIVE'),
    -- Property 6 policies
    (11, 'HOME-2024-011-TW', 3, 6, 'DP-3 (Landlord)', '2024-01-01', '2025-01-01', 12, 220000.00, 22000.00, 0.00, 44000.00, 300000.00, 5000.00, 1000.00, 2.0, 980.00, 'ACTIVE'),
    -- Property 7 policies
    (12, 'HOME-2024-012-SF', 4, 7, 'HO-3 (Special)', '2024-05-01', '2025-05-01', 12, 260000.00, 26000.00, 130000.00, 52000.00, 300000.00, 5000.00, 500.00, 1.0, 1320.00, 'ACTIVE'),
    -- Property 8 policies
    (13, 'HOME-2023-013-JW', 5, 8, 'HO-3 (Special)', '2023-01-15', '2024-01-15', 12, 410000.00, 41000.00, 205000.00, 82000.00, 500000.00, 5000.00, 1500.00, 2.0, 2150.00, 'LAPSED'),
    (14, 'HOME-2024-014-JW', 5, 8, 'HO-3 (Special)', '2024-01-15', '2025-01-15', 12, 425000.00, 42500.00, 212500.00, 85000.00, 500000.00, 5000.00, 1500.00, 2.0, 2230.00, 'ACTIVE'),
    -- Property 9 policies
    (15, 'HOME-2023-015-JW', 5, 9, 'HO-3 (Special)', '2023-07-01', '2024-07-01', 12, 310000.00, 31000.00, 155000.00, 62000.00, 300000.00, 5000.00, 1000.00, 1.0, 1580.00, 'LAPSED'),
    (16, 'HOME-2024-016-JW', 5, 9, 'HO-3 (Special)', '2024-07-01', '2025-07-01', 12, 320000.00, 32000.00, 160000.00, 64000.00, 300000.00, 5000.00, 1000.00, 1.0, 1630.00, 'ACTIVE'),
    -- Property 10 policies
    (17, 'HOME-2024-017-PB', 6, 10, 'HO-3 (Special)', '2024-03-01', '2025-03-01', 12, 340000.00, 34000.00, 170000.00, 68000.00, 300000.00, 5000.00, 1000.00, 2.0, 1750.00, 'ACTIVE'),
    -- Property 11 policies
    (18, 'HOME-2023-018-MH', 7, 11, 'HO-3 (Special)', '2023-08-01', '2024-08-01', 12, 305000.00, 30500.00, 152500.00, 61000.00, 300000.00, 5000.00, 750.00, 1.0, 1520.00, 'LAPSED'),
    (19, 'HOME-2024-019-MH', 7, 11, 'HO-3 (Special)', '2024-08-01', '2025-08-01', 12, 315000.00, 31500.00, 157500.00, 63000.00, 300000.00, 5000.00, 750.00, 1.0, 1575.00, 'ACTIVE'),
    -- Property 12 policies
    (20, 'HOME-2024-020-MH', 7, 12, 'HO-3 (Special)', '2024-09-01', '2025-09-01', 12, 285000.00, 28500.00, 142500.00, 57000.00, 300000.00, 5000.00, 500.00, 1.0, 1420.00, 'ACTIVE'),
    -- Property 13 policies
    (21, 'HOME-2023-021-SK', 8, 13, 'HO-3 (Special)', '2023-10-01', '2024-10-01', 12, 330000.00, 33000.00, 165000.00, 66000.00, 300000.00, 5000.00, 1000.00, 2.0, 1680.00, 'LAPSED'),
    (22, 'HOME-2024-022-SK', 8, 13, 'HO-3 (Special)', '2024-10-01', '2025-10-01', 12, 340000.00, 34000.00, 170000.00, 68000.00, 300000.00, 5000.00, 1000.00, 2.0, 1730.00, 'ACTIVE'),
    -- Property 14 policies
    (23, 'HOME-2024-023-AR', 9, 14, 'HO-3 (Special)', '2024-06-15', '2025-06-15', 12, 240000.00, 24000.00, 120000.00, 48000.00, 300000.00, 5000.00, 500.00, 1.0, 1180.00, 'ACTIVE'),
    -- Property 15 policies
    (24, 'HOME-2022-024-MS', 10, 15, 'HO-3 (Special)', '2022-11-01', '2023-11-01', 12, 370000.00, 37000.00, 185000.00, 74000.00, 500000.00, 5000.00, 1500.00, 2.0, 1980.00, 'LAPSED'),
    (25, 'HOME-2023-025-MS', 10, 15, 'HO-3 (Special)', '2023-11-01', '2024-11-01', 12, 385000.00, 38500.00, 192500.00, 77000.00, 500000.00, 5000.00, 1500.00, 2.0, 2050.00, 'LAPSED'),
    (26, 'HOME-2024-026-MS', 10, 15, 'HO-3 (Special)', '2024-11-01', '2025-11-01', 12, 400000.00, 40000.00, 200000.00, 80000.00, 500000.00, 5000.00, 1500.00, 2.0, 2120.00, 'ACTIVE'),
    -- Property 16 policies
    (27, 'HOME-2023-027-MS', 10, 16, 'HO-3 (Special)', '2023-12-01', '2024-12-01', 12, 325000.00, 32500.00, 162500.00, 65000.00, 300000.00, 5000.00, 1000.00, 1.0, 1650.00, 'LAPSED'),
    (28, 'HOME-2024-028-MS', 10, 16, 'HO-3 (Special)', '2024-12-01', '2025-12-01', 12, 335000.00, 33500.00, 167500.00, 67000.00, 300000.00, 5000.00, 1000.00, 1.0, 1700.00, 'ACTIVE');

---

-- =========================================================
-- 4. FACT_CLAIMS (1-10 claims per customer) - NO CHANGE
-- =========================================================
INSERT INTO FACT_CLAIMS (claim_id, policy_id, date_of_loss, date_reported, date_closed,
    cause_of_loss, catastrophe_code, description, amount_paid_building, amount_paid_contents,
    amount_paid_ale, expenses_paid, deductible_applied, net_payout, claim_status)
VALUES
    -- Customer 1 (Klaus) - 4 claims
    (1, 1, '2023-02-20', '2023-02-21', '2023-04-15', 'WATER_BACKUP', NULL, 'Basement flooding from sewage backup during heavy rain', 8500.00, 2300.00, 1200.00, 850.00, 1000.00, 11850.00, 'CLOSED'),
    (2, 1, '2023-07-15', '2023-07-16', '2023-09-08', 'WIND', NULL, 'Roof damage from summer storm, several shingles blown off', 4200.00, 0.00, 0.00, 450.00, 1000.00, 3650.00, 'CLOSED'),
    (3, 2, '2024-03-12', '2024-03-13', NULL, 'HAIL', NULL, 'Hailstorm damaged roof and gutters', 6800.00, 0.00, 0.00, 720.00, 1000.00, 6520.00, 'OPEN'),
    (4, 4, '2024-08-05', '2024-08-05', NULL, 'FIRE', NULL, 'Kitchen fire from stove, minor damage to cabinets and wall', 3400.00, 1800.00, 2500.00, 680.00, 500.00, 7880.00, 'OPEN'),
    -- Customer 2 (Anna) - 2 claims
    (5, 5, '2023-09-18', '2023-09-19', '2023-11-22', 'THEFT', NULL, 'Break-in through back door, electronics and jewelry stolen', 850.00, 8500.00, 0.00, 450.00, 750.00, 9050.00, 'CLOSED'),
    (6, 5, '2024-06-10', '2024-06-11', NULL, 'WATER_BACKUP', NULL, 'Washing machine hose burst, water damage to laundry room', 2200.00, 650.00, 0.00, 320.00, 750.00, 2420.00, 'OPEN'),
    -- Customer 3 (Thomas) - 9 claims
    (7, 6, '2022-05-14', '2022-05-15', '2022-08-20', 'FIRE', NULL, 'Electrical fire in garage, smoke damage throughout house', 28000.00, 12500.00, 8900.00, 3200.00, 2500.00, 50100.00, 'CLOSED'),
    (8, 7, '2023-08-22', '2023-08-23', '2023-10-15', 'WIND', 'STORM-2023-08', 'Major storm damage to roof and exterior siding', 22000.00, 0.00, 0.00, 2100.00, 2500.00, 21600.00, 'CLOSED'),
    (9, 7, '2023-12-03', '2023-12-04', '2024-02-18', 'THEFT', NULL, 'Tools and equipment stolen from shed', 1200.00, 4800.00, 0.00, 280.00, 2500.00, 3780.00, 'CLOSED'),
    (10, 8, '2024-04-15', '2024-04-16', '2024-06-10', 'WATER_BACKUP', NULL, 'Plumbing leak in master bathroom, floor damage', 5600.00, 1200.00, 0.00, 680.00, 2500.00, 4980.00, 'CLOSED'),
    (11, 8, '2024-08-30', '2024-08-31', NULL, 'HAIL', NULL, 'Severe hailstorm damaged roof, windows, and pool equipment', 18500.00, 3200.00, 0.00, 1850.00, 2500.00, 21050.00, 'OPEN'),
    (12, 9, '2023-11-20', '2023-11-21', '2024-01-15', 'WIND', NULL, 'Coastal storm damaged beach house roof and deck', 12000.00, 0.00, 4500.00, 1200.00, 2000.00, 15700.00, 'CLOSED'),
    (13, 10, '2024-07-08', '2024-07-09', NULL, 'WATER_BACKUP', NULL, 'Heavy rain caused minor flooding in basement', 2800.00, 1500.00, 0.00, 380.00, 2000.00, 2680.00, 'OPEN'),
    (14, 11, '2024-05-22', '2024-05-23', '2024-07-18', 'THEFT', NULL, 'Tenant reported break-in, damaged door and stolen appliances', 1800.00, 0.00, 0.00, 220.00, 1000.00, 1020.00, 'CLOSED'),
    (15, 11, '2024-09-15', '2024-09-16', NULL, 'FIRE', NULL, 'Tenant caused small kitchen fire', 4200.00, 0.00, 0.00, 580.00, 1000.00, 3780.00, 'OPEN'),
    -- Customer 4 (Sabine) - 1 claim
    (16, 12, '2024-08-18', '2024-08-19', NULL, 'WATER_BACKUP', NULL, 'Dishwasher leak caused damage to kitchen floor', 2400.00, 800.00, 0.00, 320.00, 500.00, 3020.00, 'OPEN'),
    -- Customer 5 (Jürgen) - 6 claims
    (17, 13, '2023-03-25', '2023-03-26', '2023-05-20', 'WIND', NULL, 'Strong winds damaged fence and outdoor furniture', 1800.00, 650.00, 0.00, 220.00, 1500.00, 1170.00, 'CLOSED'),
    (18, 13, '2023-09-10', '2023-09-11', '2023-11-05', 'FIRE', NULL, 'BBQ accident caused minor deck damage', 3200.00, 0.00, 0.00, 380.00, 1500.00, 2080.00, 'CLOSED'),
    (19, 14, '2024-05-08', '2024-05-09', '2024-07-15', 'WATER_BACKUP', NULL, 'Pipe burst in bathroom, water damage to ceiling below', 5800.00, 1200.00, 0.00, 680.00, 1500.00, 6180.00, 'CLOSED'),
    (20, 14, '2024-10-12', '2024-10-13', NULL, 'THEFT', NULL, 'Bicycle and tools stolen from garage', 0.00, 2400.00, 0.00, 180.00, 1500.00, 1080.00, 'OPEN'),
    (21, 16, '2024-08-22', '2024-08-23', NULL, 'HAIL', NULL, 'Hail damaged roof on rental property', 4200.00, 0.00, 0.00, 520.00, 1000.00, 3720.00, 'OPEN'),
    (22, 16, '2024-10-05', '2024-10-06', NULL, 'WIND', NULL, 'Tree branch fell on roof during storm', 3600.00, 0.00, 0.00, 420.00, 1000.00, 3020.00, 'OPEN'),
    -- Customer 6 (Petra) - 3 claims
    (23, 17, '2024-04-20', '2024-04-21', '2024-06-15', 'WATER_BACKUP', NULL, 'Bathroom toilet overflow caused ceiling damage', 3200.00, 450.00, 0.00, 380.00, 1000.00, 3030.00, 'CLOSED'),
    (24, 17, '2024-07-30', '2024-07-31', NULL, 'WIND', NULL, 'Storm damaged patio cover', 2800.00, 0.00, 0.00, 320.00, 1000.00, 2120.00, 'OPEN'),
    (25, 17, '2024-10-18', '2024-10-19', NULL, 'THEFT', NULL, 'Garden equipment stolen from shed', 0.00, 1200.00, 0.00, 150.00, 1000.00, 350.00, 'OPEN'),
    -- Customer 7 (Michael) - 5 claims
    (26, 18, '2023-10-15', '2023-10-16', '2023-12-20', 'FIRE', NULL, 'Dryer fire in laundry room', 6800.00, 3200.00, 2400.00, 780.00, 750.00, 12430.00, 'CLOSED'),
    (27, 19, '2024-09-08', '2024-09-09', NULL, 'WATER_BACKUP', NULL, 'Basement flooding from sump pump failure', 4200.00, 2800.00, 0.00, 520.00, 750.00, 6770.00, 'OPEN'),
    (28, 19, '2024-10-25', '2024-10-26', NULL, 'WIND', NULL, 'Shingles blown off during windstorm', 2400.00, 0.00, 0.00, 280.00, 750.00, 1930.00, 'OPEN'),
    (29, 20, '2024-09-20', '2024-09-21', NULL, 'THEFT', NULL, 'AC unit stolen from exterior', 3800.00, 0.00, 0.00, 420.00, 500.00, 3720.00, 'OPEN'),
    (30, 20, '2024-11-05', '2024-11-06', NULL, 'WATER_BACKUP', NULL, 'Water heater leak', 1800.00, 600.00, 0.00, 220.00, 500.00, 2120.00, 'OPEN'),
    -- Customer 8 (Stefanie) - 4 claims
    (31, 21, '2023-11-28', '2023-11-29', '2024-01-22', 'WIND', NULL, 'Storm damaged fence and gate', 2200.00, 0.00, 0.00, 280.00, 1000.00, 1480.00, 'CLOSED'),
    (32, 22, '2024-10-15', '2024-10-16', NULL, 'WATER_BACKUP', NULL, 'Kitchen sink pipe leak caused floor damage', 2800.00, 450.00, 0.00, 320.00, 1000.00, 2570.00, 'OPEN'),
    (33, 22, '2024-11-01', '2024-11-02', NULL, 'HAIL', NULL, 'Hail damage to roof and gutters', 5200.00, 0.00, 0.00, 620.00, 1000.00, 4820.00, 'OPEN'),
    (34, 22, '2024-11-12', '2024-11-13', NULL, 'THEFT', NULL, 'Break-in through window, laptop and jewelry stolen', 600.00, 4200.00, 0.00, 380.00, 1000.00, 4180.00, 'OPEN'),
    -- Customer 9 (Andreas) - 1 claim
    (35, 23, '2024-09-14', '2024-09-15', NULL, 'WATER_BACKUP', NULL, 'Apartment above caused water leak into unit', 1800.00, 1200.00, 1500.00, 280.00, 500.00, 4280.00, 'OPEN'),
    -- Customer 10 (Martina) - 8 claims
    (36, 24, '2023-01-18', '2023-01-19', '2023-03-25', 'WIND', NULL, 'Winter storm damaged roof and chimney', 8500.00, 0.00, 0.00, 980.00, 1500.00, 7980.00, 'CLOSED'),
    (37, 24, '2023-06-22', '2023-06-23', '2023-08-18', 'WATER_BACKUP', NULL, 'Sprinkler system malfunction flooded yard and basement', 3200.00, 1800.00, 0.00, 420.00, 1500.00, 3920.00, 'CLOSED'),
    (38, 25, '2023-12-10', '2023-12-11', '2024-02-08', 'FIRE', NULL, 'Fireplace malfunction caused smoke damage', 5400.00, 2200.00, 3800.00, 680.00, 1500.00, 10580.00, 'CLOSED'),
    (39, 26, '2024-11-08', '2024-11-09', NULL, 'HAIL', NULL, 'Large hailstorm damaged roof, windows, and AC unit', 12000.00, 2400.00, 0.00, 1380.00, 1500.00, 14280.00, 'OPEN'),
    (40, 26, '2024-11-15', '2024-11-16', NULL, 'WIND', NULL, 'Strong winds damaged fence and shed', 2800.00, 0.00, 0.00, 320.00, 1500.00, 1620.00, 'OPEN'),
    (41, 27, '2024-02-14', '2024-02-15', '2024-04-10', 'WATER_BACKUP', NULL, 'Frozen pipe burst in garage', 4200.00, 1500.00, 0.00, 520.00, 1000.00, 5220.00, 'CLOSED'),
    (42, 28, '2024-11-20', '2024-11-21', NULL, 'THEFT', NULL, 'Break-in, TV and electronics stolen', 800.00, 5200.00, 0.00, 480.00, 1000.00, 5480.00, 'OPEN'),
    (43, 28, '2024-11-22', '2024-11-23', NULL, 'WIND', NULL, 'Recent storm damaged gutters and downspouts', 1800.00, 0.00, 0.00, 220.00, 1000.00, 1020.00, 'OPEN');

-- =========================================================
-- END OF HOUSE INSURANCE DATA
-- =========================================================
-- =========================================================
-- TRAVEL INSURANCE - MySQL DML
-- 10 German Customers with Trips, Policies & Claims
-- =========================================================

-- =========================================================
-- 1. TRAVELERS (10 German Customers)
-- =========================================================
INSERT INTO travelers (traveler_id, first_name, middle_name, last_name, gender, date_of_birth,
    passport_number, passport_expiry_date, passport_issuing_country, dual_citizenship_country,
    email_primary, phone_mobile, home_address_street, home_address_city, home_address_state,
    home_address_zip, home_address_country, emergency_contact_name, emergency_contact_relation,
    emergency_contact_phone, medical_conditions_list, vaccination_record, loyalty_program_status,
    credit_risk_score, marketing_consent, created_at)
VALUES
    (1, 'Klaus', 'Heinrich', 'Müller', 'Male', '1975-03-15',
        'C01X6ZT47', '2027-03-15', 'Germany', NULL,
        'klaus.mueller@email.de', '+49 30 12345678', 'Unter den Linden 25', 'Berlin', 'Berlin',
        '10117', 'Germany', 'Maria Müller', 'Spouse', '+49 30 98765432',
        '["Hypertension"]', '{"COVID-19": "2023-09-15", "Hepatitis A": "2020-06-10"}',
        '{"Lufthansa": "Senator", "Marriott": "Gold"}',
        720, TRUE, '2015-06-12 10:30:00'),
    
    (2, 'Anna', 'Marie', 'Schmidt', 'Female', '1982-07-22',
        'C02Y7AU58', '2028-07-22', 'Germany', NULL,
        'anna.schmidt@gmail.de', '+49 89 23456789', 'Maximilianstraße 43', 'Munich', 'Bavaria',
        '80539', 'Germany', 'Hans Schmidt', 'Father', '+49 89 87654321',
        '[]', '{"COVID-19": "2023-11-20", "Yellow Fever": "2022-03-15"}',
        '{"Lufthansa": "Frequent Traveller", "Hilton": "Silver"}',
        780, TRUE, '2017-02-18 14:20:00'),
    
    (3, 'Thomas', 'Wilhelm', 'Weber', 'Male', '1968-11-08',
        'C03Z8BV69', '2026-11-08', 'Germany', NULL,
        'thomas.weber@outlook.de', '+49 40 34567890', 'Reeperbahn 154', 'Hamburg', 'Hamburg',
        '20359', 'Germany', 'Helga Weber', 'Spouse', '+49 40 76543210',
        '["Diabetes Type 2"]', '{"COVID-19": "2024-01-10", "Hepatitis B": "2021-08-20"}',
        '{"Lufthansa": "HON Circle", "Marriott": "Platinum", "Delta": "Diamond"}',
        810, TRUE, '2014-09-25 09:15:00'),
    
    (4, 'Sabine', 'Julia', 'Fischer', 'Female', '1990-05-14',
        'C04A9CW70', '2029-05-14', 'Germany', NULL,
        'sabine.fischer@web.de', '+49 221 45678901', 'Hohe Straße 87', 'Cologne', 'North Rhine-Westphalia',
        '50667', 'Germany', 'Peter Fischer', 'Brother', '+49 221 65432109',
        '["Asthma"]', '{"COVID-19": "2023-06-25"}',
        '{"Eurowings": "Basic"}',
        650, TRUE, '2018-11-03 16:45:00'),
    
    (5, 'Jürgen', 'Franz', 'Wagner', 'Male', '1965-09-30',
        'C05B0DX81', '2026-09-30', 'Germany', NULL,
        'juergen.wagner@t-online.de', '+49 69 56789012', 'Zeil 106', 'Frankfurt', 'Hesse',
        '60313', 'Germany', 'Monika Wagner', 'Spouse', '+49 69 54321098',
        '["High Cholesterol"]', '{"COVID-19": "2024-03-18", "Typhoid": "2019-11-05"}',
        '{"Lufthansa": "Senator", "IHG": "Platinum"}',
        740, TRUE, '2013-04-17 11:00:00'),
    
    (6, 'Petra', 'Gabriele', 'Becker', 'Female', '1978-01-25',
        'C06C1EY92', '2027-01-25', 'Germany', NULL,
        'petra.becker@gmx.de', '+49 711 67890123', 'Königstraße 1A', 'Stuttgart', 'Baden-Württemberg',
        '70173', 'Germany', 'Markus Becker', 'Brother', '+49 711 43210987',
        '[]', '{"COVID-19": "2023-08-12"}',
        '{"Eurowings": "Basic", "Best Western": "Gold"}',
        710, TRUE, '2016-08-09 13:30:00'),
    
    (7, 'Michael', 'Stefan', 'Hoffmann', 'Male', '1985-12-03',
        'C07D2FZ03', '2028-12-03', 'Germany', NULL,
        'michael.hoffmann@yahoo.de', '+49 351 78901234', 'Prager Straße 12', 'Dresden', 'Saxony',
        '01069', 'Germany', 'Sandra Hoffmann', 'Spouse', '+49 351 32109876',
        '["Allergies (Pollen)"]', '{"COVID-19": "2024-05-22"}',
        '{"Lufthansa": "Frequent Traveller"}',
        725, TRUE, '2019-01-22 10:45:00'),
    
    (8, 'Stefanie', 'Ursula', 'Koch', 'Female', '1973-06-18',
        'C08E3GA14', '2027-06-18', 'Germany', NULL,
        'stefanie.koch@mail.de', '+49 511 89012345', 'Karmarschstraße 46', 'Hanover', 'Lower Saxony',
        '30159', 'Germany', 'Rainer Koch', 'Spouse', '+49 511 21098765',
        '["Thyroid Disorder"]', '{"COVID-19": "2023-10-08", "Japanese Encephalitis": "2021-05-15"}',
        '{"Air France": "Silver", "AccorHotels": "Silver"}',
        680, TRUE, '2015-12-14 15:20:00'),
    
    (9, 'Andreas', 'Matthias', 'Richter', 'Male', '1992-04-07',
        'C09F4HB25', '2029-04-07', 'Germany', NULL,
        'andreas.richter@posteo.de', '+49 341 90123456', 'Grimmaische Straße 2-4', 'Leipzig', 'Saxony',
        '04109', 'Germany', 'Lisa Richter', 'Sister', '+49 341 10987654',
        '[]', '{"COVID-19": "2024-07-15"}',
        '{"Ryanair": "Basic"}',
        660, TRUE, '2020-05-30 12:00:00'),
    
    (10, 'Martina', 'Elisabeth', 'Schäfer', 'Female', '1970-08-29',
        'C10G5IC36', '2026-08-29', 'Germany', NULL,
        'martina.schaefer@freenet.de', '+49 421 01234567', 'Sögestraße 72', 'Bremen', 'Bremen',
        '28195', 'Germany', 'Anna Schäfer', 'Daughter', '+49 421 09876543',
        '["Arthritis"]', '{"COVID-19": "2024-02-28", "Hepatitis A": "2020-09-12", "Rabies": "2022-07-20"}',
        '{"Lufthansa": "Frequent Traveller", "Marriott": "Gold"}',
        790, TRUE, '2014-03-08 09:30:00');


-- =========================================================
-- 2. TRIPS (1-5 trips per traveler)
-- =========================================================
INSERT INTO trips (trip_id, traveler_id, booking_reference_pnr, booking_date, travel_start_date,
    travel_end_date, trip_duration_days, days_until_travel, primary_destination_iso,
    primary_destination_city, layover_airport_codes, trip_type_category, accommodation_type,
    inbound_airline_code, inbound_flight_number, outbound_airline_code, outbound_flight_number,
    cruise_line_name, cruise_ship_name, total_trip_cost, non_refundable_cost, deposit_date)
VALUES
    -- Traveler 1 (Klaus) - 4 trips
    (1, 1, 'KM23A1', '2023-01-15', '2023-03-10', '2023-03-20', 10, 54, 'ESP', 'Barcelona',
        '["FRA"]', 'LEISURE', 'HOTEL', 'LH', 'LH1134', 'LH', 'LH1135',
        NULL, NULL, 2850.00, 1200.00, '2023-01-15'),
    
    (2, 1, '2023-06-20', '2023-08-05', '2023-08-15', 10, 46, 'ITA', 'Rome',
        '["MUC"]', 'LEISURE', 'HOTEL', 'LH', 'LH1846', 'LH', 'LH1847',
        NULL, NULL, 3200.00, 1500.00, '2023-06-20'),
    
    (3, 1, 'KM24A3', '2024-02-10', '2024-05-18', '2024-05-28', 10, 97, 'GRC', 'Athens',
        '["FRA"]', 'LEISURE', 'RESORT', 'LH', 'LH1288', 'LH', 'LH1289',
        NULL, NULL, 3800.00, 1800.00, '2024-02-10'),
    
    (4, 1, 'KM24A4', '2024-09-15', '2024-11-20', '2024-11-30', 10, 66, 'THA', 'Bangkok',
        '["FRA", "BKK"]', 'LEISURE', 'HOTEL', 'TG', 'TG922', 'TG', 'TG923',
        NULL, NULL, 4500.00, 2200.00, '2024-09-15'),
    
    -- Traveler 2 (Anna) - 3 trips
    (5, 2, 'AS23B1', '2023-04-10', '2023-06-15', '2023-06-22', 7, 66, 'PRT', 'Lisbon',
        '["FRA"]', 'LEISURE', 'AIRBNB', 'TP', 'TP554', 'TP', 'TP555',
        NULL, NULL, 1850.00, 800.00, '2023-04-10'),
    
    (6, 2, 'AS23B2', '2023-10-05', '2023-12-10', '2023-12-17', 7, 66, 'FRA', 'Paris',
        '[]', 'LEISURE', 'HOTEL', 'AF', 'AF1023', 'AF', 'AF1024',
        NULL, NULL, 2200.00, 1000.00, '2023-10-05'),
    
    (7, 2, 'AS24B3', '2024-07-20', '2024-09-28', '2024-10-05', 7, 70, 'NLD', 'Amsterdam',
        '[]', 'LEISURE', 'HOTEL', 'KL', 'KL1764', 'KL', 'KL1765',
        NULL, NULL, 1950.00, 850.00, '2024-07-20'),
    
    -- Traveler 3 (Thomas) - 5 trips
    (8, 3, 'TW23C1', '2023-02-20', '2023-04-15', '2023-04-29', 14, 54, 'USA', 'New York',
        '["FRA", "JFK"]', 'BUSINESS', 'HOTEL', 'LH', 'LH400', 'LH', 'LH401',
        NULL, NULL, 5800.00, 3200.00, '2023-02-20'),
    
    (9, 3, 'TW23C2', '2023-07-10', '2023-09-22', '2023-10-06', 14, 74, 'JPN', 'Tokyo',
        '["FRA", "NRT"]', 'BUSINESS', 'HOTEL', 'LH', 'LH716', 'LH', 'LH717',
        NULL, NULL, 7200.00, 4000.00, '2023-07-10'),
    
    (10, 3, 'TW24C3', '2024-01-15', '2024-03-20', '2024-03-27', 7, 65, 'CHE', 'Zurich',
        '[]', 'BUSINESS', 'HOTEL', 'LX', 'LX1058', 'LX', 'LX1059',
        NULL, NULL, 2800.00, 1500.00, '2024-01-15'),
    
    (11, 3, 'TW24C4', '2024-05-20', '2024-07-28', '2024-08-11', 14, 69, 'ARE', 'Dubai',
        '["FRA", "DXB"]', 'LEISURE', 'RESORT', 'EK', 'EK044', 'EK', 'EK045',
        NULL, NULL, 8500.00, 4500.00, '2024-05-20'),
    
    (12, 3, 'TW24C5', '2024-10-10', '2024-12-14', '2024-12-28', 14, 65, 'AUS', 'Sydney',
        '["SIN", "SYD"]', 'LEISURE', 'HOTEL', 'SQ', 'SQ326', 'SQ', 'SQ327',
        NULL, NULL, 9800.00, 5200.00, '2024-10-10'),
    
    -- Traveler 4 (Sabine) - 2 trips
    (13, 4, 'SF23D1', '2023-05-12', '2023-07-08', '2023-07-15', 7, 57, 'ESP', 'Mallorca',
        '[]', 'LEISURE', 'RESORT', 'EW', 'EW7016', 'EW', 'EW7017',
        NULL, NULL, 1450.00, 650.00, '2023-05-12'),
    
    (14, 4, 'SF24D2', '2024-08-25', '2024-10-12', '2024-10-19', 7, 48, 'GRC', 'Santorini',
        '["ATH"]', 'LEISURE', 'HOTEL', 'A3', 'A3602', 'A3', 'A3603',
        NULL, NULL, 2100.00, 950.00, '2024-08-25'),
    
    -- Traveler 5 (Jürgen) - 5 trips
    (15, 5, 'JW23E1', '2023-03-15', '2023-05-20', '2023-05-27', 7, 66, 'AUT', 'Vienna',
        '[]', 'LEISURE', 'HOTEL', 'OS', 'OS112', 'OS', 'OS113',
        NULL, NULL, 1680.00, 750.00, '2023-03-15'),
    
    (16, 5, 'JW23E2', '2023-08-10', '2023-10-05', '2023-10-15', 10, 56, 'GBR', 'London',
        '[]', 'BUSINESS', 'HOTEL', 'BA', 'BA902', 'BA', 'BA903',
        NULL, NULL, 3200.00, 1600.00, '2023-08-10'),
    
    (17, 5, 'JW24E3', '2024-02-18', '2024-04-10', '2024-04-17', 7, 52, 'CZE', 'Prague',
        '[]', 'LEISURE', 'HOTEL', 'OK', 'OK712', 'OK', 'OK713',
        NULL, NULL, 1450.00, 650.00, '2024-02-18'),
    
    (18, 5, 'JW24E4', '2024-06-20', '2024-08-22', '2024-09-01', 10, 63, 'TUR', 'Istanbul',
        '[]', 'LEISURE', 'RESORT', 'TK', 'TK1590', 'TK', 'TK1591',
        NULL, NULL, 2800.00, 1400.00, '2024-06-20'),
    
    (19, 5, 'JW24E5', '2024-11-05', '2025-01-10', '2025-01-24', 14, 66, 'MEX', 'Cancun',
        '["FRA", "CUN"]', 'LEISURE', 'RESORT', 'LH', 'LH498', 'LH', 'LH499',
        NULL, NULL, 5200.00, 2800.00, '2024-11-05'),
    
    -- Traveler 6 (Petra) - 3 trips
    (20, 6, 'PB23F1', '2023-06-15', '2023-08-18', '2023-08-25', 7, 64, 'ITA', 'Venice',
        '["MUC"]', 'LEISURE', 'HOTEL', 'LH', 'LH334', 'LH', 'LH335',
        NULL, NULL, 2200.00, 1000.00, '2023-06-15'),
    
    (21, 6, 'PB24F2', '2024-04-08', '2024-06-15', '2024-06-22', 7, 68, 'HRV', 'Dubrovnik',
        '["MUC"]', 'LEISURE', 'RESORT', 'OU', 'OU454', 'OU', 'OU455',
        NULL, NULL, 1950.00, 850.00, '2024-04-08'),
    
    (22, 6, 'PB24F3', '2024-09-12', '2024-11-08', '2024-11-22', 14, 57, 'MYS', 'Kuala Lumpur',
        '["DXB", "KUL"]', 'LEISURE', 'HOTEL', 'EK', 'EK348', 'EK', 'EK349',
        NULL, NULL, 4800.00, 2500.00, '2024-09-12'),
    
    -- Traveler 7 (Michael) - 3 trips
    (23, 7, 'MH23G1', '2023-09-05', '2023-11-10', '2023-11-17', 7, 66, 'POL', 'Krakow',
        '[]', 'LEISURE', 'HOTEL', 'LO', 'LO362', 'LO', 'LO363',
        NULL, NULL, 1280.00, 580.00, '2023-09-05'),
    
    (24, 7, 'MH24G2', '2024-05-18', '2024-07-25', '2024-08-01', 7, 68, 'ESP', 'Seville',
        '["FRA"]', 'LEISURE', 'AIRBNB', 'VY', 'VY1122', 'VY', 'VY1123',
        NULL, NULL, 1650.00, 750.00, '2024-05-18'),
    
    (25, 7, 'MH24G3', '2024-10-22', '2024-12-20', '2025-01-03', 14, 59, 'EGY', 'Cairo',
        '["FRA", "CAI"]', 'LEISURE', 'HOTEL', 'MS', 'MS778', 'MS', 'MS779',
        NULL, NULL, 3800.00, 1900.00, '2024-10-22'),
    
    -- Traveler 8 (Stefanie) - 4 trips
    (26, 8, 'SK23H1', '2023-04-20', '2023-06-25', '2023-07-09', 14, 66, 'NOR', 'Oslo',
        '[]', 'CRUISE', 'CRUISE', 'DY', 'DY612', 'DY', 'DY613',
        'Norwegian Cruise Line', 'Norwegian Star', 4500.00, 2400.00, '2023-04-20'),
    
    (27, 8, 'SK23H2', '2023-11-08', '2024-01-15', '2024-01-29', 14, 68, 'THA', 'Phuket',
        '["BKK"]', 'LEISURE', 'RESORT', 'TG', 'TG920', 'TG', 'TG921',
        NULL, NULL, 5200.00, 2800.00, '2023-11-08'),
    
    (28, 8, 'SK24H3', '2024-06-10', '2024-08-15', '2024-08-22', 7, 66, 'DNK', 'Copenhagen',
        '[]', 'LEISURE', 'HOTEL', 'SK', 'SK684', 'SK', 'SK685',
        NULL, NULL, 1850.00, 800.00, '2024-06-10'),
    
    (29, 8, 'SK24H4', '2024-11-18', '2025-01-25', '2025-02-08', 14, 68, 'BRA', 'Rio de Janeiro',
        '["FRA", "GIG"]', 'LEISURE', 'HOTEL', 'LH', 'LH500', 'LH', 'LH501',
        NULL, NULL, 6800.00, 3600.00, '2024-11-18'),
    
    -- Traveler 9 (Andreas) - 2 trips
    (30, 9, 'AR24I1', '2024-07-12', '2024-09-15', '2024-09-22', 7, 65, 'ESP', 'Barcelona',
        '[]', 'LEISURE', 'HOSTEL', 'FR', 'FR128', 'FR', 'FR129',
        NULL, NULL, 980.00, 450.00, '2024-07-12'),
    
    (31, 9, 'AR24I2', '2024-10-28', '2024-12-18', '2024-12-26', 8, 51, 'MAR', 'Marrakech',
        '[]', 'LEISURE', 'HOTEL', 'AT', 'AT952', 'AT', 'AT953',
        NULL, NULL, 1450.00, 650.00, '2024-10-28'),
    
    -- Traveler 10 (Martina) - 5 trips
    (32, 10, 'MS23J1', '2023-03-22', '2023-05-28', '2023-06-11', 14, 67, 'USA', 'San Francisco',
        '["FRA", "SFO"]', 'LEISURE', 'HOTEL', 'UA', 'UA58', 'UA', 'UA59',
        NULL, NULL, 6200.00, 3400.00, '2023-03-22'),
    
    (33, 10, 'MS23J2', '2023-09-18', '2023-11-25', '2023-12-09', 14, 68, 'PER', 'Machu Picchu',
        '["FRA", "LIM", "CUZ"]', 'LEISURE', 'HOTEL', 'LH', 'LH2574', 'LH', 'LH2575',
        NULL, NULL, 7500.00, 4000.00, '2023-09-18'),
    
    (34, 10, 'MS24J3', '2024-02-25', '2024-04-20', '2024-05-04', 14, 55, 'ZAF', 'Cape Town',
        '["FRA", "CPT"]', 'LEISURE', 'HOTEL', 'LH', 'LH574', 'LH', 'LH575',
        NULL, NULL, 6800.00, 3600.00, '2024-02-25'),
    
    (35, 10, 'MS24J4', '2024-07-08', '2024-09-10', '2024-09-24', 14, 64, 'NZL', 'Auckland',
        '["SIN", "AKL"]', 'LEISURE', 'HOTEL', 'SQ', 'SQ286', 'SQ', 'SQ287',
        NULL, NULL, 8900.00, 4800.00, '2024-07-08'),
    
    (36, 10, 'MS24J5', '2024-11-12', '2025-01-18', '2025-02-01', 14, 67, 'CAN', 'Vancouver',
        '["FRA", "YVR"]', 'LEISURE', 'HOTEL', 'AC', 'AC874', 'AC', 'AC875',
        NULL, NULL, 5800.00, 3200.00, '2024-11-12');


-- =========================================================
-- 3. POLICIES (1 policy per trip)
-- =========================================================
INSERT INTO policies (policy_id, policy_number, trip_id, traveler_id, plan_name, plan_code,
    underwriter, coverage_limits_map, deductible_amount, rider_cancel_for_any_reason,
    rider_extreme_sports, rider_rental_car_collision, rider_pre_existing_waiver,
    net_premium, commission_amount, taxes_fees, total_premium_paid, currency_code,
    policy_status, bind_date)
VALUES
    -- Policies for Traveler 1 (Klaus)
    (1, 'TRV-2023-001-KM', 1, 1, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 1200, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 85.00, 15.00, 8.50, 108.50, 'EUR', 'ACTIVE', '2023-01-15 14:30:00'),
    
    (2, 'TRV-2023-002-KM', 2, 1, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 1500, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, TRUE, FALSE, 95.00, 17.00, 9.50, 121.50, 'EUR', 'CLOSED', '2023-06-20 10:15:00'),
    
    (3, 'TRV-2024-003-KM', 3, 1, 'European Deluxe', 'EU-DELUXE', 'Allianz Global',
        '{"MedicalExpense": 250000, "TripCancellation": 1800, "BaggageDelay": 1000, "EmergencyEvacuation": 100000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 145.00, 26.00, 14.50, 185.50, 'EUR', 'ACTIVE', '2024-02-10 16:20:00'),
    
    (4, 'TRV-2024-004-KM', 4, 1, 'Global Voyager', 'GLB-PREM', 'AXA Assistance',
        '{"MedicalExpense": 500000, "TripCancellation": 2200, "BaggageDelay": 2000, "EmergencyEvacuation": 250000}',
        100.00, TRUE, FALSE, TRUE, TRUE, 280.00, 50.00, 28.00, 358.00, 'EUR', 'ACTIVE', '2024-09-15 11:45:00'),
    
    -- Policies for Traveler 2 (Anna)
    (5, 'TRV-2023-005-AS', 5, 2, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 800, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 65.00, 12.00, 6.50, 83.50, 'EUR', 'CLOSED', '2023-04-10 09:30:00'),
    
    (6, 'TRV-2023-006-AS', 6, 2, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 1000, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 75.00, 13.50, 7.50, 96.00, 'EUR', 'CLOSED', '2023-10-05 13:20:00'),
    
    (7, 'TRV-2024-007-AS', 7, 2, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 850, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 68.00, 12.20, 6.80, 87.00, 'EUR', 'ACTIVE', '2024-07-20 15:10:00'),
    
    -- Policies for Traveler 3 (Thomas)
    (8, 'TRV-2023-008-TW', 8, 3, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 3200, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 420.00, 75.00, 42.00, 537.00, 'EUR', 'CLOSED', '2023-02-20 10:45:00'),
    
    (9, 'TRV-2023-009-TW', 9, 3, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 4000, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 520.00, 93.00, 52.00, 665.00, 'EUR', 'CLOSED', '2023-07-10 14:30:00'),
    
    (10, 'TRV-2024-010-TW', 10, 3, 'European Business', 'EU-BUS', 'Allianz Global',
        '{"MedicalExpense": 250000, "TripCancellation": 1500, "BaggageDelay": 1500, "EmergencyEvacuation": 100000}',
        50.00, FALSE, FALSE, TRUE, FALSE, 165.00, 30.00, 16.50, 211.50, 'EUR', 'CLOSED', '2024-01-15 09:20:00'),
    
    (11, 'TRV-2024-011-TW', 11, 3, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 4500, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 580.00, 104.00, 58.00, 742.00, 'EUR', 'ACTIVE', '2024-05-20 16:15:00'),
    
    (12, 'TRV-2024-012-TW', 12, 3, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 5200, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 680.00, 122.00, 68.00, 870.00, 'EUR', 'ACTIVE', '2024-10-10 11:30:00'),
    
    -- Policies for Traveler 4 (Sabine)
    (13, 'TRV-2023-013-SF', 13, 4, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 650, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 55.00, 10.00, 5.50, 70.50, 'EUR', 'CLOSED', '2023-05-12 12:45:00'),
    
    (14, 'TRV-2024-014-SF', 14, 4, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 950, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 72.00, 13.00, 7.20, 92.20, 'EUR', 'ACTIVE', '2024-08-25 10:30:00'),
    
    -- Policies for Traveler 5 (Jürgen)
    (15, 'TRV-2023-015-JW', 15, 5, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 750, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 62.00, 11.20, 6.20, 79.40, 'EUR', 'CLOSED', '2023-03-15 15:20:00'),
    
    (16, 'TRV-2023-016-JW', 16, 5, 'European Business', 'EU-BUS', 'Allianz Global',
        '{"MedicalExpense": 250000, "TripCancellation": 1600, "BaggageDelay": 1500, "EmergencyEvacuation": 100000}',
        50.00, TRUE, FALSE, TRUE, FALSE, 185.00, 33.00, 18.50, 236.50, 'EUR', 'CLOSED', '2023-08-10 13:40:00'),
    
    (17, 'TRV-2024-017-JW', 17, 5, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 650, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 58.00, 10.50, 5.80, 74.30, 'EUR', 'CLOSED', '2024-02-18 09:15:00'),
    
    (18, 'TRV-2024-018-JW', 18, 5, 'European Deluxe', 'EU-DELUXE', 'Allianz Global',
        '{"MedicalExpense": 250000, "TripCancellation": 1400, "BaggageDelay": 1000, "EmergencyEvacuation": 100000}',
        50.00, TRUE, FALSE, TRUE, FALSE, 132.00, 24.00, 13.20, 169.20, 'EUR', 'ACTIVE', '2024-06-20 14:25:00'),
    
    (19, 'TRV-2024-019-JW', 19, 5, 'Global Voyager', 'GLB-PREM', 'AXA Assistance',
        '{"MedicalExpense": 500000, "TripCancellation": 2800, "BaggageDelay": 2000, "EmergencyEvacuation": 250000}',
        100.00, TRUE, FALSE, TRUE, TRUE, 350.00, 63.00, 35.00, 448.00, 'EUR', 'ACTIVE', '2024-11-05 10:50:00'),
    
    -- Policies for Traveler 6 (Petra)
    (20, 'TRV-2023-020-PB', 20, 6, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 1000, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 76.00, 13.70, 7.60, 97.30, 'EUR', 'CLOSED', '2023-06-15 11:30:00'),
    
    (21, 'TRV-2024-021-PB', 21, 6, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 850, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 69.00, 12.40, 6.90, 88.30, 'EUR', 'CLOSED', '2024-04-08 16:45:00'),
    
    (22, 'TRV-2024-022-PB', 22, 6, 'Global Voyager', 'GLB-PREM', 'AXA Assistance',
        '{"MedicalExpense": 500000, "TripCancellation": 2500, "BaggageDelay": 2000, "EmergencyEvacuation": 250000}',
        100.00, TRUE, FALSE, TRUE, TRUE, 320.00, 57.60, 32.00, 409.60, 'EUR', 'ACTIVE', '2024-09-12 13:20:00'),
    
    -- Policies for Traveler 7 (Michael)
    (23, 'TRV-2023-023-MH', 23, 7, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 580, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 52.00, 9.40, 5.20, 66.60, 'EUR', 'CLOSED', '2023-09-05 14:10:00'),
    
    (24, 'TRV-2024-024-MH', 24, 7, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 750, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 63.00, 11.30, 6.30, 80.60, 'EUR', 'CLOSED', '2024-05-18 09:45:00'),
    
    (25, 'TRV-2024-025-MH', 25, 7, 'Global Voyager', 'GLB-PREM', 'AXA Assistance',
        '{"MedicalExpense": 500000, "TripCancellation": 1900, "BaggageDelay": 2000, "EmergencyEvacuation": 250000}',
        100.00, FALSE, FALSE, TRUE, FALSE, 245.00, 44.00, 24.50, 313.50, 'EUR', 'ACTIVE', '2024-10-22 15:30:00'),
    
    -- Policies for Traveler 8 (Stefanie)
    (26, 'TRV-2023-026-SK', 26, 8, 'Cruise Defender', 'CRUISE-DELUXE', 'Travel Guard',
        '{"MedicalExpense": 250000, "TripCancellation": 2400, "BaggageDelay": 1500, "EmergencyEvacuation": 150000, "CruiseDisruption": 5000}',
        100.00, TRUE, FALSE, FALSE, TRUE, 310.00, 55.80, 31.00, 396.80, 'EUR', 'CLOSED', '2023-04-20 10:20:00'),
    
    (27, 'TRV-2023-027-SK', 27, 8, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 2800, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 380.00, 68.40, 38.00, 486.40, 'EUR', 'CLOSED', '2023-11-08 14:50:00'),
    
    (28, 'TRV-2024-028-SK', 28, 8, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 800, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 66.00, 11.90, 6.60, 84.50, 'EUR', 'CLOSED', '2024-06-10 16:30:00'),
    
    (29, 'TRV-2024-029-SK', 29, 8, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 3600, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 480.00, 86.40, 48.00, 614.40, 'EUR', 'ACTIVE', '2024-11-18 11:15:00'),
    
    -- Policies for Traveler 9 (Andreas)
    (30, 'TRV-2024-030-AR', 30, 9, 'European Budget', 'EU-BUDGET', 'ERV',
        '{"MedicalExpense": 50000, "TripCancellation": 450, "BaggageDelay": 300, "EmergencyEvacuation": 25000}',
        150.00, FALSE, FALSE, FALSE, FALSE, 42.00, 7.60, 4.20, 53.80, 'EUR', 'CLOSED', '2024-07-12 13:45:00'),
    
    (31, 'TRV-2024-031-AR', 31, 9, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 650, "BaggageDelay": 500, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 58.00, 10.50, 5.80, 74.30, 'EUR', 'ACTIVE', '2024-10-28 09:30:00'),
    
    -- Policies for Traveler 10 (Martina)
    (32, 'TRV-2023-032-MS', 32, 10, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 3400, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 450.00, 81.00, 45.00, 576.00, 'EUR', 'CLOSED', '2023-03-22 15:20:00'),
    
    (33, 'TRV-2023-033-MS', 33, 10, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 4000, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, TRUE, TRUE, TRUE, 550.00, 99.00, 55.00, 704.00, 'EUR', 'CLOSED', '2023-09-18 10:45:00'),
    
    (34, 'TRV-2024-034-MS', 34, 10, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 3600, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 480.00, 86.40, 48.00, 614.40, 'EUR', 'CLOSED', '2024-02-25 14:10:00'),
    
    (35, 'TRV-2024-035-MS', 35, 10, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 4800, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 620.00, 111.60, 62.00, 793.60, 'EUR', 'ACTIVE', '2024-07-08 16:40:00'),
    
    (36, 'TRV-2024-036-MS', 36, 10, 'Global Voyager Premium', 'GLB-PREM-PLUS', 'AXA Assistance',
        '{"MedicalExpense": 1000000, "TripCancellation": 3200, "BaggageDelay": 3000, "EmergencyEvacuation": 500000}',
        50.00, TRUE, FALSE, TRUE, TRUE, 420.00, 75.60, 42.00, 537.60, 'EUR', 'ACTIVE', '2024-11-12 12:25:00');


-- =========================================================
-- 4. CLAIMS (1-10 claims per traveler - various types)
-- =========================================================
INSERT INTO claims (claim_id, policy_id, traveler_id, incident_date, incident_time,
    incident_location_city, incident_country_iso, loss_category, loss_description,
    treating_facility_name, police_report_number, airline_delay_reason,
    claimed_amount, approved_amount, denied_amount, payout_date, claim_status)
VALUES
    -- Traveler 1 (Klaus) - 4 claims
    (1, 1, 1, '2023-03-12', '2023-03-12 14:30:00', 'Barcelona', 'ESP', 'MEDICAL',
        'Slipped on wet floor in hotel, sprained ankle requiring emergency treatment',
        'Hospital Clinic Barcelona', NULL, NULL,
        1250.00, 1150.00, 100.00, '2023-04-15', 'PAID'),
    
    (2, 2, 1, '2023-08-07', '2023-08-07 18:45:00', 'Rome', 'ITA', 'BAGGAGE',
        'Checked luggage delayed 48 hours, needed to purchase essentials',
        NULL, NULL, NULL,
        420.00, 420.00, 0.00, '2023-09-05', 'PAID'),
    
    (3, 3, 1, '2024-05-16', '2024-05-16 09:00:00', 'Frankfurt', 'DEU', 'DELAY',
        'Flight canceled due to mechanical issues, missed connecting flight',
        NULL, NULL, 'MECHANICAL',
        850.00, 750.00, 100.00, NULL, 'APPROVED'),
    
    (4, 4, 1, '2024-11-22', '2024-11-22 11:20:00', 'Bangkok', 'THA', 'MEDICAL',
        'Food poisoning requiring hospitalization for 2 days',
        'Bumrungrad International Hospital', NULL, NULL,
        3200.00, 3100.00, 100.00, NULL, 'UNDER_REVIEW'),
    
    -- Traveler 2 (Anna) - 2 claims
    (5, 5, 2, '2023-06-18', '2023-06-18 16:15:00', 'Lisbon', 'PRT', 'THEFT',
        'Purse stolen in tourist area, passport and wallet taken',
        NULL, 'PT-2023-061823', NULL,
        680.00, 580.00, 100.00, '2023-07-22', 'PAID'),
    
    (6, 6, 2, '2023-12-14', '2023-12-14 20:30:00', 'Paris', 'FRA', 'MEDICAL',
        'Severe allergic reaction to restaurant meal, emergency room visit',
        'Hôpital Américain de Paris', NULL, NULL,
        890.00, 790.00, 100.00, '2024-01-18', 'PAID'),
    
    -- Traveler 3 (Thomas) - 10 claims
    (7, 8, 3, '2023-04-18', '2023-04-18 08:00:00', 'Frankfurt', 'DEU', 'DELAY',
        'Flight to New York delayed 8 hours due to crew shortage',
        NULL, NULL, 'CREW',
        620.00, 520.00, 100.00, '2023-05-20', 'PAID'),
    
    (8, 8, 3, '2023-04-22', '2023-04-22 15:30:00', 'New York', 'USA', 'BAGGAGE',
        'Luggage lost for 72 hours, emergency purchases required',
        NULL, NULL, NULL,
        850.00, 850.00, 0.00, '2023-06-10', 'PAID'),
    
    (9, 9, 3, '2023-09-25', '2023-09-25 10:45:00', 'Tokyo', 'JPN', 'MEDICAL',
        'Injured knee during business meeting, required MRI and treatment',
        'Tokyo Medical University Hospital', NULL, NULL,
        2400.00, 2350.00, 50.00, '2023-11-08', 'PAID'),
    
    (10, 9, 3, '2023-09-30', '2023-09-30 12:00:00', 'Tokyo', 'JPN', 'TRIP_INTERRUPTION',
        'Had to return home early due to family emergency',
        NULL, NULL, NULL,
        1800.00, 1700.00, 100.00, '2023-11-15', 'PAID'),
    
    (11, 10, 3, '2024-03-22', '2024-03-22 14:20:00', 'Zurich', 'CHE', 'DELAY',
        'Flight delayed 6 hours due to weather, missed important meeting',
        NULL, NULL, 'WEATHER',
        450.00, 400.00, 50.00, '2024-04-25', 'PAID'),
    
    (12, 11, 3, '2024-07-30', '2024-07-30 16:40:00', 'Dubai', 'ARE', 'MEDICAL',
        'Heat exhaustion requiring hospital treatment',
        'American Hospital Dubai', NULL, NULL,
        1650.00, 1600.00, 50.00, NULL, 'APPROVED'),
    
    (13, 11, 3, '2024-08-05', '2024-08-05 11:15:00', 'Dubai', 'ARE', 'BAGGAGE',
        'Checked bag damaged during handling, contents partially lost',
        NULL, NULL, NULL,
        920.00, 820.00, 100.00, NULL, 'APPROVED'),
    
    (14, 12, 3, '2024-12-18', '2024-12-18 09:30:00', 'Singapore', 'SGP', 'DELAY',
        'Connecting flight missed due to arrival delay',
        NULL, NULL, 'MECHANICAL',
        780.00, 730.00, 50.00, NULL, 'UNDER_REVIEW'),
    
    (15, 12, 3, '2024-12-20', '2024-12-20 13:45:00', 'Sydney', 'AUS', 'MEDICAL',
        'Accident while snorkeling, laceration requiring stitches',
        'St Vincent\'s Hospital Sydney', NULL, NULL,
        1280.00, 1230.00, 50.00, NULL, 'UNDER_REVIEW'),
    
    (16, 12, 3, '2024-12-25', '2024-12-25 19:00:00', 'Sydney', 'AUS', 'THEFT',
        'Rental car broken into, camera equipment stolen',
        NULL, 'AU-2024-122501', NULL,
        2400.00, 2300.00, 100.00, NULL, 'UNDER_REVIEW'),
    
    -- Traveler 4 (Sabine) - 1 claim
    (17, 13, 4, '2023-07-10', '2023-07-10 17:20:00', 'Mallorca', 'ESP', 'MEDICAL',
        'Sunburn requiring medical treatment and prescription',
        'Hospital Son Llàtzer', NULL, NULL,
        280.00, 180.00, 100.00, '2023-08-14', 'PAID'),
    
    -- Traveler 5 (Jürgen) - 6 claims
    (18, 15, 5, '2023-05-23', '2023-05-23 11:30:00', 'Vienna', 'AUT', 'BAGGAGE',
        'Luggage delayed 24 hours, purchased necessities',
        NULL, NULL, NULL,
        220.00, 220.00, 0.00, '2023-06-20', 'PAID'),
    
    (19, 16, 5, '2023-10-08', '2023-10-08 15:45:00', 'London', 'GBR', 'DELAY',
        'Flight delayed overnight, hotel accommodation required',
        NULL, NULL, 'WEATHER',
        420.00, 370.00, 50.00, '2023-11-12', 'PAID'),
    
    (20, 16, 5, '2023-10-12', '2023-10-12 09:15:00', 'London', 'GBR', 'MEDICAL',
        'Acute back pain, emergency chiropractic treatment needed',
        'London Bridge Hospital', NULL, NULL,
        650.00, 600.00, 50.00, '2023-11-18', 'PAID'),
    
    (21, 18, 5, '2024-08-25', '2024-08-25 14:30:00', 'Istanbul', 'TUR', 'MEDICAL',
        'Severe stomach illness, hospital visit and medication',
        'American Hospital Istanbul', NULL, NULL,
        780.00, 730.00, 50.00, NULL, 'APPROVED'),
    
    (22, 18, 5, '2024-08-28', '2024-08-28 10:00:00', 'Istanbul', 'TUR', 'THEFT',
        'Phone stolen in crowded market area',
        NULL, 'TR-2024-082801', NULL,
        520.00, 420.00, 100.00, NULL, 'APPROVED'),
    
    (23, 19, 5, '2025-01-15', '2025-01-15 16:20:00', 'Cancun', 'MEX', 'MEDICAL',
        'Cut foot on coral, required medical attention',
        'Hospital Americano Cancun', NULL, NULL,
        680.00, 630.00, 50.00, NULL, 'UNDER_REVIEW'),
    
    -- Traveler 6 (Petra) - 3 claims
    (24, 20, 6, '2023-08-20', '2023-08-20 12:45:00', 'Venice', 'ITA', 'DELAY',
        'Flight delayed 5 hours, meal vouchers and accommodation',
        NULL, NULL, 'MECHANICAL',
        320.00, 270.00, 50.00, '2023-09-22', 'PAID'),
    
    (25, 21, 6, '2024-06-18', '2024-06-18 18:30:00', 'Dubrovnik', 'HRV', 'MEDICAL',
        'Twisted ankle while sightseeing, x-ray and treatment',
        'Dubrovnik General Hospital', NULL, NULL,
        480.00, 430.00, 50.00, '2024-07-20', 'PAID'),
    
    (26, 22, 6, '2024-11-12', '2024-11-12 21:00:00', 'Kuala Lumpur', 'MYS', 'MEDICAL',
        'Respiratory infection requiring doctor visit and medication',
        'Gleneagles Kuala Lumpur', NULL, NULL,
        620.00, 570.00, 50.00, NULL, 'APPROVED'),
    
    -- Traveler 7 (Michael) - 5 claims
    (27, 23, 7, '2023-11-14', '2023-11-14 13:20:00', 'Krakow', 'POL', 'BAGGAGE',
        'Lost luggage for entire trip, emergency purchases required',
        NULL, NULL, NULL,
        580.00, 580.00, 0.00, '2023-12-18', 'PAID'),
    
    (28, 24, 7, '2024-07-28', '2024-07-28 16:45:00', 'Seville', 'ESP', 'MEDICAL',
        'Heat stroke requiring emergency treatment',
        'Hospital Universitario Virgen del Rocío', NULL, NULL,
        720.00, 670.00, 50.00, '2024-08-25', 'PAID'),
    
    (29, 24, 7, '2024-07-30', '2024-07-30 10:15:00', 'Seville', 'ESP', 'THEFT',
        'Backpack stolen with electronics and documents',
        NULL, 'ES-2024-073001', NULL,
        850.00, 750.00, 100.00, '2024-09-05', 'PAID'),
    
    (30, 25, 7, '2024-12-22', '2024-12-22 14:00:00', 'Cairo', 'EGY', 'MEDICAL',
        'Food poisoning, medical treatment and medication',
        'As-Salam International Hospital', NULL, NULL,
        520.00, 470.00, 50.00, NULL, 'UNDER_REVIEW'),
    
    (31, 25, 7, '2024-12-26', '2024-12-26 09:30:00', 'Cairo', 'EGY', 'DELAY',
        'Return flight delayed 12 hours, accommodation and meals',
        NULL, NULL, 'CREW',
        680.00, 630.00, 50.00, NULL, 'UNDER_REVIEW'),
    
    -- Traveler 8 (Stefanie) - 4 claims
    (32, 26, 8, '2023-07-02', '2023-07-02 19:15:00', 'Oslo', 'NOR', 'CRUISE_DISRUPTION',
        'Cruise delayed departure by 18 hours due to technical issue',
        NULL, NULL, NULL,
        1200.00, 1100.00, 100.00, '2023-08-10', 'PAID'),
    
    (33, 27, 8, '2024-01-20', '2024-01-20 11:30:00', 'Phuket', 'THA', 'MEDICAL',
        'Motorcycle accident, fracture requiring hospitalization',
        'Bangkok Hospital Phuket', NULL, NULL,
        4800.00, 4750.00, 50.00, '2024-03-05', 'PAID'),
    
    (34, 28, 8, '2024-08-18', '2024-08-18 15:20:00', 'Copenhagen', 'DNK', 'BAGGAGE',
        'Checked bag lost by airline, compensation for necessities',
        NULL, NULL, NULL,
        380.00, 380.00, 0.00, '2024-09-15', 'PAID'),
    
    (35, 29, 8, '2025-01-28', '2025-01-28 13:45:00', 'Rio de Janeiro', 'BRA', 'THEFT',
        'Wallet stolen on beach, credit cards and cash taken',
        NULL, 'BR-2025-012801', NULL,
        450.00, 350.00, 100.00, NULL, 'UNDER_REVIEW'),
    
    -- Traveler 9 (Andreas) - 1 claim
    (36, 30, 9, '2024-09-19', '2024-09-19 17:30:00', 'Barcelona', 'ESP', 'BAGGAGE',
        'Backpack damaged during flight, laptop inside damaged',
        NULL, NULL, NULL,
        450.00, 350.00, 100.00, '2024-10-15', 'PAID'),
    
    -- Traveler 10 (Martina) - 8 claims
    (37, 32, 10, '2023-06-02', '2023-06-02 10:15:00', 'San Francisco', 'USA', 'MEDICAL',
        'Allergic reaction to medication, emergency room visit',
        'UCSF Medical Center', NULL, NULL,
        2800.00, 2750.00, 50.00, '2023-07-20', 'PAID'),
    
    (38, 32, 10, '2023-06-08', '2023-06-08 14:30:00', 'San Francisco', 'USA', 'THEFT',
        'Rental car broken into, luggage and camera stolen',
        NULL, 'US-CA-2023-060801', NULL,
        1950.00, 1850.00, 100.00, '2023-07-28', 'PAID'),
    
    (39, 33, 10, '2023-11-30', '2023-11-30 09:45:00', 'Cusco', 'PER', 'MEDICAL',
        'Altitude sickness requiring oxygen therapy and medication',
        'Clinica Pardo', NULL, NULL,
        850.00, 800.00, 50.00, '2024-01-15', 'PAID'),
    
    (40, 33, 10, '2023-12-04', '2023-12-04 16:20:00', 'Machu Picchu', 'PER', 'MEDICAL',
        'Minor fall on trail, sprained wrist requiring medical attention',
        'Centro de Salud Machu Picchu', NULL, NULL,
        420.00, 370.00, 50.00, '2024-01-22', 'PAID'),
    
    (41, 34, 10, '2024-04-25', '2024-04-25 11:00:00', 'Cape Town', 'ZAF', 'DELAY',
        'Flight from Frankfurt delayed 10 hours, missed day tour',
        NULL, NULL, 'WEATHER',
        680.00, 630.00, 50.00, '2024-06-10', 'PAID'),
    
    (42, 34, 10, '2024-04-28', '2024-04-28 15:30:00', 'Cape Town', 'ZAF', 'MEDICAL',
        'Infected insect bite requiring doctor visit and antibiotics',
        'Netcare Christiaan Barnard Memorial Hospital', NULL, NULL,
        520.00, 470.00, 50.00, '2024-06-18', 'PAID'),
    
    (43, 35, 10, '2024-09-16', '2024-09-16 12:45:00', 'Auckland', 'NZL', 'BAGGAGE',
        'Luggage delayed 36 hours, purchased essential items',
        NULL, NULL, NULL,
        580.00, 580.00, 0.00, NULL, 'APPROVED'),
    
    (44, 36, 10, '2025-01-22', '2025-01-22 10:20:00', 'Vancouver', 'CAN', 'MEDICAL',
        'Slipped on ice, back injury requiring chiropractic treatment',
        'Vancouver General Hospital', NULL, NULL,
        920.00, 870.00, 50.00, NULL, 'UNDER_REVIEW');


-- =========================================================
-- END OF TRAVEL INSURANCE DATA
-- =========================================================

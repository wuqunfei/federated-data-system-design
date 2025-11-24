-- =========================================================
-- TRAVEL INSURANCE - MySQL DML
-- Customer: Qunfei Wu (ID: 11)
-- =========================================================

-- =========================================================
-- 1. TRAVELER - Qunfei Wu
-- =========================================================
INSERT INTO travelers (traveler_id, first_name, middle_name, last_name, gender, date_of_birth,
    passport_number, passport_expiry_date, passport_issuing_country, dual_citizenship_country,
    email_primary, phone_mobile, home_address_street, home_address_city, home_address_state,
    home_address_zip, home_address_country, emergency_contact_name, emergency_contact_relation,
    emergency_contact_phone, medical_conditions_list, vaccination_record, loyalty_program_status,
    credit_risk_score, marketing_consent, created_at)
VALUES
    (11, 'Qunfei', NULL, 'Wu', 'Male', '1984-01-02',
        'C11H6JD47', '2028-06-15', 'Germany', NULL,
        'qunfei.wu@email.de', '+49 176 31088798', 'Sommerstraße 3', 'Munich', 'Bavaria',
        '81543', 'Germany', 'Wei Zhang', 'Friend', '+49 176 55443322',
        '[]', '{"COVID-19": "2023-10-12"}',
        '{"Lufthansa": "Frequent Traveller"}',
        715, TRUE, '2021-08-15 10:00:00');


-- =========================================================
-- 2. TRIPS - 3 Different Trips
-- =========================================================
INSERT INTO trips (trip_id, traveler_id, booking_reference_pnr, booking_date, travel_start_date,
    travel_end_date, trip_duration_days, days_until_travel, primary_destination_iso,
    primary_destination_city, layover_airport_codes, trip_type_category, accommodation_type,
    inbound_airline_code, inbound_flight_number, outbound_airline_code, outbound_flight_number,
    cruise_line_name, cruise_ship_name, total_trip_cost, non_refundable_cost, deposit_date)
VALUES
    -- Trip 1: Barcelona (Luggage Lost)
    (37, 11, 'QW23A1', '2023-04-20', '2023-06-10', '2023-06-17', 7, 51, 'ESP', 'Barcelona',
        '["FRA"]', 'LEISURE', 'HOTEL', 'LH', 'LH1130', 'LH', 'LH1131',
        NULL, NULL, 1850.00, 850.00, '2023-04-20'),
    
    -- Trip 2: Istanbul (Fever and Sick)
    (38, 11, 'QW24B2', '2024-02-10', '2024-04-15', '2024-04-22', 7, 65, 'TUR', 'Istanbul',
        '["MUC"]', 'LEISURE', 'HOTEL', 'TK', 'TK1634', 'TK', 'TK1635',
        NULL, NULL, 2200.00, 1100.00, '2024-02-10'),
    
    -- Trip 3: Bangkok (Flight Canceled)
    (39, 11, 'QW24C3', '2024-08-05', '2024-10-20', '2024-10-30', 10, 76, 'THA', 'Bangkok',
        '["FRA", "BKK"]', 'LEISURE', 'RESORT', 'TG', 'TG924', 'TG', 'TG925',
        NULL, NULL, 3800.00, 2000.00, '2024-08-05');


-- =========================================================
-- 3. POLICIES - 3 Travel Insurance Policies
-- =========================================================
INSERT INTO policies (policy_id, policy_number, trip_id, traveler_id, plan_name, plan_code,
    underwriter, coverage_limits_map, deductible_amount, rider_cancel_for_any_reason,
    rider_extreme_sports, rider_rental_car_collision, rider_pre_existing_waiver,
    net_premium, commission_amount, taxes_fees, total_premium_paid, currency_code,
    policy_status, bind_date)
VALUES
    -- Policy 1: Barcelona Trip
    (37, 'TRV-2023-037-QW', 37, 11, 'European Explorer', 'EU-BASIC', 'Allianz Global',
        '{"MedicalExpense": 100000, "TripCancellation": 850, "BaggageDelay": 500, "BaggageLoss": 2000, "EmergencyEvacuation": 50000}',
        100.00, FALSE, FALSE, FALSE, FALSE, 68.00, 12.20, 6.80, 87.00, 'EUR', 'CLOSED', '2023-04-20 15:30:00'),
    
    -- Policy 2: Istanbul Trip
    (38, 'TRV-2024-038-QW', 38, 11, 'European Deluxe', 'EU-DELUXE', 'Allianz Global',
        '{"MedicalExpense": 250000, "TripCancellation": 1100, "BaggageDelay": 1000, "TripInterruption": 1500, "EmergencyEvacuation": 100000}',
        50.00, TRUE, FALSE, FALSE, TRUE, 125.00, 22.50, 12.50, 160.00, 'EUR', 'CLOSED', '2024-02-10 11:20:00'),
    
    -- Policy 3: Bangkok Trip
    (39, 'TRV-2024-039-QW', 39, 11, 'Global Voyager', 'GLB-PREM', 'AXA Assistance',
        '{"MedicalExpense": 500000, "TripCancellation": 2000, "BaggageDelay": 2000, "TripDelay": 1500, "EmergencyEvacuation": 250000}',
        100.00, TRUE, FALSE, TRUE, TRUE, 250.00, 45.00, 25.00, 320.00, 'EUR', 'ACTIVE', '2024-08-05 14:15:00');


-- =========================================================
-- 4. CLAIMS - 3 Different Travel Claims
-- =========================================================
INSERT INTO claims (claim_id, policy_id, traveler_id, incident_date, incident_time,
    incident_location_city, incident_country_iso, loss_category, loss_description,
    treating_facility_name, police_report_number, airline_delay_reason,
    claimed_amount, approved_amount, denied_amount, payout_date, claim_status)
VALUES
    -- Claim 1: Luggage Lost in Barcelona
    (45, 37, 11, '2023-06-10', '2023-06-10 22:30:00', 'Barcelona', 'ESP', 'BAGGAGE',
        'Checked luggage was lost by airline during the flight from Frankfurt to Barcelona. Bag never arrived at destination and was not located after 7 days. Lost items included clothing, shoes, electronics (tablet, headphones), toiletries, and personal items. Had to purchase essential items for the entire trip.',
        NULL, NULL, NULL,
        1850.00, 1750.00, 100.00, '2023-07-25', 'PAID'),
    
    -- Claim 2: Fever and Sickness in Istanbul - Unable to Fly
    (46, 38, 11, '2024-04-18', '2024-04-18 06:00:00', 'Istanbul', 'TUR', 'MEDICAL',
        'Developed high fever (39.5°C), severe body aches, and respiratory symptoms 3 days before scheduled return flight. Visited hospital and was diagnosed with acute viral infection. Doctor advised against flying due to fever and risk of complications. Unable to board scheduled return flight. Required 3 additional nights of accommodation and had to book new flight 4 days later after recovery. Medical treatment included consultation, medication, and follow-up visit.',
        'American Hospital Istanbul', NULL, NULL,
        1680.00, 1630.00, 50.00, '2024-05-20', 'PAID'),
    
    -- Claim 3: Flight Canceled - No Flight for 5 Days in Bangkok
    (47, 39, 11, '2024-10-25', '2024-10-25 14:00:00', 'Bangkok', 'THA', 'DELAY',
        'Return flight TG925 to Frankfurt was canceled due to aircraft technical issues. Airline initially rebooked for next day but that flight was also canceled due to continued mechanical problems. Alternative flights were fully booked during peak season. Finally secured flight 5 days later. Incurred additional expenses: 5 nights extended hotel accommodation, meals, ground transportation, and communication costs to rearrange work schedule.',
        NULL, NULL, 'MECHANICAL',
        2850.00, 2750.00, 100.00, NULL, 'APPROVED');


-- =========================================================
-- END OF QUNFEI WU TRAVEL INSURANCE DATA
-- =========================================================

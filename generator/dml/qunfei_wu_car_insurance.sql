-- =========================================================
-- CAR INSURANCE - PostgreSQL DML
-- Customer: Qunfei Wu (ID: 11)
-- =========================================================

-- =========================================================
-- 1. CUSTOMER - Qunfei Wu
-- =========================================================
INSERT INTO customers (customer_id, first_name, last_name, dob, gender, email, phone_number, 
    address_street, address_city, address_state, address_zip, marital_status, education_level, 
    employment_status, annual_income, credit_tier, drivers_license_no, customer_since) 
VALUES
    (11, 'Qunfei', 'Wu', '1984-01-02', 'Male', 'qunfei.wu@email.de', '+49 176 31088798', 
        'Sommerstraße 3', 'Munich', 'Bavaria', '81543', 'Single', 'Masters', 
        'Employed', 68000, 'Good', 'B1122334455', '2021-08-15');


-- =========================================================
-- 2. POLICY - Active Car Insurance
-- =========================================================
INSERT INTO policies (policy_id, customer_id, policy_number, policy_type, start_date, end_date, premium_amount, is_active) 
VALUES
    (17, 11, 'CAR-2023-017-QW', 'Auto Comprehensive', '2023-01-10', '2024-01-09', 1120.00, FALSE),
    (18, 11, 'CAR-2024-018-QW', 'Auto Comprehensive', '2024-01-10', '2025-01-09', 1150.00, TRUE);


-- =========================================================
-- 3. VEHICLE - Audi A1
-- =========================================================
INSERT INTO vehicles (vehicle_id, policy_id, vin, make, model, year, plate_number) 
VALUES
    (17, 17, 'WAUZZZ8X1KA123456', 'Audi', 'A1', 2020, 'M-QW-2024'),
    (18, 18, 'WAUZZZ8X1KA123456', 'Audi', 'A1', 2020, 'M-QW-2024');


-- =========================================================
-- 4. CLAIM - One Incident in 2023
-- =========================================================
INSERT INTO claims (claim_id, policy_id, claim_date, description, claim_amount, status) 
VALUES
    (36, 17, '2023-06-18', 'Rear-end collision at traffic light. Rear bumper and tailgate damaged. Other driver admitted fault.', 
        2850.00, 'Settled');


-- =========================================================
-- 5. POLICY COVERAGES
-- =========================================================
INSERT INTO policy_coverages (coverage_id, policy_id, coverage_type, coverage_limit, deductible, is_optional, description) 
VALUES
    -- Current Policy Coverages
    (22, 18, 'Liability Coverage', 1000000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    (23, 18, 'Collision Coverage', 50000.00, 500.00, FALSE, 'Damage to vehicle from collision'),
    (24, 18, 'Comprehensive Coverage', 50000.00, 300.00, FALSE, 'Theft, vandalism, weather damage'),
    (25, 18, 'Personal Accident Insurance', 100000.00, 0.00, TRUE, 'Driver and passenger injury coverage');


-- =========================================================
-- END OF QUNFEI WU CAR INSURANCE DATA
-- =========================================================

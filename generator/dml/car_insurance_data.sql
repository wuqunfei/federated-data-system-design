-- =========================================================
-- CAR INSURANCE - PostgreSQL DML
-- 10 German Customers with Policies, Vehicles & Claims
-- =========================================================

-- =========================================================
-- 1. CUSTOMERS (10 German Customers)
-- =========================================================
INSERT INTO customers (customer_id, first_name, last_name, dob, gender, email, phone_number, 
    address_street, address_city, address_state, address_zip, marital_status, education_level, 
    employment_status, annual_income, credit_tier, drivers_license_no, customer_since) 
VALUES
    (1, 'Klaus', 'Müller', '1975-03-15', 'Male', 'klaus.mueller@email.de', '+49 30 12345678', 
        'Unter den Linden 25', 'Berlin', 'Berlin', '10117', 'Married', 'Masters', 
        'Employed', 75000, 'Good', 'B1234567890', '2015-06-12'),
    
    (2, 'Anna', 'Schmidt', '1982-07-22', 'Female', 'anna.schmidt@gmail.de', '+49 89 23456789', 
        'Maximilianstraße 43', 'Munich', 'Bavaria', '80539', 'Single', 'Bachelors', 
        'Employed', 65000, 'Excellent', 'B2345678901', '2017-02-18'),
    
    (3, 'Thomas', 'Weber', '1968-11-08', 'Male', 'thomas.weber@outlook.de', '+49 40 34567890', 
        'Reeperbahn 154', 'Hamburg', 'Hamburg', '20359', 'Married', 'PhD', 
        'Employed', 95000, 'Excellent', 'B3456789012', '2014-09-25'),
    
    (4, 'Sabine', 'Fischer', '1990-05-14', 'Female', 'sabine.fischer@web.de', '+49 221 45678901', 
        'Hohe Straße 87', 'Cologne', 'North Rhine-Westphalia', '50667', 'Single', 'Bachelors', 
        'Employed', 52000, 'Fair', 'B4567890123', '2018-11-03'),
    
    (5, 'Jürgen', 'Wagner', '1965-09-30', 'Male', 'juergen.wagner@t-online.de', '+49 69 56789012', 
        'Zeil 106', 'Frankfurt', 'Hesse', '60313', 'Married', 'Masters', 
        'Employed', 88000, 'Good', 'B5678901234', '2013-04-17'),
    
    (6, 'Petra', 'Becker', '1978-01-25', 'Female', 'petra.becker@gmx.de', '+49 711 67890123', 
        'Königstraße 1A', 'Stuttgart', 'Baden-Württemberg', '70173', 'Divorced', 'Bachelors', 
        'Employed', 58000, 'Good', 'B6789012345', '2016-08-09'),
    
    (7, 'Michael', 'Hoffmann', '1985-12-03', 'Male', 'michael.hoffmann@yahoo.de', '+49 351 78901234', 
        'Prager Straße 12', 'Dresden', 'Saxony', '01069', 'Married', 'Masters', 
        'Employed', 67000, 'Good', 'B7890123456', '2019-01-22'),
    
    (8, 'Stefanie', 'Koch', '1973-06-18', 'Female', 'stefanie.koch@mail.de', '+49 511 89012345', 
        'Karmarschstraße 46', 'Hanover', 'Lower Saxony', '30159', 'Married', 'Bachelors', 
        'Employed', 61000, 'Fair', 'B8901234567', '2015-12-14'),
    
    (9, 'Andreas', 'Richter', '1992-04-07', 'Male', 'andreas.richter@posteo.de', '+49 341 90123456', 
        'Grimmaische Straße 2-4', 'Leipzig', 'Saxony', '04109', 'Single', 'Bachelors', 
        'Employed', 48000, 'Fair', 'B9012345678', '2020-05-30'),
    
    (10, 'Martina', 'Schäfer', '1970-08-29', 'Female', 'martina.schaefer@freenet.de', '+49 421 01234567', 
        'Sögestraße 72', 'Bremen', 'Bremen', '28195', 'Widowed', 'Masters', 
        'Employed', 72000, 'Excellent', 'B0123456789', '2014-03-08');


-- =========================================================
-- 2. POLICIES (1-3 per customer)
-- =========================================================
INSERT INTO policies (policy_id, customer_id, policy_number, policy_type, start_date, end_date, premium_amount, is_active) 
VALUES
    -- Customer 1 (Klaus) - 2 policies
    (1, 1, 'CAR-2023-001-KM', 'Auto Comprehensive', '2023-01-15', '2024-01-14', 1250.00, TRUE),
    (2, 1, 'CAR-2024-002-KM', 'Auto Comprehensive', '2024-01-15', '2025-01-14', 1280.00, TRUE),
    
    -- Customer 2 (Anna) - 1 policy
    (3, 2, 'CAR-2023-003-AS', 'Auto Third Party', '2023-03-10', '2024-03-09', 850.00, TRUE),
    
    -- Customer 3 (Thomas) - 3 policies
    (4, 3, 'CAR-2022-004-TW', 'Auto Comprehensive', '2022-06-01', '2023-05-31', 1450.00, FALSE),
    (5, 3, 'CAR-2023-005-TW', 'Auto Comprehensive', '2023-06-01', '2024-05-31', 1500.00, FALSE),
    (6, 3, 'CAR-2024-006-TW', 'Auto Comprehensive', '2024-06-01', '2025-05-31', 1520.00, TRUE),
    
    -- Customer 4 (Sabine) - 1 policy
    (7, 4, 'CAR-2023-007-SF', 'Auto Third Party Plus', '2023-08-20', '2024-08-19', 920.00, TRUE),
    
    -- Customer 5 (Jürgen) - 2 policies
    (8, 5, 'CAR-2023-008-JW', 'Auto Comprehensive', '2023-02-12', '2024-02-11', 1350.00, FALSE),
    (9, 5, 'CAR-2024-009-JW', 'Auto Comprehensive', '2024-02-12', '2025-02-11', 1380.00, TRUE),
    
    -- Customer 6 (Petra) - 1 policy
    (10, 6, 'CAR-2024-010-PB', 'Auto Comprehensive', '2024-04-05', '2025-04-04', 1180.00, TRUE),
    
    -- Customer 7 (Michael) - 2 policies
    (11, 7, 'CAR-2023-011-MH', 'Auto Third Party Plus', '2023-09-15', '2024-09-14', 980.00, FALSE),
    (12, 7, 'CAR-2024-012-MH', 'Auto Comprehensive', '2024-09-15', '2025-09-14', 1220.00, TRUE),
    
    -- Customer 8 (Stefanie) - 1 policy
    (13, 8, 'CAR-2024-013-SK', 'Auto Comprehensive', '2024-01-08', '2025-01-07', 1150.00, TRUE),
    
    -- Customer 9 (Andreas) - 1 policy
    (14, 9, 'CAR-2024-014-AR', 'Auto Third Party', '2024-06-22', '2025-06-21', 780.00, TRUE),
    
    -- Customer 10 (Martina) - 2 policies
    (15, 10, 'CAR-2023-015-MS', 'Auto Comprehensive', '2023-05-11', '2024-05-10', 1300.00, FALSE),
    (16, 10, 'CAR-2024-016-MS', 'Auto Comprehensive', '2024-05-11', '2025-05-10', 1320.00, TRUE);


-- =========================================================
-- 3. VEHICLES (1-3 per active customer)
-- =========================================================
INSERT INTO vehicles (vehicle_id, policy_id, vin, make, model, year, plate_number) 
VALUES
    -- Customer 1 (Klaus) - 2 vehicles
    (1, 2, 'WBA1234567890ABCD', 'BMW', '3 Series', 2020, 'B-KM-1234'),
    (2, 2, 'WDB9876543210XYZA', 'Mercedes-Benz', 'C-Class', 2021, 'B-KM-5678'),
    
    -- Customer 2 (Anna) - 1 vehicle
    (3, 3, 'WVWZZZ1KZ5W123456', 'Volkswagen', 'Golf', 2022, 'M-AS-9012'),
    
    -- Customer 3 (Thomas) - 3 vehicles
    (4, 6, 'WAUZZZ4G1EN123456', 'Audi', 'A6', 2019, 'HH-TW-3456'),
    (5, 6, 'WBSDE9C57JMT34567', 'BMW', 'X5', 2022, 'HH-TW-7890'),
    (6, 6, 'WDD1234567890ABCD', 'Mercedes-Benz', 'E-Class', 2023, 'HH-TW-1122'),
    
    -- Customer 4 (Sabine) - 1 vehicle
    (7, 7, 'WVWZZZ5NZ6W234567', 'Volkswagen', 'Polo', 2020, 'K-SF-3344'),
    
    -- Customer 5 (Jürgen) - 2 vehicles
    (8, 9, 'WAU1234567890XYZA', 'Audi', 'Q5', 2021, 'F-JW-5566'),
    (9, 9, 'WP0ZZZ99ZTS345678', 'Porsche', '911', 2023, 'F-JW-7788'),
    
    -- Customer 6 (Petra) - 1 vehicle
    (10, 10, 'WBA5678901234ABCD', 'BMW', 'X3', 2022, 'S-PB-9900'),
    
    -- Customer 7 (Michael) - 2 vehicles
    (11, 12, 'WVWZZZ1KZ7W345678', 'Volkswagen', 'Passat', 2021, 'DD-MH-1212'),
    (12, 12, 'WAUDEH9F8KN456789', 'Audi', 'A4', 2023, 'DD-MH-3434'),
    
    -- Customer 8 (Stefanie) - 1 vehicle
    (13, 13, 'WDD2222222222ABCD', 'Mercedes-Benz', 'GLC', 2020, 'H-SK-5656'),
    
    -- Customer 9 (Andreas) - 1 vehicle
    (14, 14, 'WVWZZZ1KZ9W456789', 'Volkswagen', 'Tiguan', 2019, 'L-AR-7878'),
    
    -- Customer 10 (Martina) - 2 vehicles
    (15, 16, 'WAUZZZ8V1MA567890', 'Audi', 'Q7', 2020, 'HB-MS-9090'),
    (16, 16, 'WBA7890123456XYZA', 'BMW', '5 Series', 2022, 'HB-MS-1213');


-- =========================================================
-- 4. CLAIMS (1-10 per customer - various statuses)
-- =========================================================
INSERT INTO claims (claim_id, policy_id, claim_date, description, claim_amount, status) 
VALUES
    -- Customer 1 (Klaus) - 3 claims
    (1, 1, '2023-04-15', 'Minor collision in parking lot. Rear bumper damaged.', 1250.50, 'Settled'),
    (2, 1, '2023-08-22', 'Windshield cracked by stone on highway.', 385.00, 'Settled'),
    (3, 2, '2024-03-10', 'Side mirror damaged by vandalism.', 420.00, 'In Progress'),
    
    -- Customer 2 (Anna) - 2 claims
    (4, 3, '2023-06-18', 'Accident at intersection. Front end damage.', 2850.00, 'Settled'),
    (5, 3, '2024-01-25', 'Hailstorm damage to hood and roof.', 1680.00, 'Settled'),
    
    -- Customer 3 (Thomas) - 8 claims
    (6, 4, '2022-09-12', 'Theft of navigation system.', 980.00, 'Settled'),
    (7, 4, '2023-01-05', 'Hit and run - rear quarter panel.', 3200.00, 'Settled'),
    (8, 5, '2023-07-14', 'Flood damage from heavy rain.', 5400.00, 'Settled'),
    (9, 5, '2023-11-28', 'Animal collision on country road.', 2100.00, 'Settled'),
    (10, 6, '2024-02-08', 'Broken headlight assembly.', 680.00, 'Settled'),
    (11, 6, '2024-06-15', 'Scratches from parking garage incident.', 950.00, 'In Progress'),
    (12, 6, '2024-09-03', 'Front bumper damage from low-speed collision.', 1450.00, 'Open'),
    (13, 6, '2024-10-20', 'Window broken during attempted theft.', 520.00, 'Open'),
    
    -- Customer 4 (Sabine) - 1 claim
    (14, 7, '2024-02-14', 'Paint damage from shopping cart.', 340.00, 'Settled'),
    
    -- Customer 5 (Jürgen) - 5 claims
    (15, 8, '2023-05-22', 'Tire damage from pothole.', 420.00, 'Settled'),
    (16, 8, '2023-09-08', 'Door dent from adjacent vehicle.', 780.00, 'Settled'),
    (17, 9, '2024-04-12', 'Multiple panels damaged in accident.', 4500.00, 'Settled'),
    (18, 9, '2024-07-30', 'Windshield replacement.', 450.00, 'In Progress'),
    (19, 9, '2024-10-05', 'Rear-end collision at traffic light.', 2800.00, 'Open'),
    
    -- Customer 6 (Petra) - 2 claims
    (20, 10, '2024-06-08', 'Scratched paint on driver door.', 580.00, 'Settled'),
    (21, 10, '2024-09-18', 'Damaged wheel rim from curb impact.', 720.00, 'In Progress'),
    
    -- Customer 7 (Michael) - 4 claims
    (22, 11, '2023-11-15', 'Broken tail light.', 280.00, 'Settled'),
    (23, 11, '2024-02-28', 'Hood damage from fallen branch.', 1100.00, 'Settled'),
    (24, 12, '2024-10-10', 'Side panel scratch in parking lot.', 890.00, 'Open'),
    (25, 12, '2024-11-01', 'Front grille damage.', 650.00, 'Open'),
    
    -- Customer 8 (Stefanie) - 3 claims
    (26, 13, '2024-03-20', 'Windshield chip repair.', 120.00, 'Settled'),
    (27, 13, '2024-07-05', 'Door handle replacement.', 380.00, 'Settled'),
    (28, 13, '2024-10-15', 'Bumper scratch from parking.', 560.00, 'In Progress'),
    
    -- Customer 9 (Andreas) - 1 claim
    (29, 14, '2024-08-22', 'Third-party liability claim - damaged fence.', 1200.00, 'In Progress'),
    
    -- Customer 10 (Martina) - 6 claims
    (30, 15, '2023-07-10', 'Hail damage to multiple panels.', 3200.00, 'Settled'),
    (31, 15, '2023-11-05', 'Cracked side mirror.', 420.00, 'Settled'),
    (32, 16, '2024-06-15', 'Collision damage to front bumper.', 1850.00, 'Settled'),
    (33, 16, '2024-08-20', 'Stolen wheels and tires.', 2400.00, 'Settled'),
    (34, 16, '2024-09-30', 'Paint damage from bird droppings.', 280.00, 'In Progress'),
    (35, 16, '2024-11-10', 'Door dent from shopping cart.', 520.00, 'Open');


-- =========================================================
-- 5. POLICY COVERAGES (Sample coverages for policies)
-- =========================================================
INSERT INTO policy_coverages (coverage_id, policy_id, coverage_type, coverage_limit, deductible, is_optional, description) 
VALUES
    -- Policy 1 coverages
    (1, 1, 'Liability Coverage', 1000000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    (2, 1, 'Collision Coverage', 50000.00, 500.00, FALSE, 'Damage to vehicle from collision'),
    (3, 1, 'Comprehensive Coverage', 50000.00, 300.00, FALSE, 'Theft, vandalism, weather damage'),
    
    -- Policy 2 coverages
    (4, 2, 'Liability Coverage', 1000000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    (5, 2, 'Collision Coverage', 50000.00, 500.00, FALSE, 'Damage to vehicle from collision'),
    (6, 2, 'Comprehensive Coverage', 50000.00, 300.00, FALSE, 'Theft, vandalism, weather damage'),
    
    -- Policy 3 coverages
    (7, 3, 'Liability Coverage', 750000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    
    -- Policy 6 coverages
    (8, 6, 'Liability Coverage', 2000000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    (9, 6, 'Collision Coverage', 80000.00, 1000.00, FALSE, 'Damage to vehicle from collision'),
    (10, 6, 'Comprehensive Coverage', 80000.00, 500.00, FALSE, 'Theft, vandalism, weather damage'),
    (11, 6, 'Rental Reimbursement', 1500.00, 0.00, TRUE, 'Daily rental car during repairs'),
    
    -- Policy 9 coverages
    (12, 9, 'Liability Coverage', 1500000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    (13, 9, 'Collision Coverage', 60000.00, 750.00, FALSE, 'Damage to vehicle from collision'),
    (14, 9, 'Comprehensive Coverage', 60000.00, 400.00, FALSE, 'Theft, vandalism, weather damage'),
    
    -- Policy 12 coverages
    (15, 12, 'Liability Coverage', 1000000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    (16, 12, 'Collision Coverage', 55000.00, 500.00, FALSE, 'Damage to vehicle from collision'),
    (17, 12, 'Comprehensive Coverage', 55000.00, 350.00, FALSE, 'Theft, vandalism, weather damage'),
    
    -- Policy 16 coverages
    (18, 16, 'Liability Coverage', 1500000.00, 0.00, FALSE, 'Third-party bodily injury and property damage'),
    (19, 16, 'Collision Coverage', 70000.00, 800.00, FALSE, 'Damage to vehicle from collision'),
    (20, 16, 'Comprehensive Coverage', 70000.00, 450.00, FALSE, 'Theft, vandalism, weather damage'),
    (21, 16, 'Gap Insurance', 15000.00, 0.00, TRUE, 'Covers gap between value and loan amount');


-- =========================================================
-- END OF CAR INSURANCE DATA
-- =========================================================

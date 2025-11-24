INSTALL postgres;
LOAD postgres;
INSTALL snowflake;
LOAD snowflake;
INSTALL mysql;
LOAD mysql;



-- Replace with your actual passwords or use environment variables
-- Example: ATTACH 'postgres://avnadmin:${CAR_INSURANCE_PASSWORD}@customer-db-xllianz.e.aivencloud.com:26851/defaultdb' AS car_insurance (TYPE postgres, READ_ONLY);
-- Example: ATTACH 'host=travel-insurance-xllianz.c.aivencloud.com user=avnadmin port=26851 password=${TRAVEL_INSURANCE_PASSWORD} database=defaultdb' AS travel_insurance (TYPE mysql, READ_ONLY);

-- ATTACH 'postgres://avnadmin:YOUR_CAR_INSURANCE_PASSWORD@customer-db-xllianz.e.aivencloud.com:26851/defaultdb' AS car_insurance (TYPE postgres, READ_ONLY);
-- ATTACH 'host=travel-insurance-xllianz.c.aivencloud.com user=avnadmin port=26851 password=YOUR_TRAVEL_INSURANCE_PASSWORD database=defaultdb' AS travel_insurance (TYPE mysql, READ_ONLY);
-- CREATE SECRET my_snowflake (TYPE snowflake, ACCOUNT 'xhdfsdj-xg45373', USER 'qunfei', PASSWORD '2025@Munich@Darmstadt', DATABASE 'PC', WAREHOUSE  'COMPUTE_WH', SCHEMA 'HOUSE_INSURANCE');
-- ATTACH '' AS house_insurance (TYPE snowflake, SECRET my_snowflake, READ_ONLY);

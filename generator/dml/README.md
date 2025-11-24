# Insurance Customer 360 - Synthetic Data Documentation

## Overview
This package contains synthetic data for 10 German customers across three different insurance business lines, each stored in a different database platform:

1. **Car Insurance** - PostgreSQL
2. **House Insurance** - Snowflake
3. **Travel Insurance** - MySQL

All three databases share **consistent customer information** allowing for a unified customer 360 view.

---

## Customer Base
**10 German Customers** (IDs 1-10):
1. Klaus Müller (Berlin)
2. Anna Schmidt (Munich)
3. Thomas Weber (Hamburg)
4. Sabine Fischer (Cologne)
5. Jürgen Wagner (Frankfurt)
6. Petra Becker (Stuttgart)
7. Michael Hoffmann (Dresden)
8. Stefanie Koch (Hanover)
9. Andreas Richter (Leipzig)
10. Martina Schäfer (Bremen)

### Customer Characteristics:
- **Age Range**: 30-70 years (born 1954-1994)
- **Location**: Major German cities
- **Realistic Data**: German names, addresses, phone numbers, emails
- **Demographics**: Various marital statuses, education levels, occupations
- **Customer Since**: 2013-2020 (10+ years of history)

---

## Data Volume Summary

### Car Insurance (PostgreSQL)
- **Customers**: 10
- **Policies**: 16 (1-3 per customer)
- **Vehicles**: 16 (1-3 per customer)
- **Claims**: 35 (1-10 per customer)
- **Coverage Details**: 21 coverage records

### House Insurance (Snowflake)
- **Customers**: 10
- **Properties**: 16 (1-3 per customer)
- **Policies**: 28 (1-3 per property)
- **Claims**: 43 (1-10 per customer)

### Travel Insurance (MySQL)
- **Travelers**: 10
- **Trips**: 36 (1-5 per traveler)
- **Policies**: 36 (1 per trip)
- **Claims**: 44 (1-10 per traveler)

**Total Activity**: 122 claims, 80 policies, 52 insured items (vehicles, properties, trips)

---

## Common Customer Fields

### Consistent Across All Databases:
```
customer_id / traveler_id    : 1-10 (Primary Key)
first_name                    : e.g., "Klaus", "Anna"
last_name                     : e.g., "Müller", "Schmidt"
date_of_birth / dob          : e.g., "1975-03-15"
email / email_primary        : e.g., "klaus.mueller@email.de"
phone_mobile / phone_number  : e.g., "+49 30 12345678"
address information          : Street, City, State, ZIP
customer_since / customer_since_date : e.g., "2015-06-12"
```

---

## Sample Customer 360 Queries

### Example 1: Find Customer by Email
```sql
-- PostgreSQL (Car Insurance)
SELECT customer_id, first_name, last_name, email 
FROM customers 
WHERE email = 'klaus.mueller@email.de';

-- Snowflake (House Insurance)
SELECT customer_id, first_name, last_name, email 
FROM DIM_CUSTOMERS 
WHERE email = 'klaus.mueller@email.de';

-- MySQL (Travel Insurance)
SELECT traveler_id, first_name, last_name, email_primary 
FROM travelers 
WHERE email_primary = 'klaus.mueller@email.de';
```

### Example 2: Get All Activities for Customer ID 1 (Klaus Müller)

**Car Insurance (PostgreSQL):**
```sql
-- Get all car policies and claims
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    p.policy_number,
    p.policy_type,
    p.premium_amount,
    v.make,
    v.model,
    v.year,
    cl.claim_date,
    cl.description,
    cl.claim_amount,
    cl.status
FROM customers c
LEFT JOIN policies p ON c.customer_id = p.customer_id
LEFT JOIN vehicles v ON p.policy_id = v.policy_id
LEFT JOIN claims cl ON p.policy_id = cl.policy_id
WHERE c.customer_id = 1
ORDER BY p.start_date, cl.claim_date;
```

**House Insurance (Snowflake):**
```sql
-- Get all house policies and claims
SELECT 
    dc.customer_id,
    dc.first_name,
    dc.last_name,
    dp.address_street,
    dp.city,
    dp.year_built,
    fp.policy_number,
    fp.total_annual_premium,
    fp.policy_status,
    fc.date_of_loss,
    fc.cause_of_loss,
    fc.net_payout,
    fc.claim_status
FROM DIM_CUSTOMERS dc
LEFT JOIN DIM_PROPERTIES dp ON dc.customer_id = dp.customer_id
LEFT JOIN FACT_POLICIES fp ON dp.property_id = fp.property_id
LEFT JOIN FACT_CLAIMS fc ON fp.policy_id = fc.policy_id
WHERE dc.customer_id = 1
ORDER BY fp.effective_date, fc.date_of_loss;
```

**Travel Insurance (MySQL):**
```sql
-- Get all travel policies and claims
SELECT 
    t.traveler_id,
    t.first_name,
    t.last_name,
    tr.primary_destination_city,
    tr.primary_destination_iso,
    tr.travel_start_date,
    tr.travel_end_date,
    p.policy_number,
    p.total_premium_paid,
    p.policy_status,
    c.incident_date,
    c.loss_category,
    c.approved_amount,
    c.claim_status
FROM travelers t
LEFT JOIN trips tr ON t.traveler_id = tr.traveler_id
LEFT JOIN policies p ON tr.trip_id = p.trip_id
LEFT JOIN claims c ON p.policy_id = c.policy_id
WHERE t.traveler_id = 1
ORDER BY tr.travel_start_date, c.incident_date;
```

### Example 3: Customer 360 Summary (Cross-Database)

To create a complete customer 360 view, you would need to:
1. Query each database separately
2. Aggregate results in your application layer
3. Join by customer_id (same across all systems)

**Unified View Schema:**
```json
{
  "customer_id": 1,
  "name": "Klaus Müller",
  "email": "klaus.mueller@email.de",
  "phone": "+49 30 12345678",
  "address": "Unter den Linden 25, Berlin, 10117",
  "customer_since": "2015-06-12",
  
  "car_insurance": {
    "active_policies": 2,
    "vehicles": ["BMW 3 Series 2020", "Mercedes-Benz C-Class 2021"],
    "total_claims": 3,
    "lifetime_premium": 2530.00
  },
  
  "house_insurance": {
    "properties": 2,
    "active_policies": 2,
    "total_claims": 4,
    "lifetime_premium": 6625.00
  },
  
  "travel_insurance": {
    "trips_insured": 4,
    "destinations_visited": ["Barcelona", "Rome", "Athens", "Bangkok"],
    "total_claims": 4,
    "lifetime_premium": 773.50
  },
  
  "summary": {
    "total_policies": 8,
    "total_claims": 11,
    "lifetime_value": 9928.50,
    "risk_profile": "Medium"
  }
}
```

---

## Data Characteristics

### Time Periods:
- **Car Insurance**: 2022-2024 (policies), 2023-2024 (claims)
- **House Insurance**: 2022-2025 (policies), 2023-2025 (claims)
- **Travel Insurance**: 2023-2025 (trips), 2023-2025 (claims)

### Claim Statuses:
- **Car**: Settled, In Progress, Open
- **House**: CLOSED, OPEN
- **Travel**: PAID, APPROVED, UNDER_REVIEW

### Realistic Features:
✅ German names, addresses, cities
✅ Realistic phone numbers (+49 format)
✅ German email domains (.de)
✅ German vehicle license plates (e.g., B-KM-1234)
✅ Real car makes/models popular in Germany
✅ Realistic property values and construction details
✅ Real travel destinations and airlines
✅ Varied claim types and amounts
✅ Proper FK relationships maintained
✅ Mix of active and historical policies

---

## Database Connection Examples

### PostgreSQL (Car Insurance):
```bash
psql -h localhost -U postgres -d car_insurance -f car_insurance_data.sql
```

### Snowflake (House Insurance):
```sql
-- In Snowflake worksheet
USE DATABASE house_insurance;
USE SCHEMA public;
-- Execute house_insurance_data.sql
```

### MySQL (Travel Insurance):
```bash
mysql -u root -p < travel_insurance_data.sql
```

---

## Key Insights from the Data

### High-Value Customers (by total claims):
1. **Thomas Weber** (ID: 3): 27 total claims across all products
2. **Martina Schäfer** (ID: 10): 22 total claims
3. **Jürgen Wagner** (ID: 5): 17 total claims

### Multi-Product Customers:
- All 10 customers have at least 2 product types
- 8 customers have all 3 product types
- Customer retention is high (10+ years)

### Claim Patterns:
- **Car**: Highest frequency - minor accidents and cosmetic damage
- **House**: Medium frequency - weather damage and water backup common
- **Travel**: Lower frequency - medical emergencies and delays most common

---

## Usage Recommendations

### For Analytics:
1. Calculate customer lifetime value (CLV) across products
2. Identify cross-sell opportunities
3. Analyze claim patterns by customer demographics
4. Risk segmentation and pricing optimization

### For Development:
1. Test federated query engines (Trino, Presto)
2. Build customer 360 dashboards
3. Practice data integration patterns
4. Implement master data management (MDM)

### For Data Science:
1. Churn prediction models
2. Claim fraud detection
3. Next-best-offer recommendations
4. Customer segmentation

---

## Contact Information Format

All customers have complete contact information:
- **Email**: firstname.lastname@domain.de
- **Phone Mobile**: +49 (area code) (number)
- **Address**: Street number, City, State, ZIP

This allows testing of multi-channel communication strategies and contact preference management.

---

## Files Included

1. `car_insurance_data.sql` - PostgreSQL DML with 5 tables
2. `house_insurance_data.sql` - Snowflake DML with 4 tables
3. `travel_insurance_data.sql` - MySQL DML with 4 tables
4. `README.md` - This documentation file

---

## Notes

- All monetary amounts are in EUR
- Dates use ISO format (YYYY-MM-DD)
- Customer IDs are consistent across all three databases
- Foreign key constraints are respected
- Data is completely synthetic and safe for development/testing
- JSON fields in Snowflake and MySQL use proper JSON format

---

**Generated**: November 2024
**Purpose**: Insurance Customer 360 Testing & Development
**Data Quality**: Production-ready synthetic data

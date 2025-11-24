# Qunfei Wu - Customer 360 Profile

## Customer Information (ID: 11)

### Personal Details
- **Name**: Qunfei Wu
- **Date of Birth**: January 2, 1984 (Age: 40)
- **Gender**: Male
- **Occupation**: Engineer (Tech Industry)
- **Email**: qunfei.wu@email.de
- **Mobile**: +49 176 31088798

### Address
Sommerstraße 3  
81543 Munich, Bavaria  
Germany

### Customer Since
August 15, 2021 (3+ years)

---

## Insurance Portfolio Summary

### 1. Car Insurance (PostgreSQL)

**Vehicle**: Audi A1 (2020)
- **License Plate**: M-QW-2024
- **VIN**: WAUZZZ8X1KA123456

**Active Policy**: CAR-2024-018-QW
- **Type**: Auto Comprehensive
- **Period**: January 10, 2024 - January 9, 2025
- **Annual Premium**: €1,150.00
- **Coverage**:
  - Liability: €1,000,000
  - Collision: €50,000 (€500 deductible)
  - Comprehensive: €50,000 (€300 deductible)
  - Personal Accident Insurance: €100,000

**Claims History**:
1. **June 18, 2023** - Rear-end collision at traffic light
   - Description: Rear bumper and tailgate damaged. Other driver admitted fault.
   - Amount: €2,850.00
   - Status: **Settled**

---

### 2. House Insurance (Snowflake)

**Property**: Apartment in Munich
- **Address**: Sommerstraße 3, 81543 Munich
- **Type**: 2-bedroom apartment (3rd floor)
- **Year Built**: 2015
- **Living Area**: 950 sq ft
- **Plumbing**: PEX (modern plastic pipes)

**Active Policy**: HOME-2024-031-QW
- **Type**: HO-3 (Special Form)
- **Period**: September 1, 2024 - September 1, 2025
- **Annual Premium**: €1,290.00
- **Coverage**:
  - Dwelling: €250,000
  - Personal Property: €125,000
  - Liability: €300,000
  - Loss of Use: €50,000
  - Deductible: €1,000

**Claims History**:
1. **February 15, 2023** - Water pipeline burst
   - Description: Pipeline burst in bathroom wall causing extensive water damage to bathroom (floor, walls, ceiling) and living room below (hardwood floors and ceiling damaged). Required plumbing repairs and full restoration.
   - Building Damage: €6,800.00
   - Contents Damage: €2,400.00
   - Additional Living Expenses: €1,800.00
   - **Total Payout**: €10,950.00 (after €1,000 deductible)
   - Status: **Closed** (April 20, 2023)

---

### 3. Travel Insurance (MySQL)

**Total Trips Insured**: 3

#### Trip 1: Barcelona, Spain
- **Dates**: June 10-17, 2023 (7 days)
- **Policy**: TRV-2023-037-QW (European Explorer)
- **Premium**: €87.00
- **Claim**: **Luggage Lost**
  - Date: June 10, 2023
  - Description: Checked luggage lost by airline and never recovered. Lost clothing, electronics (tablet, headphones), toiletries, and personal items. Had to purchase essentials for entire trip.
  - Amount Claimed: €1,850.00
  - Amount Paid: €1,750.00
  - Status: **PAID** (July 25, 2023)

#### Trip 2: Istanbul, Turkey
- **Dates**: April 15-22, 2024 (7 days)
- **Policy**: TRV-2024-038-QW (European Deluxe)
- **Premium**: €160.00
- **Claim**: **Fever and Sickness - Unable to Fly**
  - Date: April 18, 2024
  - Description: Developed high fever (39.5°C) and acute viral infection 3 days before return flight. Doctor advised against flying. Unable to board scheduled flight. Required 3 additional nights accommodation and new flight 4 days later. Medical treatment included consultation, medication, and follow-up.
  - Medical Treatment: American Hospital Istanbul
  - Amount Claimed: €1,680.00
  - Amount Paid: €1,630.00
  - Status: **PAID** (May 20, 2024)

#### Trip 3: Bangkok, Thailand
- **Dates**: October 20-30, 2024 (10 days)
- **Policy**: TRV-2024-039-QW (Global Voyager)
- **Premium**: €320.00
- **Claim**: **Flight Canceled - 5 Days Delay**
  - Date: October 25, 2024
  - Description: Return flight TG925 canceled due to aircraft technical issues. Rebooked flight also canceled. Alternative flights fully booked. Finally secured flight 5 days later. Expenses: 5 nights extended hotel, meals, transportation, communication costs.
  - Delay Reason: Mechanical issues
  - Amount Claimed: €2,850.00
  - Amount Paid: €2,750.00
  - Status: **APPROVED** (payment pending)

---

## Financial Summary

### Total Premiums Paid (Lifetime)
- **Car Insurance**: €2,270.00 (2 years)
- **House Insurance**: €3,720.00 (3 years)
- **Travel Insurance**: €567.00 (3 policies)
- **TOTAL**: €6,557.00

### Total Claims Received
- **Car Insurance**: €2,850.00 (1 claim)
- **House Insurance**: €10,950.00 (1 claim)
- **Travel Insurance**: €6,130.00 (3 claims)
- **TOTAL**: €19,930.00

### Loss Ratio
- **Claims Received**: €19,930.00
- **Premiums Paid**: €6,557.00
- **Ratio**: 3.04:1 (High-risk customer profile)

---

## Risk Profile

### Observations
✅ **Active Customer**: All three insurance products with company  
✅ **Professional**: Engineer in tech industry, stable income  
✅ **Location**: Prime Munich location  
✅ **Modern Assets**: 2020 Audi A1, 2015 apartment  

⚠️ **High Claim Frequency**: 5 claims across 3 products in ~3 years  
⚠️ **Significant Water Damage**: Major plumbing issue (€10,950 payout)  
⚠️ **Travel Risk**: 100% claim rate on travel insurance (3/3 trips)  
⚠️ **Loss Ratio**: 3:1 - Significantly above industry average

### Risk Assessment
**Overall Rating**: **High Risk**

**Recommendations**:
1. Review property plumbing condition (recent PEX installation - modern but burst)
2. Consider travel insurance premium adjustments based on claim history
3. Monitor for additional claims patterns
4. Evaluate for potential fraud indicators (high claim frequency)
5. Customer may benefit from risk management counseling

### Positive Indicators
- Prompt reporting of all incidents
- Detailed documentation provided
- No disputes on claim settlements
- Maintains continuous coverage
- Professional with stable employment

---

## Customer 360 Query Examples

### Find Qunfei Wu by Email:
```sql
-- PostgreSQL
SELECT * FROM customers WHERE email = 'qunfei.wu@email.de';

-- Snowflake
SELECT * FROM DIM_CUSTOMERS WHERE email = 'qunfei.wu@email.de';

-- MySQL
SELECT * FROM travelers WHERE email_primary = 'qunfei.wu@email.de';
```

### Get All Claims for Customer ID 11:
```sql
-- Car Insurance (PostgreSQL)
SELECT c.claim_date, c.description, c.claim_amount, c.status
FROM claims c
JOIN policies p ON c.policy_id = p.policy_id
WHERE p.customer_id = 11;

-- House Insurance (Snowflake)
SELECT fc.date_of_loss, fc.cause_of_loss, fc.net_payout, fc.claim_status
FROM FACT_CLAIMS fc
JOIN FACT_POLICIES fp ON fc.policy_id = fp.policy_id
WHERE fp.customer_id = 11;

-- Travel Insurance (MySQL)
SELECT c.incident_date, c.loss_category, c.approved_amount, c.claim_status
FROM claims c
WHERE c.traveler_id = 11;
```

---

## Database Files

1. [qunfei_wu_car_insurance.sql](qunfei_wu_car_insurance.sql) - PostgreSQL
2. [qunfei_wu_house_insurance.sql](qunfei_wu_house_insurance.sql) - Snowflake
3. [qunfei_wu_travel_insurance.sql](qunfei_wu_travel_insurance.sql) - MySQL

---

**Generated**: November 2024  
**Customer ID**: 11  
**Status**: Active across all products

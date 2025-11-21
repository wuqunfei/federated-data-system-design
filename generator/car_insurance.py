import pandas as pd
import random
import datetime
from sqlalchemy import create_engine, text
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parents[1]))
from src.settings import AppSettings
from faker import Faker

# ==========================================
# 1. CONFIGURATION & CONSTANTS
# ==========================================
random.seed(42)


# The 10 Distinct Policy Types
POLICY_TYPES = [
    'PERSONAL_LIABILITY_BASIC', 'PERSONAL_COMPREHENSIVE', 'PERSONAL_COLLISION_PLUS',
    'COMMERCIAL_FLEET_SMALL', 'RIDESHARE_DRIVER_PRO', 'CLASSIC_COLLECTOR_AGREED',
    'TEEN_DRIVER_TRACKING', 'USAGE_BASED_PAY_PER_MILE', 'LUXURY_PERFORMANCE_ELITE',
    'SHORT_TERM_RENTAL_GAP'
]

CAR_MAKES = {
    'Toyota': ['Camry', 'Corolla', 'RAV4'],
    'Ford': ['F-150', 'Mustang', 'Explorer'],
    'Tesla': ['Model 3', 'Model Y', 'Model S'],
    'BMW': ['X5', '3 Series', 'M4'],
    'Honda': ['Civic', 'Accord', 'CR-V']
}

CREDIT_TIERS = ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent']
MARITAL_STATUS = ['Single', 'Married', 'Divorced', 'Widowed']
EDUCATION = ['High School', 'Associate', 'Bachelors', 'Masters', 'PhD']
EMPLOYMENT = ['Employed', 'Self-Employed', 'Retired']


# Helper for random dates
def random_date(start_year, end_year):
    start = datetime.date(start_year, 1, 1)
    end = datetime.date(end_year, 12, 31)
    return start + datetime.timedelta(days=random.randint(0, (end - start).days))


# ==========================================
# 2. DATA GENERATION FUNCTIONS
# ==========================================

class InsuranceDataGenerator:
    def __init__(self) -> None:
        self.faker = Faker('de_DE')
        self.faker.seed_instance(42)

    def generate(self):
        customer_rows = []
        for cust_id in range(1, 101):
            gender = random.choice(['Male', 'Female'])
            first_name = self.faker.first_name_male() if gender == 'Male' else self.faker.first_name_female()
            last_name = self.faker.last_name()
            email = f"{first_name.lower()}.{last_name.lower()}{cust_id}@example.com"
            dob = self.faker.date_between(start_date=datetime.date(1970, 1, 1), end_date=datetime.date(2000, 12, 31))
            street = self.faker.street_address()
            city = self.faker.city()
            try:
                state = self.faker.state()
            except Exception:
                state = 'DE'
            zip_code = self.faker.postcode()
            phone = self.faker.phone_number()
            if not phone.strip().startswith('+'):
                phone = f"+49 {phone}"
            marital = random.choice(MARITAL_STATUS)
            education = random.choice(EDUCATION)
            employment = random.choice(EMPLOYMENT)
            income = random.randint(30000, 150000)
            credit = random.choice(CREDIT_TIERS)
            dl = f"DE-{str(cust_id).zfill(8)}"
            customer_since = random_date(2018, 2023)

            customer_rows.append({
                'customer_id': cust_id,
                'first_name': first_name,
                'last_name': last_name,
                'gender': gender,
                'email': email,
                'phone_number': phone,
                'dob': dob,
                'address_street': street,
                'address_city': city,
                'address_state': state,
                'address_zip': zip_code,
                'marital_status': marital,
                'education_level': education,
                'employment_status': employment,
                'annual_income': income,
                'credit_tier': credit,
                'drivers_license_no': dl,
                'customer_since': customer_since
            })

        df_customers = pd.DataFrame(customer_rows)

        policy_rows = []
        pol_id = 1
        for _, row in df_customers.iterrows():
            cid = row['customer_id']
            credit = row['credit_tier']
            num_policies = 2 if random.random() < 0.4 else 1
            for i in range(num_policies):
                p_type = random.choice(POLICY_TYPES)
                base = random.randint(400, 1200)
                mult = 1.5 if credit == 'Poor' else (0.8 if credit == 'Excellent' else 1.0)
                policy_rows.append({
                    'policy_id': pol_id,
                    'customer_id': cid,
                    'policy_number': f"POL-{cid}-{chr(65 + i)}",
                    'policy_type': p_type,
                    'start_date': random_date(2022, 2023),
                    'end_date': random_date(2024, 2025),
                    'premium_amount': round(base * mult, 2),
                    'is_active': True
                })
                pol_id += 1

        df_policies = pd.DataFrame(policy_rows)

        vehicle_rows = []
        veh_id = 1
        for _, row in df_policies.iterrows():
            pid = row['policy_id']
            make = random.choice(list(CAR_MAKES.keys()))
            model = random.choice(CAR_MAKES[make])
            city_codes = ['B', 'M', 'S', 'K', 'F', 'HH', 'HB', 'D', 'N', 'DO', 'E', 'H', 'L']
            code = random.choice(city_codes)
            letters = ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=random.randint(1, 2)))
            digits = ''.join(random.choices('0123456789', k=random.randint(3, 4)))
            plate = f"{code}-{letters} {digits}"
            vehicle_rows.append({
                'vehicle_id': veh_id,
                'policy_id': pid,
                'vin': f"VIN{pid:010d}{random.choice(['X', 'Y', 'Z'])}",
                'make': make,
                'model': model,
                'year': random.randint(2005, 2024),
                'plate_number': plate
            })
            veh_id += 1

        df_vehicles = pd.DataFrame(vehicle_rows)

        claim_rows = []
        claim_id = 1
        risk_map = df_policies.merge(df_customers[['customer_id', 'credit_tier']], on='customer_id')
        statuses = ['PENDING', 'IN_REVIEW', 'APPROVED', 'PAID', 'DENIED', 'REOPENED']
        weights = [0.2, 0.2, 0.2, 0.25, 0.1, 0.05]
        descriptions = [
            'Rear-end collision', 'Side-swipe', 'Parking lot ding', 'Fender bender', 'Windshield crack',
            'Windshield replacement', 'Hail damage', 'Tree limb damage', 'Flood damage', 'Theft',
            'Attempted theft', 'Vandalism', 'Key scratch', 'Interior theft', 'Tire puncture',
            'Wheel damage', 'Engine failure', 'Transmission failure', 'Electrical short', 'Battery failure',
            'Animal strike', 'Deer collision', 'Bird strike', 'Hit and run', 'Single-vehicle rollover',
            'Multi-vehicle crash', 'Pothole damage', 'Road debris', 'Mirror broken', 'Headlight damage',
            'Taillight damage', 'Paint damage', 'Roof dent', 'Door dent', 'Bumper replacement',
            'Airbag deployment', 'Brake failure', 'Steering failure', 'Fire damage', 'Smoke damage',
            'Garage accident', 'Trailer damage', 'Tow reimbursement', 'Glass replacement', 'ADAS calibration',
            'Rental car coverage', 'Gap coverage payout', 'Medical payments', 'Personal injury',
            'Third-party property damage'
        ]
        for _, row in risk_map.iterrows():
            pid = row['policy_id']
            credit = row['credit_tier']
            max_claims = 5 if credit == 'Poor' else (3 if credit == 'Good' else 2)
            if random.random() < 0.60:
                count = random.randint(1, max_claims)
                for _ in range(count):
                    claim_rows.append({
                        'claim_id': claim_id,
                        'policy_id': pid,
                        'claim_date': random_date(2023, 2023),
                        'description': random.choice(descriptions),
                        'claim_amount': round(random.uniform(200, 5000), 2),
                        'status': random.choices(statuses, weights=weights, k=1)[0]
                    })
                    claim_id += 1
        while len(claim_rows) < 200:
            r = risk_map.sample(1).iloc[0]
            claim_rows.append({
                'claim_id': claim_id,
                'policy_id': int(r['policy_id']),
                'claim_date': random_date(2023, 2023),
                'description': random.choice(descriptions),
                'claim_amount': round(random.uniform(200, 5000), 2),
                'status': random.choices(statuses, weights=weights, k=1)[0]
            })
            claim_id += 1
        df_claims = pd.DataFrame(claim_rows)

        cov_rows = []
        cov_id = 1
        for _, row in df_policies.iterrows():
            pid = row['policy_id']
            ptype = row['policy_type']
            cov_rows.append({
                'coverage_id': cov_id, 'policy_id': pid,
                'coverage_type': 'Liability', 'coverage_limit': 250000.00,
                'deductible': 0.00, 'is_optional': False, 'description': 'Mandatory State Minimum'
            })
            cov_id += 1
            if 'LIABILITY' not in ptype:
                cov_rows.append({
                    'coverage_id': cov_id, 'policy_id': pid,
                    'coverage_type': 'Collision', 'coverage_limit': 50000.00,
                    'deductible': 500.00, 'is_optional': False, 'description': 'Accident Repairs'
                })
                cov_id += 1
            if 'RIDESHARE' in ptype:
                cov_rows.append({
                    'coverage_id': cov_id, 'policy_id': pid,
                    'coverage_type': 'Passenger Protection', 'coverage_limit': 1000000.00,
                    'deductible': 0.00, 'is_optional': True, 'description': 'Active Ride Coverage'
                })
                cov_id += 1
        df_coverages = pd.DataFrame(cov_rows)

        return df_customers, df_policies, df_vehicles, df_claims, df_coverages

class PostgresLoader:
    def __init__(self, settings: AppSettings) -> None:
        self.settings = settings
        self.engine = None

    def connect(self) -> bool:
        if self.settings.is_postgres_configured():
            db = self.settings.POSTGRES_DATABASE or "postgres"
            url = f"postgresql+psycopg2://{self.settings.POSTGRES_USERNAME}:{self.settings.POSTGRES_PASSWORD}@{self.settings.POSTGRES_HOST_PORT}/{db}"
            self.engine = create_engine(url, future=True, pool_pre_ping=True)
            return True
        return False

    def ping(self) -> None:
        with self.engine.connect() as conn:
            conn.execute(text("SELECT 1"))

    def load(self, dfs) -> None:
        df_cust, df_pol, df_veh, df_clm, df_cov = dfs
        with self.engine.begin() as conn:
            conn.execute(text("TRUNCATE TABLE policy_coverages, claims, vehicles, policies, customers RESTART IDENTITY CASCADE;"))
            df_cust.to_sql(name='customers', con=conn, if_exists='append', index=False, method='multi')
            df_pol.to_sql(name='policies', con=conn, if_exists='append', index=False, method='multi')
            df_veh.to_sql(name='vehicles', con=conn, if_exists='append', index=False, method='multi')
            df_clm.to_sql(name='claims', con=conn, if_exists='append', index=False, method='multi')
            df_cov.to_sql(name='policy_coverages', con=conn, if_exists='append', index=False, method='multi')
            conn.execute(text("SELECT setval('customers_customer_id_seq', (SELECT MAX(customer_id) FROM customers));"))
            conn.execute(text("SELECT setval('policies_policy_id_seq', (SELECT MAX(policy_id) FROM policies));"))
            conn.execute(text("SELECT setval('vehicles_vehicle_id_seq', (SELECT MAX(vehicle_id) FROM vehicles));"))
            conn.execute(text("SELECT setval('claims_claim_id_seq', (SELECT MAX(claim_id) FROM claims));"))
            conn.execute(text("SELECT setval('policy_coverages_coverage_id_seq', (SELECT MAX(coverage_id) FROM policy_coverages));"))


# ==========================================
# 3. SQL DML GENERATOR FUNCTION
# ==========================================

def df_to_sql_insert(df, table_name):
    """
    Converts a Pandas DataFrame into valid SQL INSERT statements.
    Handles strings, dates, nulls, and booleans.
    """
    sql_statements = []

    # Extract columns
    columns = ", ".join(df.columns)

    for _, row in df.iterrows():
        values = []
        for val in row:
            # Handle Data Types for SQL Syntax
            if pd.isna(val):
                values.append("NULL")
            elif isinstance(val, str):
                # Escape single quotes for SQL
                clean_str = val.replace("'", "''")
                values.append(f"'{clean_str}'")
            elif isinstance(val, (datetime.date, datetime.datetime)):
                values.append(f"'{val}'")
            elif isinstance(val, bool):
                values.append("TRUE" if val else "FALSE")
            else:
                # Numbers
                values.append(str(val))

        val_str = ", ".join(values)
        statement = f"INSERT INTO {table_name} ({columns}) VALUES ({val_str});"
        sql_statements.append(statement)

    return sql_statements


# ==========================================
# 4. MAIN EXECUTION
# ==========================================
if __name__ == "__main__":
    print("🚀 Starting Data Generation...")
    generator = InsuranceDataGenerator()
    df_cust, df_pol, df_veh, df_clm, df_cov = generator.generate()
    print(f"📊 Generated Stats:")
    print(f"   - Customers: {len(df_cust)}")
    print(f"   - Policies:  {len(df_pol)}")
    print(f"   - Vehicles:  {len(df_veh)}")
    print(f"   - Claims:    {len(df_clm)}")
    print(f"   - Coverages: {len(df_cov)}")
    settings = AppSettings()
    loader = PostgresLoader(settings)
    if loader.connect():
        loader.ping()
        print("✅ Database connection OK")
        loader.load((df_cust, df_pol, df_veh, df_clm, df_cov))
        print("✅ Transaction committed")

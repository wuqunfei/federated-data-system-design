import pandas as pd
import random
import datetime
from sqlalchemy import create_engine, text
import sys
from pathlib import Path
sys.path.append(str(Path(__file__).resolve().parents[1]))
from src.settings import AppSettings
from faker import Faker
from urllib.parse import quote_plus

random.seed(42)


MARITAL = ['MARRIED', 'SINGLE', 'WIDOWED']
GENDERS = ['Male', 'Female']
CONTACT_METHOD = ['EMAIL', 'SMS', 'MAIL']
INDUSTRY = ['TECH', 'CONSTRUCTION', 'MEDICAL', 'FINANCE', 'EDUCATION']
EDU = ['High School', 'Associate', 'Bachelors', 'Masters', 'PhD']
INCOME_BRACKET = ['<50k', '50k-100k', '100k-200k', '>200k']
CREDIT = ['POOR', 'FAIR', 'GOOD', 'EXCELLENT']

FOUNDATION = ['SLAB', 'BASEMENT', 'CRAWLSPACE']
ROOF = ['ASPHALT SHINGLE', 'METAL', 'TILE', 'SLATE']
WALL = ['VINYL', 'BRICK', 'STUCCO', 'WOOD']
HEATING = ['FORCED AIR', 'RADIANT', 'OIL', 'ELECTRIC']
PLUMBING = ['COPPER', 'PVC', 'GALVANIZED', 'PEX']
FLOOD = ['X', 'AE', 'VE']

POLICY_FORMS = ['HO-3 (Special)', 'HO-5 (Comprehensive)', 'DP-3 (Landlord)']
POLICY_STATUS = ['ACTIVE', 'CANCELLED', 'LAPSED']
CAUSES = ['WIND', 'HAIL', 'FIRE', 'THEFT', 'WATER_BACKUP']


def random_date(start_year, end_year):
    start = datetime.date(start_year, 1, 1)
    end = datetime.date(end_year, 12, 31)
    return start + datetime.timedelta(days=random.randint(0, (end - start).days))


class HouseDataGenerator:
    def __init__(self) -> None:
        self.faker = Faker('de_DE')
        self.faker.seed_instance(42)

    def generate(self):
        customers = []
        for cid in range(1, 101):
            gender = random.choice(GENDERS)
            first = self.faker.first_name_male() if gender == 'Male' else self.faker.first_name_female()
            last = self.faker.last_name()
            email = f"{first.lower()}.{last.lower()}{cid}@example.com"
            mobile = self.faker.phone_number()
            home = self.faker.phone_number()
            if not mobile.strip().startswith('+'):
                mobile = f"+49 {mobile}"
            if not home.strip().startswith('+'):
                home = f"+49 {home}"
            dob = self.faker.date_between(start_date=datetime.date(1970, 1, 1), end_date=datetime.date(2000, 12, 31))
            customers.append({
                'customer_id': cid,
                'first_name': first,
                'last_name': last,
                'email': email,
                'phone_mobile': mobile,
                'phone_home': home,
                'preferred_contact_method': random.choice(CONTACT_METHOD),
                'date_of_birth': dob,
                'marital_status': random.choice(MARITAL),
                'gender': gender,
                'occupation_industry': random.choice(INDUSTRY),
                'education_level': random.choice(EDU),
                'annual_income_bracket': random.choice(INCOME_BRACKET),
                'credit_score_tier': random.choice(CREDIT),
                'insurance_score': random.randint(300, 900),
                'has_prior_claims': random.random() < 0.3,
                'customer_since_date': random_date(2010, 2023),
                'last_updated': datetime.datetime.utcnow()
            })
        df_customers = pd.DataFrame(customers)

        properties = []
        policies = []
        claims = []
        prop_id = 1
        pol_id = 1
        claim_id = 1
        for _, c in df_customers.iterrows():
            num_props = random.randint(1, 3)
            for i in range(num_props):
                street = self.faker.street_address()
                city = self.faker.city()
                try:
                    state = self.faker.state()
                except Exception:
                    state = 'DE'
                zip_code = self.faker.postcode()
                county = self.faker.city()
                age_years = random.randint(1, 30)
                year_built = datetime.date.today().year - age_years
                sq_living = random.randint(500, 3000)
                sq_lot = random.randint(1000, 10000)
                stories = random.randint(1, 3)
                bedrooms = random.randint(1, 6)
                bathrooms = round(random.uniform(1.0, 3.5), 1)
                roof_year = year_built + random.randint(0, max(0, age_years - 1))
                lat = float(self.faker.latitude())
                lon = float(self.faker.longitude())
                protection = {
                    'alarm_monitored': random.random() < 0.5,
                    'sprinklers': random.random() < 0.2,
                    'deadbolts': True
                }
                hazards = {
                    'has_pool': random.random() < 0.2,
                    'has_trampoline': random.random() < 0.1,
                    'dog_breed': random.choice(['None', 'Mixed', 'Shepherd', 'Bulldog'])
                }
                properties.append({
                    'property_id': prop_id,
                    'customer_id': int(c['customer_id']),
                    'address_street': street,
                    'city': city,
                    'state': state,
                    'zip_code': zip_code,
                    'county': county,
                    'geo_location': f"{lat},{lon}",
                    'year_built': year_built,
                    'sq_ft_living': sq_living,
                    'sq_ft_lot': sq_lot,
                    'num_stories': stories,
                    'num_bedrooms': bedrooms,
                    'num_bathrooms': bathrooms,
                    'foundation_type': random.choice(FOUNDATION),
                    'roof_material': random.choice(ROOF),
                    'roof_install_year': roof_year,
                    'exterior_wall_type': random.choice(WALL),
                    'heating_system_type': random.choice(HEATING),
                    'plumbing_material': random.choice(PLUMBING),
                    'distance_to_fire_hydrant_feet': random.randint(10, 500),
                    'distance_to_fire_station_miles': round(random.uniform(0.1, 10.0), 2),
                    'distance_to_coast_miles': round(random.uniform(0.0, 100.0), 2),
                    'flood_zone_code': random.choice(FLOOD),
                    'protection_devices': pd.Series([protection]).to_json(orient='records')[1:-1],
                    'property_hazards': pd.Series([hazards]).to_json(orient='records')[1:-1],
                })

                eff = random_date(2022, 2024)
                exp = eff + datetime.timedelta(days=365)
                cov_a = random.randint(150000, 800000)
                cov_b = round(cov_a * 0.1, 2)
                cov_c = round(cov_a * 0.5, 2)
                cov_d = round(cov_a * 0.2, 2)
                cov_e = 300000.00
                cov_f = 5000.00
                ded_all = random.choice([500.00, 1000.00, 2500.00])
                ded_wind = random.choice([0.01, 0.02, 0.05])
                premium = round(cov_a * 0.008 + (0 if c['credit_score_tier'] == 'EXCELLENT' else 150), 2)
                status = random.choices(POLICY_STATUS, weights=[0.85, 0.1, 0.05], k=1)[0]
                policies.append({
                    'policy_id': pol_id,
                    'policy_number': f"HOP-{int(c['customer_id'])}-{prop_id}",
                    'customer_id': int(c['customer_id']),
                    'property_id': prop_id,
                    'policy_form_type': random.choice(POLICY_FORMS),
                    'effective_date': eff,
                    'expiration_date': exp,
                    'term_months': 12,
                    'coverage_a_dwelling': float(cov_a),
                    'coverage_b_other_structures': float(cov_b),
                    'coverage_c_personal_property': float(cov_c),
                    'coverage_d_loss_of_use': float(cov_d),
                    'coverage_e_liability': float(cov_e),
                    'coverage_f_med_pay': float(cov_f),
                    'deductible_all_peril': float(ded_all),
                    'deductible_wind_hail_pct': float(ded_wind),
                    'total_annual_premium': float(premium),
                    'policy_status': status
                })

                claim_events = random.randint(0, 10)
                for _ in range(claim_events):
                    loss = random_date(2019, 2024)
                    reported = loss + datetime.timedelta(days=random.randint(0, 7))
                    closed = reported + datetime.timedelta(days=random.randint(7, 60)) if random.random() < 0.7 else None
                    amt_building = round(random.uniform(0, 30000), 2)
                    amt_contents = round(random.uniform(0, 15000), 2)
                    amt_ale = round(random.uniform(0, 8000), 2)
                    expenses = round(random.uniform(0, 3000), 2)
                    deductible = random.choice([500.00, 1000.00, 2500.00])
                    net = max(0.0, amt_building + amt_contents + amt_ale + expenses - deductible)
                    claims.append({
                        'claim_id': claim_id,
                        'policy_id': pol_id,
                        'date_of_loss': loss,
                        'date_reported': reported,
                        'date_closed': closed,
                        'cause_of_loss': random.choice(CAUSES),
                        'catastrophe_code': random.choice(['', 'STORM2023', 'FLOOD2022', 'WIND2021']),
                        'description': self.faker.sentence(nb_words=8),
                        'amount_paid_building': float(amt_building),
                        'amount_paid_contents': float(amt_contents),
                        'amount_paid_ale': float(amt_ale),
                        'expenses_paid': float(expenses),
                        'deductible_applied': float(deductible),
                        'net_payout': float(net),
                        'claim_status': random.choice(['OPEN', 'CLOSED', 'DENIED', 'IN_REVIEW'])
                    })
                    claim_id += 1

                prop_id += 1
                pol_id += 1

        df_properties = pd.DataFrame(properties)
        df_policies = pd.DataFrame(policies)
        df_claims = pd.DataFrame(claims)
        return df_customers, df_properties, df_policies, df_claims


class SnowflakeLoader:
    def __init__(self, settings: AppSettings) -> None:
        self.settings = settings
        self.engine = None

    def connect(self) -> bool:
        if self.settings.is_snowflake_configured():
            account = self.settings.SNOWFLAKE_ACCOUNT_ID
            user = self.settings.SNOWFLAKE_USERNAME
            pwd = quote_plus(self.settings.SNOWFLAKE_PASSWORD or "")
            role = self.settings.SNOWFLAKE_ROLE
            wh = self.settings.SNOWFLAKE_WAREHOUSE
            url = f"snowflake://{user}:{pwd}@{account}/PC/HOUSE_INSURANCE?role={role}&warehouse={wh}"
            self.engine = create_engine(url, future=True, pool_pre_ping=True)
            return True
        return False

    def ping(self) -> None:
        with self.engine.connect() as conn:
            conn.execute(text("SELECT 1"))

    def load(self, dfs) -> None:
        df_cust, df_props, df_pols, df_clms = dfs
        with self.engine.begin() as conn:
            conn.execute(text("CREATE DATABASE IF NOT EXISTS PC"))
            conn.execute(text("CREATE SCHEMA IF NOT EXISTS PC.HOUSE_INSURANCE"))
            conn.execute(text("USE DATABASE PC"))
            conn.execute(text("USE SCHEMA HOUSE_INSURANCE"))
            conn.execute(text("DROP TABLE IF EXISTS DIM_CUSTOMERS"))
            conn.execute(text("DROP TABLE IF EXISTS DIM_PROPERTIES"))
            conn.execute(text("DROP TABLE IF EXISTS FACT_POLICIES"))
            conn.execute(text("DROP TABLE IF EXISTS FACT_CLAIMS"))
            df_cust.to_sql(name='DIM_CUSTOMERS', con=conn, if_exists='append', index=False, method='multi')
            df_props.to_sql(name='DIM_PROPERTIES', con=conn, if_exists='append', index=False, method='multi')
            df_pols.to_sql(name='FACT_POLICIES', con=conn, if_exists='append', index=False, method='multi')
            df_clms.to_sql(name='FACT_CLAIMS', con=conn, if_exists='append', index=False, method='multi')


if __name__ == "__main__":
    print("🚀 Starting House Insurance Data Generation...")
    gen = HouseDataGenerator()
    df_cust, df_props, df_pols, df_clms = gen.generate()
    print("📊 Generated Stats:")
    print(f"   - Customers: {len(df_cust)}")
    print(f"   - Properties: {len(df_props)}")
    print(f"   - Policies:   {len(df_pols)}")
    print(f"   - Claims:     {len(df_clms)}")
    settings = AppSettings()
    loader = SnowflakeLoader(settings)
    if loader.connect():
        loader.ping()
        print("✅ Database connection OK")
        loader.load((df_cust, df_props, df_pols, df_clms))
        print("✅ Data loaded to Snowflake (PC.HOUSE_INSURANCE)")

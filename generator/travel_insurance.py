import datetime
import random
import sys
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text

sys.path.append(str(Path(__file__).resolve().parents[1]))
from src.settings import AppSettings
from faker import Faker
from databricks.sdk import WorkspaceClient
import os
from databricks import sql as dbsql

random.seed(42)


REGIONS = {
    'EU': {'countries': ['DE', 'FR', 'ES', 'IT', 'NL', 'SE', 'PL', 'PT', 'GR'], 'risk': 0.10},
    'US': {'countries': ['US'], 'risk': 0.15},
    'ASIA': {'countries': ['JP', 'CN', 'SG', 'TH', 'VN', 'KR', 'IN'], 'risk': 0.18},
    'AFRICA': {'countries': ['ZA', 'EG', 'NG', 'KE', 'MA', 'TZ'], 'risk': 0.25},
    'SA': {'countries': ['BR', 'AR', 'CL', 'CO', 'PE'], 'risk': 0.22},
    'OCEANIA': {'countries': ['AU', 'NZ'], 'risk': 0.12},
    'ME': {'countries': ['AE', 'SA', 'QA', 'OM', 'IL'], 'risk': 0.20},
}

LOSS_CATEGORIES = ['MEDICAL', 'DELAY', 'BAGGAGE']
AIRLINES = ['LH', 'AF', 'BA', 'DL', 'UA', 'EK', 'QR', 'QF', 'SQ', 'JL']
BOOKING_CHANNELS = ['Expedia', 'Direct', 'CorporateAgent', 'Aggregator']
ACCOMMODATIONS = ['HOTEL', 'AIRBNB', 'FRIENDS_FAMILY', 'RESORT']


def random_date(start_year, end_year):
    start = datetime.date(start_year, 1, 1)
    end = datetime.date(end_year, 12, 31)
    return start + datetime.timedelta(days=random.randint(0, (end - start).days))


class TravelDataGenerator:
    def __init__(self) -> None:
        self.faker = Faker('de_DE')
        self.faker.seed_instance(42)

    def generate(self):
        travelers = []
        trips = []
        policies = []
        claims = []

        for tid in range(1, 101):
            gender = random.choice(['Male', 'Female'])
            first = self.faker.first_name_male() if gender == 'Male' else self.faker.first_name_female()
            middle = ''
            last = self.faker.last_name()
            dob = self.faker.date_between(start_date=datetime.date(1970, 1, 1), end_date=datetime.date(2000, 12, 31))
            passport_num = f"DE{tid:08d}{random.choice(['X','Y','Z'])}"
            passport_exp = random_date(2026, 2032)
            email = f"{first.lower()}.{last.lower()}{tid}@example.com"
            mobile = self.faker.phone_number()
            if not mobile.strip().startswith('+'):
                mobile = f"+49 {mobile}"
            street = self.faker.street_address()
            city = self.faker.city()
            try:
                state = self.faker.state()
            except Exception:
                state = 'DE'
            zip_code = self.faker.postcode()

            travelers.append({
                'traveler_id': tid,
                'first_name': first,
                'middle_name': middle,
                'last_name': last,
                'gender': gender,
                'date_of_birth': dob,
                'passport_number': passport_num,
                'passport_expiry_date': passport_exp,
                'passport_issuing_country': 'DE',
                'dual_citizenship_country': None,
                'email_primary': email,
                'phone_mobile': mobile,
                'home_address_street': street,
                'home_address_city': city,
                'home_address_state': state,
                'home_address_zip': zip_code,
                'home_address_country': 'DE',
                'emergency_contact_name': f"{self.faker.first_name()} {self.faker.last_name()}",
                'emergency_contact_relation': random.choice(['Parent', 'Sibling', 'Spouse', 'Friend']),
                'emergency_contact_phone': f"+49 {self.faker.msisdn()}",
                'medical_conditions_list': pd.Series([[random.choice(['Asthma', 'Diabetes', 'None'])]]).to_json(orient='records')[1:-1],
                'vaccination_record': pd.Series([{'YellowFever': '2020-01-01', 'COVID19': '2021-03-01'}]).to_json(orient='records')[1:-1],
                'loyalty_program_status': pd.Series([{'Lufthansa': random.choice(['Silver','Gold','Senator']), 'Marriott': random.choice(['None','Gold','Titanium'])}]).to_json(orient='records')[1:-1],
                'credit_risk_score': random.randint(300, 850),
                'marketing_consent': random.random() < 0.8,
                'created_at': datetime.datetime.utcnow(),
                'updated_at': datetime.datetime.utcnow()
            })

            num_trips = random.randint(1, 10)
            for _ in range(num_trips):
                # choose region and destination
                region = random.choice(list(REGIONS.keys()))
                country = random.choice(REGIONS[region]['countries'])
                dest_city = self.faker.city()
                booking_date = random_date(datetime.date.today().year - 10, datetime.date.today().year)
                start_date = booking_date + datetime.timedelta(days=random.randint(7, 120))
                duration = random.randint(3, 21)
                end_date = start_date + datetime.timedelta(days=duration)
                days_until_travel = (start_date - booking_date).days
                trip_id = int(f"{tid}{start_date.strftime('%y%m%d')}{random.randint(10,99)}")

                trips.append({
                    'trip_id': trip_id,
                    'traveler_id': tid,
                    'booking_reference_pnr': self.faker.bothify(text='????##'),
                    'booking_date': booking_date,
                    'booking_channel': random.choice(BOOKING_CHANNELS),
                    'travel_agency_name': random.choice(['TUI', 'DER', 'HRS', 'Kayak']),
                    'travel_start_date': start_date,
                    'travel_end_date': end_date,
                    'trip_duration_days': duration,
                    'days_until_travel': days_until_travel,
                    'primary_destination_iso': country,
                    'primary_destination_city': dest_city,
                    'layover_airport_codes': pd.Series([[random.choice(['LHR','DXB','SIN','IST','CDG','FRA'])]]).to_json(orient='records')[1:-1],
                    'trip_type_category': random.choice(['LEISURE','BUSINESS','CRUISE']),
                    'accommodation_type': random.choice(ACCOMMODATIONS),
                    'inbound_airline_code': random.choice(AIRLINES),
                    'inbound_flight_number': self.faker.bothify(text='####'),
                    'outbound_airline_code': random.choice(AIRLINES),
                    'outbound_flight_number': self.faker.bothify(text='####'),
                    'cruise_line_name': '',
                    'cruise_ship_name': '',
                    'total_trip_cost': round(random.uniform(500, 10000), 2),
                    'non_refundable_cost': round(random.uniform(200, 5000), 2),
                    'deposit_date': booking_date,
                })

                policy_id = int(f"{trip_id}{random.randint(100,999)}")
                coverage_map = {
                    'Medical': round(random.uniform(50000, 200000), 2),
                    'Evac': round(random.uniform(200000, 500000), 2),
                    'Baggage': round(random.uniform(1000, 5000), 2)
                }
                net_prem = round(random.uniform(50, 400), 2)
                commission = round(net_prem * 0.15, 2)
                taxes = round(net_prem * 0.19, 2)
                total_paid = round(net_prem + commission + taxes, 2)
                policies.append({
                    'policy_id': policy_id,
                    'policy_number': f"TRV-{tid}-{trip_id}",
                    'trip_id': trip_id,
                    'traveler_id': tid,
                    'plan_name': random.choice(['Global Voyager','Cruise Defender','Business Shield']),
                    'plan_code': random.choice(['GV-01','CD-03','BS-07']),
                    'underwriter': random.choice(['MunichRe','Allianz','AXA']),
                    'coverage_limits_map': pd.Series([coverage_map]).to_json(orient='records')[1:-1],
                    'deductible_amount': round(random.choice([0, 50.0, 100.0, 250.0]), 2),
                    'rider_cancel_for_any_reason': random.random() < 0.2,
                    'rider_extreme_sports': random.random() < 0.1,
                    'rider_rental_car_collision': random.random() < 0.3,
                    'rider_pre_existing_waiver': random.random() < 0.15,
                    'net_premium': net_prem,
                    'commission_amount': commission,
                    'taxes_fees': taxes,
                    'total_premium_paid': total_paid,
                    'currency_code': random.choice(['EUR','USD','GBP']),
                    'policy_status': random.choice(['ACTIVE','CANCELLED','LAPSED']),
                    'bind_date': datetime.datetime.utcnow()
                })

                # regional risk affects loss category and probability
                base_risk = REGIONS[region]['risk']
                num_claims = random.randint(0, 3) if base_risk < 0.15 else random.randint(1, 5)
                for _ in range(num_claims):
                    incident_date = start_date + datetime.timedelta(days=random.randint(0, duration))
                    incident_time = datetime.datetime.combine(incident_date, datetime.time(hour=random.randint(0, 23), minute=random.randint(0, 59)))
                    loss_weights = [0.5 * base_risk + 0.2, 0.3 * base_risk + 0.1, 0.2 * base_risk + 0.1]
                    category = random.choices(LOSS_CATEGORIES, weights=loss_weights, k=1)[0]
                    claimed = round(random.uniform(50, 5000), 2)
                    approved = round(claimed * random.uniform(0.5, 1.0), 2)
                    denied = round(claimed - approved, 2)
                    claims.append({
                        'claim_id': int(f"{policy_id}{random.randint(1000,9999)}"),
                        'policy_id': policy_id,
                        'traveler_id': tid,
                        'incident_date': incident_date,
                        'incident_time': incident_time,
                        'incident_location_city': dest_city,
                        'incident_country_iso': country,
                        'loss_category': category,
                        'loss_description': self.faker.sentence(nb_words=10),
                        'treating_facility_name': self.faker.company(),
                        'police_report_number': self.faker.bothify(text='POL-####-????'),
                        'airline_delay_reason': random.choice(['WEATHER','MECHANICAL','STRIKE','']),
                        'claimed_amount': claimed,
                        'approved_amount': approved,
                        'denied_amount': denied,
                        'payout_date': incident_date + datetime.timedelta(days=random.randint(1, 45)),
                        'claim_status': random.choice(['OPEN','CLOSED','DENIED','IN_REVIEW'])
                    })

        df_travelers = pd.DataFrame(travelers)
        df_trips = pd.DataFrame(trips)
        df_policies = pd.DataFrame(policies)
        df_claims = pd.DataFrame(claims)
        return df_travelers, df_trips, df_policies, df_claims


class DatabricksLoader:
    def __init__(self, settings: AppSettings, workspace_id: str, schema: str, catalog: str = "workspace") -> None:
        self.settings = settings
        self.workspace_id = workspace_id
        self.schema = schema
        self.catalog = catalog
        self.engine = None

    def connect(self) -> bool:
        wc = WorkspaceClient(host=self.settings.DATABRICKS_WORKSPACE_URL, token=os.environ.get("DATABRICKS_TOKEN") or (self.settings.DATABRICKS_TOKEN or ""))
        endpoints = list(wc.warehouses.list())
        if not endpoints:
            return False
        ep = endpoints[0]
        odbc = ep.odbc_params
        host = (getattr(odbc, 'hostname', None) or self.settings.DATABRICKS_WORKSPACE_URL).replace('https://', '').replace('http://', '').strip('/')
        http_path = getattr(odbc, 'path', None)
        token = os.environ.get("DATABRICKS_TOKEN") or (self.settings.DATABRICKS_TOKEN or "")
        if not http_path:
            return False
        try:
            url = f"databricks+connector://token:{token}@{host}/?http_path={http_path}&catalog={self.catalog}&schema={self.schema}"
            self.engine = create_engine(url, future=True, pool_pre_ping=True)
            with self.engine.connect() as conn:
                conn.execute(text("SELECT 1"))
                conn.execute(text(f"USE CATALOG {self.catalog}"))
                conn.execute(text(f"USE SCHEMA {self.schema}"))
            return True
        except Exception:
            try:
                self.engine = create_engine(
                    "databricks+connector://",
                    future=True,
                    pool_pre_ping=True,
                    creator=lambda: dbsql.connect(server_hostname=host, http_path=http_path, access_token=token),
                )
                with self.engine.connect() as conn:
                    conn.execute(text("SELECT 1"))
                    conn.execute(text(f"USE CATALOG {self.catalog}"))
                    conn.execute(text(f"USE SCHEMA {self.schema}"))
                return True
            except Exception:
                return False

    def load(self, dfs) -> None:
        df_travelers, df_trips, df_policies, df_claims = dfs
        with self.engine.connect() as conn:
            conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {self.schema}"))
            conn.execute(text(f"USE SCHEMA {self.schema}"))
            conn.execute(text("CREATE TABLE IF NOT EXISTS travelers (\n                traveler_id INT, first_name STRING, middle_name STRING, last_name STRING, gender STRING, date_of_birth DATE,\n                passport_number STRING, passport_expiry_date DATE, passport_issuing_country STRING, dual_citizenship_country STRING,\n                email_primary STRING, phone_mobile STRING, home_address_street STRING, home_address_city STRING, home_address_state STRING, home_address_zip STRING, home_address_country STRING,\n                emergency_contact_name STRING, emergency_contact_relation STRING, emergency_contact_phone STRING,\n                medical_conditions_list STRING, vaccination_record STRING, loyalty_program_status STRING,\n                credit_risk_score INT, marketing_consent BOOLEAN, created_at TIMESTAMP, updated_at TIMESTAMP\n            ) USING DELTA"))
            conn.execute(text("CREATE TABLE IF NOT EXISTS trips (\n                trip_id BIGINT, traveler_id INT, booking_reference_pnr STRING, booking_date DATE, booking_channel STRING, travel_agency_name STRING,\n                travel_start_date DATE, travel_end_date DATE, trip_duration_days INT, days_until_travel INT,\n                primary_destination_iso STRING, primary_destination_city STRING, layover_airport_codes STRING,\n                trip_type_category STRING, accommodation_type STRING,\n                inbound_airline_code STRING, inbound_flight_number STRING, outbound_airline_code STRING, outbound_flight_number STRING,\n                cruise_line_name STRING, cruise_ship_name STRING, total_trip_cost DOUBLE, non_refundable_cost DOUBLE, deposit_date DATE\n            ) USING DELTA"))
            conn.execute(text("CREATE TABLE IF NOT EXISTS policies (\n                policy_id BIGINT, policy_number STRING, trip_id BIGINT, traveler_id INT,\n                plan_name STRING, plan_code STRING, underwriter STRING,\n                coverage_limits_map STRING, deductible_amount DOUBLE,\n                rider_cancel_for_any_reason BOOLEAN, rider_extreme_sports BOOLEAN, rider_rental_car_collision BOOLEAN, rider_pre_existing_waiver BOOLEAN,\n                net_premium DOUBLE, commission_amount DOUBLE, taxes_fees DOUBLE, total_premium_paid DOUBLE, currency_code STRING,\n                policy_status STRING, bind_date TIMESTAMP\n            ) USING DELTA"))
            conn.execute(text("CREATE TABLE IF NOT EXISTS claims (\n                claim_id BIGINT, policy_id BIGINT, traveler_id INT,\n                incident_date DATE, incident_time TIMESTAMP, incident_location_city STRING, incident_country_iso STRING,\n                loss_category STRING, loss_description STRING, treating_facility_name STRING, police_report_number STRING, airline_delay_reason STRING,\n                claimed_amount DOUBLE, approved_amount DOUBLE, denied_amount DOUBLE, payout_date DATE,\n                claim_status STRING\n            ) USING DELTA"))
            self._bulk_insert(conn, 'travelers', df_travelers)
            self._bulk_insert(conn, 'trips', df_trips)
            self._bulk_insert(conn, 'policies', df_policies)
            self._bulk_insert(conn, 'claims', df_claims)

    def _bulk_insert(self, conn, table, df: pd.DataFrame, chunk_size: int = 1000) -> None:
        cols = list(df.columns)
        placeholders = ", ".join([f":{c}" for c in cols])
        col_sql = ", ".join(cols)
        stmt = text(f"INSERT INTO {table} ({col_sql}) VALUES ({placeholders})")
        records = df.to_dict(orient='records')
        for i in range(0, len(records), chunk_size):
            batch = records[i:i+chunk_size]
            conn.execution_options(autocommit=True).execute(stmt, batch)


if __name__ == "__main__":
    print("🚀 Starting Travel Insurance Data Generation...")
    gen = TravelDataGenerator()
    df_travelers, df_trips, df_policies, df_claims = gen.generate()
    print("📊 Generated Stats:")
    print(f"   - Travelers: {len(df_travelers)}")
    print(f"   - Trips:     {len(df_trips)}")
    print(f"   - Policies:  {len(df_policies)}")
    print(f"   - Claims:    {len(df_claims)}")
    settings = AppSettings()
    if os.getenv("DEBUG_DATABRICKS") == "1":
        try:
            wc = WorkspaceClient(host=settings.DATABRICKS_WORKSPACE_URL, token=os.environ.get("DATABRICKS_TOKEN") or settings.DATABRICKS_TOKEN)
            warehouses = list(wc.warehouses.list())
            print(f"🔎 Warehouses: {[(w.id, getattr(w, 'name', None)) for w in warehouses]}")
            if warehouses:
                w = warehouses[0]
                odbc = w.odbc_params
                print(f"🔎 ODBC Host: {getattr(odbc, 'hostname', None)}")
                print(f"🔎 ODBC Path: {getattr(odbc, 'path', None)}")
        except Exception as e:
            print(f"⚠️ Debug listing failed: {e}")
    loader = DatabricksLoader(settings, workspace_id="207211962589279", schema="travel_insurance", catalog="workspace")
    if loader.connect():
        print("✅ Databricks connection OK")
        loader.load((df_travelers, df_trips, df_policies, df_claims))
        print("✅ Data loaded to Databricks schema 'travel_insurance'")
    else:
        print("⚠️ Databricks connection failed. Please provide SQL Warehouse HTTP Path.")

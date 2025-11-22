from faker import Faker
import random
from datetime import datetime, timedelta
from pyspark.sql import Row
from pyspark.sql.types import (
    StructType, StructField, IntegerType, StringType, DateType, BooleanType, FloatType, TimestampType
)

fake = Faker('de_DE')
num_travelers = 100
traveler_rows = []
trip_rows = []
policy_rows = []
claim_rows = []

traveler_schema = StructType([
    StructField('traveler_id', IntegerType(), False),
    StructField('first_name', StringType(), True),
    StructField('middle_name', StringType(), True),
    StructField('last_name', StringType(), True),
    StructField('gender', StringType(), True),
    StructField('date_of_birth', DateType(), True),
    StructField('passport_number', StringType(), True),
    StructField('passport_expiry_date', DateType(), True),
    StructField('passport_issuing_country', StringType(), True),
    StructField('dual_citizenship_country', StringType(), True),
    StructField('email_primary', StringType(), True),
    StructField('phone_mobile', StringType(), True),
    StructField('home_address_street', StringType(), True),
    StructField('home_address_city', StringType(), True),
    StructField('home_address_state', StringType(), True),
    StructField('home_address_zip', StringType(), True),
    StructField('home_address_country', StringType(), True),
    StructField('emergency_contact_name', StringType(), True),
    StructField('emergency_contact_relation', StringType(), True),
    StructField('emergency_contact_phone', StringType(), True),
    StructField('medical_conditions_list', StringType(), True),
    StructField('vaccination_record', StringType(), True),
    StructField('loyalty_program_status', StringType(), True),
    StructField('credit_risk_score', IntegerType(), True),
    StructField('marketing_consent', BooleanType(), True),
    StructField('created_at', TimestampType(), True),
    StructField('updated_at', TimestampType(), True)
])

trip_schema = StructType([
    StructField('trip_id', StringType(), False),
    StructField('traveler_id', IntegerType(), False),
    StructField('booking_reference_pnr', StringType(), True),
    StructField('booking_date', DateType(), True),
    StructField('booking_channel', StringType(), True),
    StructField('travel_agency_name', StringType(), True),
    StructField('travel_start_date', DateType(), True),
    StructField('travel_end_date', DateType(), True),
    StructField('trip_duration_days', IntegerType(), True),
    StructField('days_until_travel', IntegerType(), True),
    StructField('primary_destination_iso', StringType(), True),
    StructField('primary_destination_city', StringType(), True),
    StructField('layover_airport_codes', StringType(), True),
    StructField('trip_type_category', StringType(), True),
    StructField('accommodation_type', StringType(), True),
    StructField('inbound_airline_code', StringType(), True),
    StructField('inbound_flight_number', StringType(), True),
    StructField('outbound_airline_code', StringType(), True),
    StructField('outbound_flight_number', StringType(), True),
    StructField('cruise_line_name', StringType(), True),
    StructField('cruise_ship_name', StringType(), True),
    StructField('total_trip_cost', IntegerType(), True),
    StructField('non_refundable_cost', IntegerType(), True),
    StructField('deposit_date', DateType(), True)
])

policy_schema = StructType([
    StructField('policy_id', StringType(), False),
    StructField('policy_number', StringType(), True),
    StructField('trip_id', StringType(), False),
    StructField('traveler_id', IntegerType(), False),
    StructField('plan_name', StringType(), True),
    StructField('plan_code', StringType(), True),
    StructField('underwriter', StringType(), True),
    StructField('coverage_limits_map', StringType(), True),
    StructField('deductible_amount', IntegerType(), True),
    StructField('rider_cancel_for_any_reason', BooleanType(), True),
    StructField('rider_extreme_sports', BooleanType(), True),
    StructField('rider_rental_car_collision', BooleanType(), True),
    StructField('rider_pre_existing_waiver', BooleanType(), True),
    StructField('net_premium', IntegerType(), True),
    StructField('commission_amount', IntegerType(), True),
    StructField('taxes_fees', IntegerType(), True),
    StructField('total_premium_paid', IntegerType(), True),
    StructField('currency_code', StringType(), True),
    StructField('policy_status', StringType(), True),
    StructField('bind_date', DateType(), True)
])

claim_schema = StructType([
    StructField('claim_id', StringType(), False),
    StructField('policy_id', StringType(), False),
    StructField('traveler_id', IntegerType(), False),
    StructField('incident_date', DateType(), True),
    StructField('incident_time', StringType(), True),
    StructField('incident_location_city', StringType(), True),
    StructField('incident_country_iso', StringType(), True),
    StructField('loss_category', StringType(), True),
    StructField('loss_description', StringType(), True),
    StructField('treating_facility_name', StringType(), True),
    StructField('police_report_number', StringType(), True),
    StructField('airline_delay_reason', StringType(), True),
    StructField('claimed_amount', IntegerType(), True),
    StructField('approved_amount', IntegerType(), True),
    StructField('denied_amount', IntegerType(), True),
    StructField('payout_date', DateType(), True),
    StructField('claim_status', StringType(), True)
])

for traveler_id in range(1, num_travelers + 1):
    traveler = (
        traveler_id,
        fake.first_name(),
        fake.first_name(),
        fake.last_name(),
        random.choice(['M', 'F']),
        fake.date_of_birth(minimum_age=18, maximum_age=80),
        fake.passport_number(),
        fake.date_between(start_date='today', end_date='+10y'),
        'DE',
        None,
        fake.email(),
        fake.phone_number(),
        fake.street_address(),
        fake.city(),
        fake.state(),
        fake.postcode(),
        'DE',
        fake.name(),
        random.choice(['Friend', 'Parent', 'Sibling']),
        fake.phone_number(),
        None,
        None,
        random.choice(['None', 'Silver', 'Gold']),
        random.randint(300, 850),
        random.choice([True, False]),
        datetime.now(),
        datetime.now()
    )
    traveler_rows.append(traveler)

    num_trips = random.randint(1, 10)
    for trip_num in range(num_trips):
        trip_id = f"{traveler_id}_{trip_num+1}"
        travel_start = fake.date_between(start_date='-10y', end_date='today')
        travel_end = travel_start + timedelta(days=random.randint(1, 30))
        trip = (
            trip_id,
            traveler_id,
            fake.bothify(text='PNR#######'),
            travel_start - timedelta(days=random.randint(1, 60)),
            random.choice(['Online', 'Agency']),
            fake.company(),
            travel_start,
            travel_end,
            (travel_end - travel_start).days,
            random.randint(0, 365),
            'DE',
            fake.city(),
            None,
            random.choice(['Business', 'Leisure']),
            random.choice(['Hotel', 'Hostel', 'Apartment']),
            fake.lexify(text='??'),
            fake.numerify(text='####'),
            fake.lexify(text='??'),
            fake.numerify(text='####'),
            None,
            None,
            random.randint(500, 5000),
            random.randint(100, 1000),
            travel_start - timedelta(days=random.randint(1, 30))
        )
        trip_rows.append(trip)

        policy_id = f"{trip_id}_policy"
        policy = (
            policy_id,
            fake.bothify(text='POL#######'),
            trip_id,
            traveler_id,
            random.choice(['Basic', 'Premium', 'Family']),
            fake.bothify(text='PLN###'),
            fake.company(),
            str({'medical': random.randint(10000, 50000), 'baggage': random.randint(1000, 5000)}),
            random.randint(0, 500),
            random.choice([True, False]),
            random.choice([True, False]),
            random.choice([True, False]),
            random.choice([True, False]),
            random.randint(50, 500),
            random.randint(5, 50),
            random.randint(5, 50),
            random.randint(60, 600),
            'EUR',
            random.choice(['Active', 'Expired', 'Cancelled']),
            travel_start - timedelta(days=random.randint(1, 60))
        )
        policy_rows.append(policy)

        claim = (
            f"{trip_id}_claim",
            policy_id,
            traveler_id,
            travel_start + timedelta(days=random.randint(0, (travel_end - travel_start).days)),
            fake.time(),
            trip[11],
            'DE',
            random.choice(['Medical', 'Delay', 'Lost Luggage']),
            fake.sentence(),
            fake.company(),
            fake.bothify(text='PR####'),
            random.choice(['Weather', 'Technical', 'Other']),
            random.randint(100, 2000),
            random.randint(0, 2000),
            random.randint(0, 2000),
            travel_end + timedelta(days=random.randint(1, 30)),
            random.choice(['Approved', 'Denied', 'Pending'])
        )
        claim_rows.append(claim)

travelers_df = spark.createDataFrame(traveler_rows, schema=traveler_schema)
trips_df = spark.createDataFrame(trip_rows, schema=trip_schema)
policies_df = spark.createDataFrame(policy_rows, schema=policy_schema)
claims_df = spark.createDataFrame(claim_rows, schema=claim_schema)

display(travelers_df)
display(trips_df)
display(policies_df)
display(claims_df)
import random
from datetime import date, datetime
from hashlib import md5
import json
import pprint

from uszipcode import SearchEngine
from faker import Faker
import barnum
import ndjson
import boto3

# Using a seed keeps the data consistent from one run of the program to the next
# Delete the seed for truly random data
seed = 0
random.seed(seed)
Faker.seed(seed)
fake = Faker()
pp = pprint.PrettyPrinter(indent=4)

session = boto3.Session(profile_name='vrLab')
fh_client = session.client('firehose', 'us-east-2')

zip_search = SearchEngine(simple_zipcode=True) # set simple_zipcode=False to use rich info database


def generate_patients(qty):
    patients = []

    for generate_index, patient in enumerate(range(qty)):
        patient = fake.profile()
        patient_id = random.randint(4000, 6000)
        del patient['company']
        del patient['job']
        del patient['website']
        del patient['address']
        del patient['current_location']

        patient['patient_id'] = patient_id

        birth_date = fake.date_between(start_date='-80y', end_date='-25y')
        patient['age'] = date.today().year - birth_date.year
        patient['birthdate'] = birth_date.strftime('%Y-%m-%d')
        patient['condition'] = 'normal'

        string_to_hash = f'{patient["ssn"]}|{patient["mail"]}'
        patient['patient_id_hash'] = md5(string_to_hash.encode()).hexdigest()
        patient['index'] = generate_index + 1

        street = patient['residence'].split('\n')[0]
        zip_city_state = barnum.create_city_state_zip()
        zip_string = zip_city_state[0]
        residence = f'{street}\n{zip_city_state[1]}, {zip_city_state[2]}  {zip_string}'
        zip_info = zip_search.by_zipcode(zip_string)
        while (zip_info.lat is None) or (zip_info.lng is None):
            zip_city_state = barnum.create_city_state_zip()
            zip_string = zip_city_state[0]
            residence = f'{street}\n{zip_city_state[1]}, {zip_city_state[2]}  {zip_string}'
            zip_info = zip_search.by_zipcode(zip_string)

        patient['residence'] = residence
        patient['location'] = f'{zip_info.lat},{zip_info.lng}'

        patients.append(patient)

    return patients


def generate_bp_systolic(condition):
    """
        if condition == 'high_bp':
            return a random number between 135 and 180
        else:
            return a random number between 110 and 134
    """
    if condition == 'high_bp':
        return random.randint(135, 180)
    else:
        return random.randint(110, 134)


def generate_bp_diastolic(systolic):
    """
        generate a random number between 500 and 800
        return systolic * rnd_number/1000

    """
    diastolic_ratio = random.randint(500, 750)/1000
    diastolic = int(systolic * diastolic_ratio)
    return diastolic


def generate_temperature(condition):
    """
        if condition == 'high_temp':
            return a random number between 991 and 1025
        else:
            return a random number between 960 and 990
    """
    if condition == 'high_temp':
        return random.randint(991, 1025)
    else:
        return random.randint(960, 990)


def generate_pulse():
    """
        return a random number between 50 and 100
    """
    return random.randint(50, 99)


def generate_respiration():
    """
        return a random number between 12 and 20
    """
    return random.randint(12, 20)


def generate_oxy_sat(condition):
    """
        if condition == 'low_oxy':
            return a random number between 850 and 949
        else:
            return a random number between 950 and 999
    """
    if condition == 'low_oxy':
        return random.randint(850, 949)
    else:
        return random.randint(950, 999)


def generate_vital_signs(this_date, this_hour, condition, init_observation):
    """
        For a given hour (Used to setup the timestamp) condition and patient_id_hash, generate:
            BP - Blood Pressure
            BT - Body Temperature
            HR - Heart Rate
            RR - Respiration Rate
            O2 = Oxygen Saturation (95 - 100 is normal. Below 90 => Low)
    """
    timestamp = datetime(this_date.year, this_date.month, this_date.day, this_hour, random.randint(0, 59),
                         random.randint(0, 59))

    bp_systolic = generate_bp_systolic(condition)

    # "timestamp": "2016-12-15T11:34:10.000"
    formatted_timestamp = timestamp.isoformat()

    this_observation = {
        'timestamp': formatted_timestamp,
        'bp_systolic': bp_systolic,
        'bp_diastolic': generate_bp_diastolic(bp_systolic),
        'temperature': generate_temperature(condition),
        'pulse': generate_pulse(),
        'respiration': generate_respiration(),
        'oxy_sat': generate_oxy_sat(condition),
    }

    for key in init_observation:
        this_observation[key] = init_observation[key]

    return this_observation


def generate_data():
    num_patients = 100
    fake_date = date(2020, 5, 16)
    fake_patients = generate_patients(num_patients)
    print('Fake Patient: ', fake_patients[99])

    # Set high_bp patients
    high_bp_index = random.sample(range(0, 99), 30)
    for index in high_bp_index:
        fake_patients[index]['condition'] = 'high_bp'

    # Set high_temp patients
    high_temp_index = random.sample(range(0, 99), 10)
    for index in high_temp_index:
        fake_patients[index]['condition'] = 'high_temp'

    # Set low_oxy patients
    low_oxy_index = random.sample(range(0, 99), 10)
    for index in low_oxy_index:
        fake_patients[index]['condition'] = 'low_oxy'

    observations = []
    for hour in range(0, 24):
        for patient_index, fake_patient in enumerate(fake_patients):
            # pp.pprint(fake_patient)
            base_observation = {
                'patient_id_hash': fake_patient['patient_id_hash'],
                'location': fake_patient['location'],
            }
            observation = generate_vital_signs(fake_date, hour, fake_patient['condition'],
                                               base_observation)

            observations.append(observation)

        print(f'{hour} done for {patient_index}')

    # print(observations)

    with open('patients.ndjson', 'w') as f:
        ndjson.dump(fake_patients, f)

    with open('observations.ndjson', 'w') as f:
        ndjson.dump(observations, f)

    for index, observation in enumerate(observations):
        response = fh_client.put_record(
            DeliveryStreamName='wonderband',
            Record={
                'Data': json.dumps(observation).encode('utf-8')
            }
        )
        print(index + 1)


if __name__ == "__main__":
    generate_data()
    print('>>> Success <<<')

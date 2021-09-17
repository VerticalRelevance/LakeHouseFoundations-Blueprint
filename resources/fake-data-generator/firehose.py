import json
import boto3

session = boto3.Session(profile_name='plu')
fh_client = session.client('firehose', 'us-east-1')

# ndjson_data = generated_fake_data

for data_point in ndjson_data:
    response = fh_client.put_record(
        DeliveryStreamName='wonderband',
        Record={
            'Data': json.dumps(data_point).encode('utf-8')
        }
    )

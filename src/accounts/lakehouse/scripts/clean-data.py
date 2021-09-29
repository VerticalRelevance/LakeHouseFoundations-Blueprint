import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.context import GlueContext
from awsglue.job import Job

## @params: [JOB_NAME]
args = getResolvedOptions(
    sys.argv, 
    [
        'JOB_NAME',
        'source_bucket_uri',
        'target_bucket_uri'
    ]
)

sourceBucketUri=args['source_bucket_uri']
targetBucketUri=args['target_bucket_uri']

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
## @type: DataSource
## @args: [format_options = {"jsonPath":"","multiline":False}, connection_type = "s3", format = "json", connection_options = {"paths": ["s3://dev-lakehouse-lh-s3-raw/"], "recurse":True}, transformation_ctx = "DataSource0"]
## @return: DataSource0
## @inputs: []
print('Pulling datasource from s3 location: ' + sourceBucketUri)
DataSource0 = glueContext.create_dynamic_frame.from_options(format_options = {"jsonPath":"","multiline":False}, connection_type = "s3", format = "json", connection_options = {"paths": [sourceBucketUri], "recurse":True}, transformation_ctx = "DataSource0")
## @type: ApplyMapping
## @args: [mappings = [("Name", "string", "Name", "string"), ("Contact", "int", "Contact", "int"), ("Phone", "string", "Phone", "string"), ("SS", "string", "SS", "string")], transformation_ctx = "Transform0"]
## @return: Transform0
## @inputs: [frame = DataSource0]
Transform0 = ApplyMapping.apply(frame = DataSource0, mappings = [("Name", "string", "Name", "string"), ("Contact", "int", "Contact", "int"), ("Phone", "string", "Phone", "string"), ("SS", "string", "SS", "string")], transformation_ctx = "Transform0")
## @type: DataSink
## @args: [connection_type = "s3", format = "json", connection_options = {"path": "s3://dev-lakehouse-lh-s3-transformed/", "partitionKeys": []}, transformation_ctx = "DataSink0"]
## @return: DataSink0
## @inputs: [frame = Transform0]
print("Writing data to target location: " + targetBucketUri)
DataSink0 = glueContext.write_dynamic_frame.from_options(frame = DynamicFrame.fromDF(Transform0.toDF().distinct(), glueContext, "unique"), connection_type = "s3", format = "json", connection_options = {"path": targetBucketUri, "partitionKeys": []}, transformation_ctx = "DataSink0")
job.commit()
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
## @type: DataSource
## @args: [format_options = {"jsonPath":"","multiline":False}, connection_type = "s3", format = "json", connection_options = {"paths": ["s3://dev-lakehouse-lh-s3-raw/"], "recurse":True}, transformation_ctx = "DataSource0"]
## @return: DataSource0
## @inputs: []
DataSource0 = glueContext.create_dynamic_frame.from_options(format_options = {"jsonPath":"","multiline":False}, connection_type = "s3", format = "json", connection_options = {"paths": ["s3://dev-lakehouse-lz-main-lz-bucket"], "recurse":True}, transformation_ctx = "DataSource0")
## @type: ApplyMapping
## @args: [mappings = [("Name", "string", "Name", "string"), ("Contact", "int", "Contact", "int"), ("Phone", "string", "Phone", "string"), ("SS", "string", "SS", "string")], transformation_ctx = "Transform0"]
## @return: Transform0
## @inputs: [frame = DataSource0]
Transform0 = ApplyMapping.apply(frame = DataSource0, mappings = [("Name", "string", "Name", "string"), ("Contact", "int", "Contact", "int"), ("Phone", "string", "Phone", "string"), ("SS", "string", "SS", "string")], transformation_ctx = "Transform0")
## @type: DataSink
## @args: [connection_type = "s3", format = "json", connection_options = {"path": "s3://dev-lakehouse-lh-s3-transformed/", "partitionKeys": []}, transformation_ctx = "DataSink0"]
## @return: DataSink0
## @inputs: [frame = Transform0]
DataSink0 = glueContext.write_dynamic_frame.from_options(frame = Transform0, connection_type = "s3", format = "json", connection_options = {"path": "s3://dev-lakehouse-lh-s3-raw/", "partitionKeys": []}, transformation_ctx = "DataSink0")
job.commit()
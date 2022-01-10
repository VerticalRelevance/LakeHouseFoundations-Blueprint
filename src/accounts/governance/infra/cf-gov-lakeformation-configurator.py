

import json
import os

# Set up logging
import logging

from botocore.retryhandler import ExceptionRaiser
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Import Boto 3 for AWS Lake Formation
import boto3
lfClient = boto3.client('lakeformation')

def initiate_lf_config(event, context):
    logger.info('## INITIATED BY EVENT: ' + json.dumps(event))
    # Variables for the job:
    jEvent = json.loads(json.dumps(event))

    logger.info("To be completed...")

    return true
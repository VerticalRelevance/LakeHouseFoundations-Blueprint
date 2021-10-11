

import json
import os

# Set up logging
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Import Boto 3 for AWS Glue
import boto3
glueClient = boto3.client('glue')


# Define Lambda function
def initiate_workflow(event, context):
    logger.info('## INITIATED BY EVENT: ')
    logger.info(json.dumps(event))
    
    # Variables for the job:
    glueWorkflowName=""
    jEvent = json.loads(json.dumps(event))
    glueWorkflowName = jEvent['LzGlueWorkflowName']

    logger.info("GlueWorkflowName is: " + str(glueWorkflowName))
    response = glueClient.start_workflow_run(Name=glueWorkflowName)
    logger.info('## STARTED GLUE WORKFLOW: ' + str(glueWorkflowName))
    logger.info('## GLUE JOB WORKFLOW ID: ' + json.dumps(response))
    response['LzGlueWorkflowName'] = str(glueWorkflowName)

    return response

def get_workflow_state(event, context):
    logger.info('## INITIATED BY EVENT: ')
    logger.info(json.dumps(event))
    
    # Variables for the job: 
    glueWorkflowName=""
    jEvent = json.loads(json.dumps(event))
    glueWorkflowName = jEvent['Payload']['LzGlueWorkflowName']
    glueWorkflowRunId = jEvent['Payload']['RunId']
    logger.info("GlueWorkflowName is: " + str(glueWorkflowName) + ", RunId is: " + glueWorkflowRunId)

    response = glueClient.get_workflow_run(Name=glueWorkflowName, RunId=glueWorkflowRunId)
    logger.info('## GLUE Workflow: ' + glueWorkflowName)
    logger.info('## GLUE JOB Workflow Status: ' + response['Run']['Status'])
    if response['Run']['Status'] != "COMPLETED":
        response = {
            'statusCode': 202,
            'body': json.dumps({ 'Payload': jEvent['Payload'] })
        }
    else:
        response = {
            'statusCode': 200,
            'body': json.dumps({ 'Payload': jEvent['Payload'] })
        }
    return response
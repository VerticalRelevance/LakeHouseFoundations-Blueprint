import json
import os

# Set up logging
import logging

from botocore.retryhandler import ExceptionRaiser
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Import Boto 3 for AWS Glue
import boto3
glueClient = boto3.client('glue')

# Define Lambda function
def initiate_workflow(event, context):
    logger.info('## INITIATED BY EVENT: ' + json.dumps(event))
    # Variables for the job:
    jEvent = json.loads(json.dumps(event))

    if 'Payload' in jEvent:
        logger.info("Incoming event has payload. Checking Workflow run status...")
        glueWorkflowName = jEvent['Payload']['LzGlueWorkflowName']
        glueWorkflowRunId = jEvent['Payload']['RunId']
        statusResponse = glueClient.get_workflow_run(Name=glueWorkflowName, RunId=glueWorkflowRunId)
        status = statusResponse['Run']['Status']
        response = {}
        response['ResponseMetadata'] = statusResponse['ResponseMetadata']
        logger.info("Glue Workflow status response: " + str(response))

        if status == "COMPLETED":
            logger.info("Workflow has completed. Returning 200 OK.")
            response['statusCode'] = 200
        elif status == "RUNNING":
            logger.info("Workflow has completed. Returning 202 'wait'.")
            response['statusCode'] = 202
        else:
            logger.info("Workflow is neither completed or running. Returning 403 error.")
            response['statusCode'] = 500
            raise ExceptionRaiser("Workflow resulted in unsupported state.")
        response['LzGlueWorkflowName'] = jEvent['Payload']['LzGlueWorkflowName']
        response['RunId'] = jEvent['Payload']['RunId']
    else:
        glueWorkflowName = jEvent['LzGlueWorkflowName']
        logger.info("Starting Glue Workflow: " + str(glueWorkflowName))
        response = glueClient.start_workflow_run(Name=glueWorkflowName)
        # Set status to 202 so we can wait for the newly running workflow to complete
        response['ResponseMetadata']['HTTPStatusCode'] = 202
        response['LzGlueWorkflowName'] = jEvent['LzGlueWorkflowName']
        response['statusCode'] = 202
        logger.info('Glue Workflow Started: ' + json.dumps(response))

    response
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
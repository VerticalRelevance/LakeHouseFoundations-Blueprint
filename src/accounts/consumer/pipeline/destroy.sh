#!/bin/bash

# Tear down all components
aws cloudformation delete-stack --stack-name "dev-lakehouse-consumer-athena"
aws cloudformation delete-stack --stack-name "dev-lakehouse-consumer-catalog"
aws cloudformation delete-stack --stack-name "dev-lakehouse-consumer-lakeformation"
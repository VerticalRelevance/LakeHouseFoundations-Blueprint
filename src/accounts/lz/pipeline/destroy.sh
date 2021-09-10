#!/bin/bash

# Tear down all components
aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-main"
aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-datasync"
aws cloudformation delete-stack --stack-name "dev-lakehouse-lz-msk"
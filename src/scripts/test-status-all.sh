#!/bin/bash

alias stack-status=". ./stack-status.sh"

# Landing Zone Account
vrLabLz
region1
cd ../accounts/lz/pipeline
stack-status
region2
stack-status
cd ../../../scripts

# Lake House Account
vrLabLh
region1
cd ../accounts/lakehouse/pipeline
stack-status
region2
stack-status
cd ../../../scripts

# Governance Account
vrLabGov
region1
cd ../accounts/lakehouse/pipeline
stack-status
region2
stack-status
cd ../../../scripts

# Governance Account
vrLabCons1
region1
cd ../accounts/consumer/pipeline
stack-status
region2
stack-status
cd ../../../scripts
#!/bin/bash

shopt -s nullglob

args="$@"
echo "Target path to be supplied as: ${args[0]}."

# if cfn_nag_scan --input-path "${args[0]}" --blacklist-path "blacklist-cfnnag.yml"; then
if cfn_nag_scan --input-path "${args[0]}"; then
    echo "Templates in directory ${args[0]} PASSED static testing."
else
    echo "Templates in directory ${args[0]} FAILED static testing."
    # touch FAILED
fi

# if [ -e FAILED ]; then
#   echo "cfn-nag FAILED at least once!"
#   exit 1
# else
#   echo "cfn-nag PASSED on all files!"
#   exit 0
# fi
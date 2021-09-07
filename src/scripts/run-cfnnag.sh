#!/bin/bash
shopt -s nullglob
mkdir -p templates/
cp products/*/*.{json,yml} templates/
cp deploy/*.json templates/
for f in templates/*; do
    if cfn_nag_scan --input-path "$f" --blacklist-path ./deploy/blacklist-cfnnag.yml; then
        echo "$f PASSED"
    else
        echo "$f FAILED"
        touch FAILED
    fi
done

if [ -e FAILED ]; then
  echo cfn-nag FAILED at least once!
  exit 1
else
  echo cfn-nag PASSED on all files!
  exit 0
fi
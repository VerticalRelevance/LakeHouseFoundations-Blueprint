# Fake Data Generator

## Project setup
Use pyenv to set the Python version 3.8.1
```angular2html
pyenv install 3.8.1
```

Use pipenv to install the dependencies
```angular2html
pipenv --python 3.8.1
pipenv install
```

If this process is unfamiliar, see the first video in module 6 
of my Pluralsight course:
[Exploring Web Scraping with Python](https://app.pluralsight.com/library/courses/exploring-web-scraping-python/)


### Setup Your Environment
I created an AWS-CLI profile named 'plu.' Then used that 
profile via boto3.Session
```
session = boto3.Session(profile_name='plu')
fh_client = session.client('firehose', 'us-east-1')
```

### Run the Code
With the above steps done, run the code as follows:
```
pipenv run python generate_data.py
```

### Elasticsearch Terrform
Look in the es folder for an example of how to use Terraform.

Really, I did this for my convenience as it made testing faster.

Most of the relevant code is in resources.tf.

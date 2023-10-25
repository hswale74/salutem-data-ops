from simple_salesforce import Salesforce

import logging
import os
import pandas as pd

logging.basicConfig(level=logging.INFO)


sf_client = Salesforce(
    username=os.getenv("SF_USERNAME"),
    password=os.getenv("SF_PASSWORD"),
    security_token=os.getenv("SF_TOKEN")
)

logging.info(sf_client.describe())
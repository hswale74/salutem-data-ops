import faker
import random
from typing import List
from salesforce_bulk import SalesforceBulk, CsvDictsAdapter
from simple_salesforce import Salesforce
import pandas as pd
import os
import petname

class LeadFactory(object):
    STATUSES = [
        'Open - Not Contacted', 
        'Working - Contacted', 
        'Closed - Converted', 
        'Closed - Not Converted'
    ]
    def __init__(self, faker=faker.Faker()):
        self.faker = faker
        self.pet_name = petname.generate(1)

    def generate_record(self):
        chosen_status = random.choice(LeadFactory.STATUSES)
        data = {
            "FirstName": self.pet_name,
            "LastName": self.faker.last_name(),
            "Company": self.faker.company(),
            "Status": chosen_status, 
            "IsConverted": chosen_status == 'Closed - Converted'
        }
        return data
        


class BulkUploader(object):

    def upload(sb_client, object_name, records, chunk_size=10000):
        job_id = sb_client.create_insert_job(object_name, contentType='CSV')
        batch_ids = []

        for index in range(0, len(records), chunk_size):
            record_batch = records[index:index+chunk_size]
            csv_iter = CsvDictsAdapter(iter(record_batch))
            batch_id = sb_client.post_batch(job_id, csv_iter)
            sb_client.wait_for_batch(job_id, batch_id)
            batch_ids.append(batch_id)


        return job_id, batch_ids

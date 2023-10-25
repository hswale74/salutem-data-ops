from airflow.decorators import dag, task
from airflow.utils.dates import days_ago
from plugins.helpers.staging_db import LocalFileSystemStagingDatabase
from plugins.helpers.domain import SfPasswordAuth
from plugins.helpers.fake import FactoryFactory
from plugins.helpers.sf_client import SfBulk

import os
import pandas as pd


@dag(schedule_interval=None, start_date=days_ago(2), tags=['hello_world'])
def hello_world_dag():
    @task
    def print_working_directory():
        print("YOOOOO")
        print(os.getcwd())

    print_working_directory()

hello_world = hello_world_dag()

@dag(schedule_interval=None, start_date=days_ago(2), tags=['hello_world'])
def write_to_db():

    @task
    def write():
        db = LocalFileSystemStagingDatabase(f"{os.getenv('AIRFLOW_HOME')}/data")
        df = pd.DataFrame(
            {
                'pk': ['A', 'B', 'C', 'D'], 
                'created': [1, 1, 1, 1]
            }
        )

        db.overwrite(df=df, table_name="table1")

    write()

write_to_db = write_to_db()

@dag(default_args = {'sf_org_name': 'koala', 'object_name': 'Lead'},  tags=['salesforce'])
def upload_fake_data():

    @task
    def upload(**kwargs):
        object_name = kwargs['dag'].default_args['object_name']
        factory = getattr(FactoryFactory, object_name)
        records = [factory.generate_record() for _ in range(1000)]


        sf_org_name = kwargs['dag'].default_args['sf_org_name'].upper()

        auth = SfPasswordAuth(
            username=os.getenv(f"SF_USERNAME_{sf_org_name}")
            password=os.getenv(f"SF_PASSWORD_{sf_org_name}")
            token=os.getenv(f"SF_TOKEN_{sf_org_name}")
        )

        client = Sf(
            auth=auth
        )
        
        batch_id ,job_id = client.upload(records)
        client.await_completion(batch_id)
        client.cleanup(batch_id, job_id)

        

        

        
        







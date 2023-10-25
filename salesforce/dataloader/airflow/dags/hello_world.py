from airflow.decorators import dag, task
from airflow.utils.dates import days_ago
from plugins.helpers.staging_db import LocalFileSystemStagingDatabase
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
        df = pd.DataFrame({
                        'pk': ['A', 'B', 'C', 'D'],
                        'created': [1, 1, 1, 1]
                    })
        print(df.shape)
        db.overwrite(df=df, table_name="table1")
        print("done")


    write()

write_to_db = write_to_db()
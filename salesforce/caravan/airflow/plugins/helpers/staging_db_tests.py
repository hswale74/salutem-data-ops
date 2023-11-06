from databases import LocalFileSystemStagingDatabase, AzureBlobStorageStagingDatabase
from azure.storage.blob import BlobServiceClient
import os
import pandas as pd


fs = LocalFileSystemStagingDatabase(directory=os.getcwd())
blob_service_client = BlobServiceClient.from_connection_string(os.getenv("AZURE_SA_CONNECTION_STRING"))

az = AzureBlobStorageStagingDatabase(
    blob_service_client=blob_service_client, 
    container_name="sc-gxpoc-dev-centralus-tortoise",
    directory_name="database1"
)

first_df = pd.DataFrame({
    'pk': ['A', 'B', 'C', 'D'],
    'created': [1, 1, 1, 1]
})

second_df = pd.DataFrame({
    'pk': ['A', 'B', 'C', 'E'],
    'created': [2, 2, 2, 2]
})

fs.overwrite(
    df=first_df, 
    table_name="table1", 
    partition_name='partition1'
)

fs.upsert(
    df=second_df,
    table_name="table1",
    primary_keys=['pk'],
    ordering_columns=['created'],
    ascending=[False],
    partition_name='partition1'
)

az.overwrite(
    df=first_df,
    table_name="table1",
    partition_name="partition1"
)

az.upsert(
    df=second_df,
    table_name="table1",
    primary_keys=['pk'],
    ordering_columns=['created'],
    ascending=[False],
    partition_name='partition1'
)
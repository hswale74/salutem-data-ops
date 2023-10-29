from abc import ABC
import os
from typing import List

from azure.storage.blob import BlobServiceClient
import pandas as pd


class PandasStagingDatabase(ABC):
    def overwrite(
        self, df: pd.DataFrame, table_name: str, partition_name: str = "default"
    ):
        self._write(df=df, table_name=table_name, partition_name=partition_name)

    def upsert(
        self,
        df: pd.DataFrame,
        table_name: str,
        primary_keys: List[str],
        ordering_columns: List[str],
        ascending: List[bool],
        partition_name: str = "default",
    ):
        concat_df = pd.concat(
            [df, self._read(table_name=table_name, partition_name=partition_name)]
        )

        dedupe_df = self._dedupe(
            df=concat_df,
            primary_keys=primary_keys,
            ordering_columns=ordering_columns,
            ascending=ascending,
        )

        self._write(df=dedupe_df, table_name=table_name, partition_name=partition_name)

    def _dedupe(
        self,
        df: pd.DataFrame,
        primary_keys: List[str],
        ordering_columns=List[str],
        ascending=List[bool],
    ):
        return df.sort_values(by=ordering_columns, ascending=ascending).drop_duplicates(
            subset=primary_keys
        )


class LocalFileSystemStagingDatabase(PandasStagingDatabase):
    def __init__(self, directory: str, encoding: str = "utf-8"):
        self.directory = directory
        self.encoding = encoding

    def _get_fqn(self, table_name: str, parititon_name: str):
        return os.path.join(self.directory, table_name, parititon_name, "data.csv")

    def _read(self, table_name: str, partition_name: str = "default") -> pd.DataFrame:
        fqn = self._get_fqn(table_name=table_name, parititon_name=partition_name)
        return pd.read_csv(fqn, encoding=self.encoding)

    def _write(
        self, df: pd.DataFrame, table_name: str, partition_name: str = "default"
    ):
        fqn = self._get_fqn(table_name=table_name, parititon_name=partition_name)
        if not os.path.exists(fqn):
            os.makedirs("/".join(fqn.split("/")[:-1]))

        df.to_csv(fqn, encoding=self.encoding, index=False)


class AzureBlobStorageStagingDatabase(PandasStagingDatabase):
    def __init__(
        self,
        blob_service_client: BlobServiceClient,
        container_name: str,
        directory_name: str,
        encoding: str = "utf-8",
    ):
        self.blob_service_client = blob_service_client
        self.container_name = container_name
        self.directory_name = directory_name
        self.encoding = encoding

    def _get_fqn(self, table_name: str, parititon_name: str) -> str:
        return os.path.join(table_name, parititon_name, "data.csv")

    def _read(self, table_name: str, partition_name: str = "default") -> pd.DataFrame:
        fqn = self._get_fqn(table_name=table_name, parititon_name=partition_name)
        client = self.blob_service_client.get_blob_client(
            container=self.container_name, blob=fqn
        )

        return pd.read_csv(client.download_blob(), encoding=self.encoding)

    def _write(
        self, df: pd.DataFrame, table_name: str, partition_name: str = "default"
    ) -> None:
        fqn = self._get_fqn(table_name=table_name, parititon_name=partition_name)
        client = self.blob_service_client.get_blob_client(
            container=self.container_name, blob=fqn
        )

        client.upload_blob(df.to_csv(index=False).encode(self.encoding), overwrite=True)

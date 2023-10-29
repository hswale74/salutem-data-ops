# Script to Create, Update and Delete records in salesforce

import requests
import time
import os
from datetime import datetime
import json
from typing import List, Tuple

from salesforce_bulk import SalesforceBulk, CsvDictsAdapter
import pandas as pd

from helpers.domain import SfPasswordAuth
from helpers.staging_db import FileSystemStagingDatabase


class SalesforceBulk2:
    """
    Interface to Bulk 2.0 API Ingest
    """

    # -----------------------------------------------------------------------------------------------------
    def __init__(self, domain="login", api_version="56.0") -> None:
        self.api_version = api_version
        # Loading insert credentials config
        with open("configs/insert_credentials.json") as f:
            credentials = json.load(f)

        # ------------- Authenticate and obtain an access token ---------------
        login_url = f"https://{domain}.salesforce.com/services/oauth2/token"
        data = {
            "grant_type": "password",
            "client_id": credentials["client_id"],
            "client_secret": credentials["client_secret"],
            "username": credentials["username"],
            "password": f"{credentials['password']}{credentials['security_token']}",
        }
        login_response = requests.post(login_url, data=data)
        # ----------------------------------------------------------------------

        self.__access_token = login_response.json()[
            "access_token"
        ]  # Fetching Access Token
        self.__instance_url = login_response.json()[
            "instance_url"
        ]  # Fetching Instance Url

        self.__job_id = ""

        print("Instance Url :- ", self.__instance_url)

    # -----------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------
    def create_job(self, operation: str, object_name: str, line_ending="CRLF") -> None:
        """
        Creates a job representing a bulk operation

        Inputs:
            operation: what type of opeation needs to be performed eg insert
            object_name: object name for which an operation is being performed
            line_ending: the line ending used for CSV job data, marking the end of a data row.

        Reference : https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/create_job.htm

        """

        job_url = (
            f"{self.__instance_url}/services/data/v{self.api_version}/jobs/ingest/"
        )

        # Creating header
        headers = {
            "Authorization": f"Bearer {self.__access_token}",
            "Content-Type": "application/json",
        }

        job_data = {
            "operation": operation,
            "object": object_name,
            "contentType": "CSV",
            "lineEnding": line_ending,
        }

        job_response = requests.post(
            job_url, headers=headers, data=json.dumps(job_data)
        )

        if job_response.status_code == 200:
            self.__job_id = job_response.json()["id"]
            print("Job id :- ", self.__job_id)
        else:
            print("Error creating job...")
            print(job_response.text)

    # -----------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------
    def upload_job_data(self, file_path: str) -> bool:
        """
        Uploads data for a job using CSV data you provide

        Inputs:
            file_path: csv file path in which data is present to upload to job

        Reference: https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/upload_job_data.htm

        """

        data_url = f"{self.__instance_url}/services/data/v{self.api_version}/jobs/ingest/{self.__job_id}/batches"

        headers = {
            "Authorization": f"Bearer {self.__access_token}",
            "Content-Type": "text/csv",
        }

        with open(file_path, "rb") as data_file:
            response = requests.put(data_url, headers=headers, data=data_file)

        if response.status_code == 201:
            print(f"Uploaded Data for Job id {self.__job_id}")
            return True
        else:
            print("Error Occured while uploading data")
            print(response.text)
            print(response.status_code)
            return False

    # -----------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------
    def upload_complete(self) -> bool:
        """
        This function notifies Salesforce servers that the upload of job data is complete and is ready for processing. You cant add any more job data. This request is required for every Bulk API 2.0 ingest job. If you don't make this request, processing of your data does not start.

        """
        upload_complete_url = f"{self.__instance_url}/services/data/v{self.api_version}/jobs/ingest/{self.__job_id}"
        headers = {
            "Authorization": f"Bearer {self.__access_token}",
            "Content-Type": "application/json",
        }

        response = requests.patch(
            upload_complete_url,
            headers=headers,
            data=json.dumps({"state": "UploadComplete"}),
        )

        if response.status_code == 200:
            print("Upload Competed")
            print("\n")
            print("***Upload status***")
            print("Job id :- ", response.json()["id"])
            print("State :- ", response.json()["state"])
            print("Operation :- ", response.json()["operation"])
            print("********")
            print("\n")
            return True
        else:
            print("Error Occured while changing job to UploadComplete")
            print(response.text)
            return False

    # -------------------------------------------------------------------------------------------------------

    # -------------------------------------------------------------------------------------------------------
    def get_job_status(self):
        """
        This function Retrieves detailed information about a job

        Reference: https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/get_job_info.htm
        """

        job_status_url = f"{self.__instance_url}/services/data/v{self.api_version}/jobs/ingest/{self.__job_id}"
        headers = {
            "Authorization": f"Bearer {self.__access_token}",
            "Content-Type": "application/json",
        }

        response = requests.get(job_status_url, headers=headers)
        return response

    # --------------------------------------------------------------------------------------------------------

    # --------------------------------------------------------------------------------------------------------
    def store_results(
        self, object_name: str, operation_name: str, environment: str
    ) -> None:
        """
        Function that stores Successful and Failed records for a insert operation

        Inputs:
            object_name: object name against which results needs to be stored
            operation_name: opearaion name
            environment: environment name where the results needs to be stored
        """
        object_folder_path = f"./files/cud_objects/{environment}/{object_name}"
        operation_folder_path = (
            f"./files/cud_objects/{environment}/{object_name}/{operation_name}"
        )
        failed_records_folder_path = (
            f"./files/cud_objects/{environment}/{object_name}/{operation_name}/failed"
        )
        successful_records_folder_path = f"./files/cud_objects/{environment}/{object_name}/{operation_name}/successful"
        unprocessed_records_folder_path = f"./files/cud_objects/{environment}/{object_name}/{operation_name}/unprocessed"

        # ------------ Creating required folders ----------------
        if not os.path.exists(object_folder_path):
            os.makedirs(object_folder_path)

        if not os.path.exists(operation_folder_path):
            os.makedirs(operation_folder_path)

        if not os.path.exists(failed_records_folder_path):
            os.makedirs(failed_records_folder_path)

        if not os.path.exists(successful_records_folder_path):
            os.makedirs(successful_records_folder_path)

        if not os.path.exists(unprocessed_records_folder_path):
            os.makedirs(unprocessed_records_folder_path)
        # --------------------------------------------------------

        # --------- Fetching Successful Records ------------------
        success_records_url = f"{self.__instance_url}/services/data/v{self.api_version}/jobs/ingest/{self.__job_id}/successfulResults/"
        headers = {
            "Authorization": f"Bearer {self.__access_token}",
            "Content-Type": "CSV",
        }
        response = requests.get(success_records_url, headers=headers)

        if response.status_code == 200:
            if len(response.text) != 0:
                # Remove empty rows from the CSV data
                records_data = "\n".join(
                    line.strip() for line in response.text.split("\n") if line.strip()
                )

                # saving success records
                with open(
                    f'{successful_records_folder_path}/success_{datetime.now().strftime("%Y-%m-%d %H-%M-%S")}.csv',
                    "w",
                    encoding="utf-8",
                ) as file_handler:
                    file_handler.write(records_data)
        # --------------------------------------------------------

        # --------- Fetching Failed Records ------------------
        failed_records_url = f"{self.__instance_url}/services/data/v{self.api_version}/jobs/ingest/{self.__job_id}/failedResults/"
        headers = {
            "Authorization": f"Bearer {self.__access_token}",
            "Content-Type": "CSV",
        }
        response = requests.get(failed_records_url, headers=headers)

        if response.status_code == 200:
            if len(response.text) != 0:
                # Remove empty rows from the CSV data
                records_data = "\n".join(
                    line.strip() for line in response.text.split("\n") if line.strip()
                )

                with open(
                    f'{failed_records_folder_path}/failed_{datetime.now().strftime("%Y-%m-%d %H-%M-%S")}.csv',
                    "w",
                    encoding="utf-8",
                ) as file_handler:
                    file_handler.write(records_data)
        # -----------------------------------------------------

        # --------- Fetching Unprocessed Records ------------------
        unprocessed_records_url = f"{self.__instance_url}/services/data/v{self.api_version}/jobs/ingest/{self.__job_id}/unprocessedrecords/"
        headers = {
            "Authorization": f"Bearer {self.__access_token}",
            "Content-Type": "CSV",
        }
        response = requests.get(unprocessed_records_url, headers=headers)

        if response.status_code == 200:
            if len(response.text) != 0:
                # Remove empty rows from the CSV data
                records_data = "\n".join(
                    line.strip() for line in response.text.split("\n") if line.strip()
                )

                with open(
                    f'{unprocessed_records_folder_path}/unprocessed_{datetime.now().strftime("%Y-%m-%d %H-%M-%S")}.csv',
                    "w",
                    encoding="utf-8",
                ) as file_handler:
                    file_handler.write(records_data)
        # -----------------------------------------------------

    # -----------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------
    def cud(
        self, file_path: str, object_name: str, operation_name: str, environment: str
    ):
        """
        Function to CREATE, UPDATE, DELETE records in salesforce

        Inputs:
            file_path: csv file that contains records
            object_name: object name against which records require cud operations
            environment: environment name where the results needs to be stored
        """

        # Create Update Job
        self.create_job(operation=operation_name, object_name=object_name)
        # Upload Job Data
        if self.upload_job_data(file_path):
            if self.upload_complete():
                while True:
                    job_status_response = self.get_job_status()

                    if job_status_response.status_code == 200:
                        job_status = job_status_response.json()

                        total_records_processed = job_status["numberRecordsProcessed"]
                        successful_records = (
                            job_status["numberRecordsProcessed"]
                            - job_status["numberRecordsFailed"]
                        )
                        failed_records = job_status["numberRecordsFailed"]
                        job_state = job_status["state"]
                        total_processing_time = job_status["totalProcessingTime"]
                        api_processing_time = job_status["apiActiveProcessingTime"]

                        print("*" * 30)
                        print(f"Job State :- {job_state}")
                        print(f"Total Records Processed :- {total_records_processed}")
                        print(f"Successful Records :- {successful_records}")
                        print(f"Failed Records :- {failed_records}")
                        print(f"Total Processing Time :- {total_processing_time}")
                        print(f"Api Processing Time :- {api_processing_time}")
                        print("*" * 30)

                        job_state = job_status["state"]
                        if job_state in ("JobComplete", "Failed"):
                            break

                    else:
                        print("Failed to retrieve batch status")
                        print(job_status_response.text)

                    final_status_response = self.get_job_status()
                    if final_status_response.status_code == 200:
                        final_status = job_status_response.json()
                        print("*" * 30)
                        print(f"Job State :- {final_status['state']}")
                        print(
                            f"Total Records Processed :- {final_status['numberRecordsProcessed']}"
                        )
                        print(
                            f"Successful Records :- {final_status['numberRecordsProcessed'] - final_status['numberRecordsFailed']}"
                        )
                        print(
                            f"Failed Records :- {final_status['numberRecordsFailed']}"
                        )
                        print(
                            f"Total Processing Time :- {final_status['totalProcessingTime']}"
                        )
                        print(
                            f"Api Processing Time :- {final_status['apiActiveProcessingTime']}"
                        )
                        if final_status["state"] == "Failed":
                            print(f"Error Message :- {final_status['errorMessage']}")
                        print("*" * 30)
                    else:
                        print("Failed to retrieve batch status")
                        print(final_status.text)

                    time.sleep(15)  # Sleep for 15 seconds before checking again

                self.store_results(
                    object_name, operation_name, environment
                )  # Storing success and failed records in a csv file


# -----------------------------------------------------------------------------------------------------


class SfBulk:
    def __init__(
        self,
        auth: SfPasswordAuth,
        staging_db: FileSystemStagingDatabase,
        object_name: str,
    ):
        self.client = SalesforceBulk(**auth.__dict__)
        self.staging_db = staging_db
        self.object_name = object_name

    def upload(self, records: List[dict]) -> Tuple[int, int]:
        job_id = self.client.create_insert_job(self.object_name, contentType="CSV")
        csv_iter = CsvDictsAdapter(iter(records))
        batch_id = self.client.post_batch(job_id, csv_iter)
        return job_id, batch_id

    def await_completion(self, job_id: str, batch_id: str) -> None:
        self.client.wait_for_batch(batch_id, job_id)

    def cleanup(self, job_id: str, batch_id: str) -> dict:
        batch_results = self._get_batch_results(batch_id=batch_id)

        self.staging_db.overwrite(
            df=batch_results[batch_results.success == "true"],
            table_name=f"{self.object_name}_upload",
            partition_name=f"{job_id}_{batch_id}",
        )

        self.staging_db.overwrite(
            df=batch_results[batch_results.success == "false"],
            table_name=f"{self.object_name}_upload",
            partition_name=f"{job_id}_{batch_id}",
        )

        aggregates = {
            "summary": batch_results.groupby("success").size().to_dict(),
            "error_set": set(batch_results.error.unique()),
        }

        return aggregates

    def _get_batch_results(self, batch_id: str) -> pd.DataFrame:
        df = pd.DataFrame.from_records(self.client.get_batch_results(batch_id))
        df.columns = ["id", "success", "created", "error"]
        return df


# -----------------------------------------------------------------------------------------------------
def main():
    csv_file_path = "D:/Work/Data migration Task from LQ to ITPRO/ACI_Learning_Dev/files/docebo_copy_course_update.csv"
    object_name = "Product2"
    environment = "sit"
    SalesforceBulk2(domain="test").cud(
        csv_file_path, object_name, "update", environment
    )


# -----------------------------------------------------------------------------------------------------


if __name__ == "__main__":
    main()

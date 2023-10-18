import requests
import json
from typing import List
import os
from dataclasses import dataclass


@dataclass
class SFAuth:
    grant_type: str
    client_id: str
    client_secret: str 
    username: str 
    password: str 


class SfClient:

    def __init__(self, base_url: str, auth: SFAuth):
        self.base_url = base_url
        self.bearer_token = self._get_bearer_token(auth)

        self.headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {self.bearer_token}'
        }
        
    def _get_bearer_token(self, auth: SFAuth):
        url = f'{self.base_url}/services/oauth2/token'
        payload = auth.__dict__
        print(payload)
        resp = requests.post(
            url=url,
            data=payload
        )

        if resp.status_code != '200':
            print(resp.__dict__)
            resp.raise_for_status()
        return resp.json()['access_token']
        

    def list_all_objects(self):
        url = f'{self.base_url}/services/data/v41.0/sobjects/'
        response = requests.get(url, headers=self.headers)
        if response.status_code != 200:
            raise Exception('Request failed: ' + response.text) 
        return response.json()['sobjects']

    def list_object_fields(self, object_name:str):
        url = f'{self.base_url}/services/data/v41.0/sobjects/{object_name}/describe/'
        response = requests.get(url, headers=self.headers)
        if response.status_code != 200:
            raise Exception('Request failed: ' + response.text)
        return response.json()['fields']
    


class OmetaClient:
    def __init__(self, access_token, instance_url) -> None:
        self.access_token = access_token
        self.instance_url = instance_url
        self.headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {self.access_token}'
        }

    def get_asset_id(self, asset_name:str) -> str:
        url = f'{self.instance_url}/api/v1/assets?name={asset_name}'
        response = requests.get(url, headers=self.headers)
        
        if response.status_code != 200:
            raise Exception(f'Failed to get asset: {response.text}')
        
        assets = response.json()
        if not assets:
            raise Exception(f'No asset found with name: {asset_name}')
        
        return assets[0]['id']

    def upload_custom_attributes(self, asset_name:str, custom_attributes:dict) -> dict:
        asset_id = self.get_asset_id(asset_name)

        url = f'{self.instance_url}/api/v1/assets/{asset_id}/custom'
        response = requests.post(url, headers=self.headers, data=json.dumps(custom_attributes))
        
        if response.status_code != 200:
            raise Exception(f'Failed to upload custom attributes: {response.text}')
        
        return response.json()
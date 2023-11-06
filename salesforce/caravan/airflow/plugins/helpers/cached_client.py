from typing import List, Any, Tuple
from enum import Enum
import shelve

class CacheReturnType(Enum):
    hit=1
    miss=2
    
class SfClient:
    def __init__(self, ss_client: Salesforce, shelf_path: str):
        self.ss_client = ss_client
        self.shelf_path = shelf_path

    def _try_cache(self, key: str) -> Tuple[CacheReturnType, Any]:
        data = None
        with shelve.open(self.shelf_path) as db: 
            if key in db:
                return (CacheReturnType.hit, db[key])
        
        return (CacheReturnType.miss, None)
        
    def _cache(self, data, key):
        with shelve.open(self.shelf_path) as db:
            db[key] = data
        

    def list_objects(self):
        key = 'objects'
        return_type, data = self._try_cache(key)
        
        if return_type == CacheReturnType.miss:
            data = self.ss_client.describe()['sobjects']
            self._cache(data, key)
            
        return data

    def get_object_detail(self, object_name):
        key = f'{object_name}.detail'
        return_type, data = self._try_cache(key)
        
        if return_type == CacheReturnType.miss:
            data = getattr(self.ss_client, object_name).describe()
            self._cache(data, key)
            
        return data
        
    def get_object_record_count(self, object_name, on_error=-1):
        key = f'{object_name}.record_count'
        return_type, data = self._try_cache(key)

        if return_type == CacheReturnType.miss:
            try:
                data = int(
                    self.ss_client.query(
                        f"Select count(Id) from {object_name}"
                    )['records'][0]['expr0']
                )
            except SalesforceMalformedRequest:
                data = on_error

            self._cache(data, key)
            
        return data   
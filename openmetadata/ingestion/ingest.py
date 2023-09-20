"""
Script to configure a new database service and its ingestion
"""
############Ometa Client###########

import os
import logging

logging.basicConfig(level=logging.DEBUG)

from _ometa_api import OpenMetadata
from metadata.generated.schema.security.client.openMetadataJWTClientConfig import (
    OpenMetadataJWTClientConfig,
)
from metadata.generated.schema.entity.services.connections.metadata.openMetadataConnection import (
    OpenMetadataConnection,
    AuthProvider,
)

server_config = OpenMetadataConnection(
    hostPort=f"{os.getenv('OMETA_DNS')}:8585/api",
    authProvider=AuthProvider("openmetadata"),
    securityConfig=OpenMetadataJWTClientConfig(jwtToken=os.getenv("OMETA_TOKEN")),
    enableVersionValidation=False
)

metadata = OpenMetadata(server_config)

assert metadata.health_check()

###########Create service#############

from metadata.generated.schema.entity.services.databaseService import (
    DatabaseService,
    DatabaseServiceType,
    DatabaseConnection,
)
from metadata.generated.schema.entity.services.connections.database.azureSQLConnection import (
    AzureSQLConnection
)

from metadata.generated.schema.api.services.createDatabaseService import (
    CreateDatabaseServiceRequest,
)

create_service = CreateDatabaseServiceRequest(
    name="salutem-uat-georeplica",
    serviceType=DatabaseServiceType.AzureSQL,
    connection=DatabaseConnection(
        config=AzureSQLConnection(
            database=os.getenv("DB_NAME"),
            username=os.getenv("DB_USERNAME"),
            password=os.getenv("DB_PASSWORD"),
            hostPort=os.getenv("DB_HOSTPORT"),
        )
    ),
)

service: DatabaseService = metadata.create_or_update(data=create_service)

logging.info(f"Service id={service.id}")

# ##########Configure ingestion############
from metadata.generated.schema.type.entityReference import EntityReference
from metadata.generated.schema.type.filterPattern import FilterPattern
from metadata.generated.schema.api.services.ingestionPipelines.createIngestionPipeline import (
    CreateIngestionPipelineRequest
)

# from metadata.generated.schema.api.data.createPipeline import CreatePipelineRequest

# from metadata.generated.schema.entity.services.pipelineService import (
#     PipelineConnection,
#     PipelineService,
#     PipelineServiceType,
# )
# from metadata.generated.schema.api.data.createPipeline

from metadata.generated.schema.entity.services.ingestionPipelines.ingestionPipeline import PipelineType, AirflowConfig

from metadata.generated.schema.metadataIngestion.workflow import SourceConfig

from metadata.generated.schema.metadataIngestion.databaseServiceMetadataPipeline import DatabaseServiceMetadataPipeline


source_config = SourceConfig(
    config=DatabaseServiceMetadataPipeline(
        includeTables=True,
        includeViews=True,
        databaseFilterPattern=FilterPattern(
            includes=['IPEP_C3LX_Training']
        ),
        schemaFilterPattern=FilterPattern(
            includes=["dbo"]
        )
    )
)

airflow_config = AirflowConfig(
    pausePipeline=False,
    scheduleInterval="0 0 1 * *"
)

service_reference = EntityReference(
    id=service.id,
    type="databaseService"
)

create_ingestion_pipline = CreateIngestionPipelineRequest(
    name="salutem-uat-georeplica-ingestion",
    pipelineType=PipelineType.metadata,
    sourceConfig=source_config,
    airflowConfig=airflow_config,
    service=service_reference
)

print(create_ingestion_pipline.__class__)
pipeline = metadata.create_or_update(create_ingestion_pipline)

logging.info(f"Object pipelien is of type= ${type(pipeline)}")

logging.info(f"Pipeline id = {pipeline.id}")



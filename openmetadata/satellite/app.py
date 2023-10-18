import os
from flask import Flask

from metadata.ingestion.ometa.ometa_api import OpenMetadata
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
    )
client = OpenMetadata(server_config)

app = Flask(__name__)

@app.route("/")
def health_check(client=client):
    return f"Health Check: {client.health_check()}"


app.run(host="0.0.0.0", port=5000)

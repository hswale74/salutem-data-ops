FROM python:3.9-bullseye

ARG APP_HOME=/ingest

RUN mkdir $APP_HOME

COPY ./requirements.txt /${APP_HOME}/requirements.txt 

RUN pip install -r /${APP_HOME}/requirements.txt

COPY ./ingest.py /${APP_HOME}/ingest.py
COPY ./_ometa_api.py /${APP_HOME}/_ometa_api.py

WORKDIR ${APP_HOME}

ENTRYPOINT ["python", "-m", "ingest"]

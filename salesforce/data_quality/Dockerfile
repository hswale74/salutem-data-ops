FROM python:3.9-bullseye

ARG APP_HOME=/app
ARG DATA_DIR = /data

RUN mkdir $APP_HOME
RUN mkdir $DATA_DIR

COPY ./requirements.txt /${APP_HOME}/requirements.txt 

RUN pip install -r /${APP_HOME}/requirements.txt

COPY ./app.py /${APP_HOME}/app.py
COPY ./helpers.py /${APP_HOME}/helpers.py


WORKDIR ${APP_HOME}

ENTRYPOINT ["python", "-m", "app"]

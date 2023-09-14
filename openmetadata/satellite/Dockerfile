FROM python:3.9-bullseye

ARG APP_HOME=/satellite

RUN mkdir $APP_HOME

COPY ./requirements.txt /${APP_HOME}/requirements.txt 

RUN pip install -r /${APP_HOME}/requirements.txt

COPY ./app.py /${APP_HOME}/app.py

WORKDIR ${APP_HOME}

ENTRYPOINT ["python", "-m", "app"]

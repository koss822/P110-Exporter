FROM python:3.11-slim-bullseye AS builder
RUN apt-get update; apt-get -y upgrade; apt-get clean; apt-get install binutils git -y

COPY . /app
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install git+https://github.com/almottier/TapoP100.git@main

RUN python3 -m PyInstaller main.py --onefile --hidden-import loguru --hidden-import prometheus_client --hidden-import PyP100

FROM python:3.11-slim-bullseye
COPY --from=builder /app/dist /app/dist
CMD /app/dist/main --tapo-email=$TAPO_USER_EMAIL --tapo-password=$TAPO_USER_PASSWORD --config-file=/app/tapo.yaml --prometheus-port=$TAPO_PROMETHEUS_PORT
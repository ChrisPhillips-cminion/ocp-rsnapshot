# syntax=docker/dockerfile:1

FROM ubuntu:latest

WORKDIR /app
ENV UNIT="-t hourly"
RUN apt update -y
RUN apt install -y rsnapshot openssl
RUN rm -rf /etc/rsnapshot.conf
RUN apt clean && rm -rf /var/lib/apt/lists/*
COPY start.sh .

CMD ["/app/start.sh"]




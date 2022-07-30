# syntax=docker/dockerfile:1

FROM ubuntu:jammy

WORKDIR /app
ENV UNIT="-t hourly"
RUN apt update
RUN apt install -y rsnapshot
RUN rm -rf /etc/rsnapshot.conf
RUN apt clean && rm -rf /var/lib/apt/lists/*
COPY start.sh .
#RUN chmod 755 start.sh
RUN which sh
RUN ls /bin/sh
CMD ["/app/start.sh"]




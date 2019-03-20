FROM debian:stretch-slim

RUN     apt-get update && \
        apt-get install -y wget vim gnupg lsb-release && \
        wget https://pkg.tarsnap.com/tarsnap-deb-packaging-key.asc && \
        apt-key add tarsnap-deb-packaging-key.asc && \
        echo "deb http://pkg.tarsnap.com/deb/$(lsb_release -s -c) ./" | tee -a /etc/apt/sources.list.d/tarsnap.list && \
        apt-get update && \
        apt-get install -y tarsnap && \
        rm tarsnap-deb-packaging-key.asc

RUN     mkdir -p /tarsnap

COPY	artifacts /tarsnap/artifacts


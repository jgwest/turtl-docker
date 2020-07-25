FROM debian:stretch-slim

RUN mkdir -p /tarsnap/install && cd /tarsnap/install && apt-get update && \
	apt-get install -y wget gnupg2 lsb-release && \
	wget https://pkg.tarsnap.com/tarsnap-deb-packaging-key.asc && \
	apt-key add tarsnap-deb-packaging-key.asc && \
	echo "deb http://pkg.tarsnap.com/deb/$(lsb_release -s -c) ./" | tee -a /etc/apt/sources.list.d/tarsnap.list && \
	apt-get update && \
	apt-get install -y tarsnap-archive-keyring && \
	echo "deb-src http://pkg.tarsnap.com/deb-src ./" | tee -a /etc/apt/sources.list.d/tarsnap.list && \
	apt-get update && \
	gpg --no-default-keyring --keyring trustedkeys.gpg --import /usr/share/keyrings/tarsnap-archive-keyring.gpg && \
	cd /tarsnap/install && apt-get -y build-dep tarsnap  && \
	apt-get -y source -b tarsnap && \
	dpkg -i tarsnap_*.deb && \
	rm -rf /tarsnap/install 

RUN     mkdir -p /tarsnap

COPY	artifacts /tarsnap/artifacts


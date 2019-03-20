FROM postgres:11

#RUN	apt-get update && \
#	apt-get install -y wget vim && \ 
#	wget https://pkg.tarsnap.com/tarsnap-deb-packaging-key.asc && \
#	apt-key add tarsnap-deb-packaging-key.asc && \
#	echo "deb http://pkg.tarsnap.com/deb/$(lsb_release -s -c) ./" | tee -a /etc/apt/sources.list.d/tarsnap.list && \
#	apt-get update && \
#	apt-get install -y tarsnap && \
#	rm tarsnap-deb-packaging-key.asc 

RUN	mkdir -p /var/lib/postgresql/tarsnap 

COPY	artifacts/ /var/lib/postgresql/tarsnap	

RUN 	chown -R www-data:www-data /var/lib/postgresql/tarsnap



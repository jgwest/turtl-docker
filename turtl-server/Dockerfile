FROM turtl-image-git:latest

ARG TRTL_POSTGRES_PASSWORD
ARG TRTL_DOMAIN_NAME_WWW
ARG TRTL_SECURE_HASH_SALT

RUN apt-get update \
	&& apt-get install -y vim 

#RUN	apt-get update && \
#	apt-get install -y wget vim && \
#	wget https://pkg.tarsnap.com/tarsnap-deb-packaging-key.asc && \
#	apt-key add tarsnap-deb-packaging-key.asc && \
#	echo "deb http://pkg.tarsnap.com/deb/$(lsb_release -s -c) ./" | tee -a /etc/apt/sources.list.d/tarsnap.list && \
#	apt-get update && \
#	apt-get install -y tarsnap && \
#	rm tarsnap-deb-packaging-key.asc


COPY config/config.yaml.default config/config.yaml

COPY artifacts /app/artifacts

# Substitute the password from ARG into the turtl configuration file
RUN /app/artifacts/substitute-values-in-config.sh  "$TRTL_POSTGRES_PASSWORD"  "$TRTL_DOMAIN_NAME_WWW"  "$TRTL_SECURE_HASH_SALT"

RUN useradd --create-home -s /bin/bash turtl-server-user


RUN mkdir -p /var/www/turtl/server/plugins &&  \
	mkdir -p /var/www/turtl/server/public && \
	mkdir -p /var/www/turtl/server/public/uploads && \
	chown -R turtl-server-user:turtl-server-user /var/www/turtl && \
	chown -R turtl-server-user:turtl-server-user /app	

USER turtl-server-user



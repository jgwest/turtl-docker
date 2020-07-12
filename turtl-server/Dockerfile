FROM turtl-image-git:latest

ARG TRTL_POSTGRES_PASSWORD
ARG TRTL_DOMAIN_NAME_WWW
ARG TRTL_SECURE_HASH_SALT

RUN apk add -U vim

COPY config/config.yaml.default config/config.yaml

COPY artifacts /app/artifacts

# Substitute the password from ARG into the turtl configuration file
RUN /app/artifacts/substitute-values-in-config.sh  "$TRTL_POSTGRES_PASSWORD"  "$TRTL_DOMAIN_NAME_WWW"  "$TRTL_SECURE_HASH_SALT"


# Create a group and user
RUN addgroup -S turtl-server-user && adduser -S turtl-server-user -G turtl-server-user 

RUN mkdir -p /var/www/turtl/server/plugins &&  \
	mkdir -p /var/www/turtl/server/public && \
	mkdir -p /var/www/turtl/server/public/uploads && \
	chown -R turtl-server-user:turtl-server-user /var/www/turtl && \
	chown -R turtl-server-user:turtl-server-user /app	

USER turtl-server-user



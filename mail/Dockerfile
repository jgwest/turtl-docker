FROM debian:stretch-slim
#FROM ubuntu:16.04

RUN apt-get update && \
	apt-get install -y msmtp msmtp-mta ca-certificates

COPY artifacts/send-mail-container.sh /send-mail-container.sh

CMD ["tail", "-f", "/dev/null"]




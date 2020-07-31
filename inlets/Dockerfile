FROM debian:stretch-slim

RUN apt-get update && apt-get -y install curl

RUN curl -sLS https://get.inlets.dev | sh

RUN groupadd -g 899 inlets && \
    useradd --create-home -r -u 799 -g inlets inlets

USER inlets

ENTRYPOINT [ "/usr/local/bin/inlets", "client" ]


FROM nginx:stable

# Default to no domain; but this env var is filled in with the correct value by run.sh
ENV TRTL_DOMAIN_NAME noletsencrypt

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./site.conf /etc/nginx/conf.d-default/default.conf

#RUN mkdir -p /etc/nginx/ssl

#COPY ./cert/nginx.crt /etc/nginx/ssl/nginx.crt
#COPY ./cert/nginx.key /etc/nginx/ssl/nginx.key

#RUN useradd --create-home -s /bin/bash nginx-user

RUN mkdir /turtl-nginx && chown -R www-data:www-data /turtl-nginx

RUN touch /var/run/nginx.pid && \
  chown -R www-data:www-data /var/run/nginx.pid && \
  chown -R www-data:www-data /var/cache/nginx

COPY artifacts/ /turtl-nginx

RUN chown www-data:www-data /etc/nginx/nginx.conf /etc/nginx/conf.d-default/default.conf


WORKDIR /turtl-nginx
USER www-data


#CMD ["nginx", "-g", "daemon off;"]

CMD  [ "/turtl-nginx/nginx-run.sh" ]

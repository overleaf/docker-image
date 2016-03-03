FROM phusion/baseimage:0.9.16

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/texlive/2015/bin/x86_64-linux/

# Install Sharelatex
COPY install.sh /install.sh
RUN /install.sh

########################
# COPY config files and scripts to the image
########################
# nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/sharelatex.conf /etc/nginx/sites-enabled/sharelatex.conf
COPY runit/nginx.sh /etc/service/nginx/run

# services
COPY runit/chat-sharelatex.sh /etc/service/chat-sharelatex/run
COPY runit/clsi-sharelatex.sh /etc/service/clsi-sharelatex/run
COPY runit/docstore-sharelatex.sh /etc/service/docstore-sharelatex/run
COPY runit/document-updater-sharelatex.sh /etc/service/document-updater-sharelatex/run
COPY runit/filestore-sharelatex.sh /etc/service/filestore-sharelatex/run
COPY runit/real-time-sharelatex.sh /etc/service/real-time-sharelatex/run
COPY runit/spelling-sharelatex.sh /etc/service/spelling-sharelatex/run
COPY runit/tags-sharelatex.sh /etc/service/tags-sharelatex/run
COPY runit/track-changes-sharelatex.sh /etc/service/track-changes-sharelatex/run
COPY runit/web-sharelatex.sh /etc/service/web-sharelatex/run

# phusion/baseimage init script
COPY 00_regen_sharelatex_secrets.sh  /etc/my_init.d/00_regen_sharelatex_secrets.sh
COPY 00_make_sharelatex_data_dirs.sh /etc/my_init.d/00_make_sharelatex_data_dirs.sh
COPY 00_set_docker_host_ipaddress.sh /etc/my_init.d/00_set_docker_host_ipaddress.sh
COPY 99_migrate.sh /etc/my_init.d/99_migrate.sh

# Install ShareLaTeX settings file
ADD settings.coffee /etc/sharelatex/settings.coffee
ENV SHARELATEX_CONFIG /etc/sharelatex/settings.coffee

EXPOSE 80

ENTRYPOINT ["/sbin/my_init"]

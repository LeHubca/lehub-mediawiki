FROM mediawiki

COPY docker-resources /docker-resources

RUN /docker-resources/docker-setup-script.sh

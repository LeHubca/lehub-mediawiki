#!/bin/bash
#
# setup the image; see Dockerfile.
#
set -e

echo "<?php" > /load-extensions.php

# We are ignoring deprecation warnings because some extensions such as
# EmbedVideo have them, and we're not in a position to fix them.
apt-get update
apt-get --no-install-recommends -y install unzip
rm -rf /var/lib/apt/lists/*
echo "display_errors = Off" >> /usr/local/etc/php/php.ini
echo "log_errors = On" >> /usr/local/etc/php/php.ini
echo "error_log = /do-not-commit/php-log.log" >> /usr/local/etc/php/php.ini

echo "."
echo ".."
echo "Downloading and installing TinyMCE"
curl -O -L https://github.com/wikimedia/mediawiki-extensions-TinyMCE/archive/refs/heads/master.zip
unzip master.zip
rm master.zip
mv mediawiki-extensions-TinyMCE-master extensions/TinyMCE
echo 'wfLoadExtension( "TinyMCE" );' >> /load-extensions.php
echo '$wgTinyMCEEnabled = true;' >> /load-extensions.php
echo ".."
echo "."

echo "."
echo ".."
echo "Downloading and installing EmbedVideo"
# https://www.mediawiki.org/wiki/Extension:EmbedVideo#Installation
curl -O https://gitlab.com/hydrawiki/extensions/EmbedVideo/-/archive/v2.9.0/EmbedVideo-v2.9.0.zip
mv EmbedVideo* extensions/ && \
cd extensions && \
unzip EmbedVideo* && \
rm EmbedVideo*zip && \
mv EmbedVideo* EmbedVideo;
echo "wfLoadExtension( 'EmbedVideo' );" >> /load-extensions.php
echo ".."
echo "."

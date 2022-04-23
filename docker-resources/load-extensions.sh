#!/bin/bash
#
# Install extensions.
#
set -e

# This is how to install an extension; we are using TinyMCE as an example,
# use this as a template to install your own extensions in your fork or
# copy of this project.

echo "."
echo ".."
echo "Downloading and installing TinyMCE"
curl -O -L https://github.com/wikimedia/mediawiki-extensions-TinyMCE/archive/refs/heads/master.zip
unzip master.zip
rm master.zip
mv mediawiki-extensions-TinyMCE-master extensions/TinyMCE
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
echo ".."
echo "."

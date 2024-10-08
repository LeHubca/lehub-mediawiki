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
echo "Downloading and installing UserPageViewTracker"
# https://www.mediawiki.org/wiki/Extension:UserPageViewTracker
curl -O https://extdist.wmflabs.org/dist/extensions/UserPageViewTracker-REL1_42-476323a.tar.gz
tar -xzvf UserPageViewTracker*
rm UserPageViewTracker*tar.gz
mv UserPageViewTracker* extensions/
echo ".."
echo "."

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
echo "Downloading and installing cite"
echo 'See https://www.mediawiki.org/wiki/Extension:Cite#Installation'
echo 'https://stackoverflow.com/questions/71577367/in-mediawikis-tinymce-extension-how-to-enable-disable-buttons/72014409#72014409'
curl -O -L https://github.com/wikimedia/mediawiki-extensions-Cite/archive/refs/heads/master.zip
unzip master.zip
rm master.zip
mv mediawiki-extensions-Cite-master extensions/Cite
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

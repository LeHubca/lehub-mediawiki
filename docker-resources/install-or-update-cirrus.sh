#!/bin/bash
#
# setup the image; see Dockerfile.
#
set -e

echo " =>"
echo " => INSTALLING CIRRUS!"
echo " =>"

/docker-resources/test-communication-with-elasticsearch.sh

MW_INSTALL_PATH="/var/www/html"

if [ "$CIRRUS_HAS_BEEN_INSTALLED" == "1" ]; then
  echo "We think Cirrus has already been installed because the"
  echo "CIRRUS_HAS_BEEN_INSTALLED environment variable is set to 1."
  echo "We will not do anything. Cirrus calculates the total word count"
  echo "and displays it on /index.php/Special:Statistics."
  echo ""
  echo "Run indexing as described in"
  echo "https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README"

  php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipLinks --indexOnSkip

  php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipParse

  echo "It is not clear how this number is updated. Because when I add words to"
  echo "a page, the number stays the same."
else
  echo "We think Cirrus has not been installed because the"
  echo "CIRRUS_HAS_BEEN_INSTALLED environment variable is not set to 1."
  echo "Following instructions at:"
  echo "https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README"

  php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/UpdateSearchIndexConfig.php

  echo "At this point we need to set $CIRRUS_HAS_BEEN_INSTALLED to 1"
  echo "./docker-resources/load-extensions.php, the redeploying."
  echo "Setting CIRRUS_HAS_BEEN_INSTALLED to 1 in .env file is automatically"
  echo "done by the ./scripts/deploy.sh script."
fi
echo " =>"
echo " => INSTALLED CIRRUS."
echo " => You should now see the word count at /index.php/Special:Statistics."
echo " =>"

#!/bin/bash
#
# Test the running environment.
#
set -e

curl -L "http://$(docker-compose port mediawiki 80)"|grep "Main page"

docker-compose exec -T mediawiki /bin/bash -c '/docker-resources/test-communication-with-elasticsearch.sh'

echo ""
echo " => Done testing running environment."
echo ""

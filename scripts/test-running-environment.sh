#!/bin/bash
#
# Test the running environment.
#
set -e

curl -L "http://$(docker-compose port mediawiki 80)"|grep "Main page"
<<<<<<< HEAD
=======

echo ""
echo " => Done testing running environment."
echo ""
>>>>>>> dc6b85ac3192d96b32ecf9251c24a9d47fe5714f

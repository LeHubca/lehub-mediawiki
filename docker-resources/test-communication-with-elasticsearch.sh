#!/bin/bash
#
# setup the image; see Dockerfile.
#
set -e

echo "Testing communication between mediawiki and elasticsearch containers."

# The name of my ElasticSearch container is "elasticsearch", and I know it works because I can connect to it from my mediawiki container at:
#
#     curl -X GET "elasticsearch:9200/"
#     {
#         "name" : "0173fd63636f",
#         "cluster_name" : "docker-cluster",
#         "cluster_uuid" : "K-JMS-IOTKSc6Oz3qikR3w",
#         "version" : {
#             "number" : "7.17.8",
#             "build_flavor" : "default",
#             "build_type" : "docker",
#             "build_hash" : "120eabe1c8a0cb2ae87cffc109a5b65d213e9df1",
#             "build_date" : "2022-12-02T17:33:09.727072865Z",
#             "build_snapshot" : false,
#             "lucene_version" : "8.11.1",
#             "minimum_wire_compatibility_version" : "6.8.0",
#             "minimum_index_compatibility_version" : "6.0.0-beta1"
#         },
#         "tagline" : "You Know, for Search"
#     }
curl -X GET "elasticsearch:9200/" | grep cluster_name


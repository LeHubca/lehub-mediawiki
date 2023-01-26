Le Hub Wiki
-----

http://67.205.187.95:8080/index.php/Wiki-militant

This project uses Docker and Docker Compose to set up a fully working Wiki based on [Mediawiki](https://www.mediawiki.org/wiki/MediaWiki).

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/LeHubca/lehub-mediawiki/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/LeHubca/lehub-mediawiki/tree/master)

Quick start
-----

Start by making sure you have Docker and Docker Compose installed and running on your computer or on a Linux server. This has been tested on Intel-based mac OS and on Ubuntu, not on Windows.

Run the following:

    ./scripts/deploy.sh

And follow instructions therein.

Once installed, you can edit and create new pages as per the MediaWiki documentation you will find online.

Stopping the environment
-----

If you want to **destroy all your data**, run:

    ./scripts/destroy.sh

If you want to keep your data for next time, run:

    docker-compose down

Uploading your logo, or other files
-----

If you want to upload files:

* Make sure there is an unversioned file called LocalSettings.php at the root of your local directory.
* Edit that file and make sure it says "$wgEnableUploads = true;" (it will be false by default)
* Log in to your wiki and go to http://0.0.0.0:8080/index.php/Special:Upload
* Upload your logo, and on the resulting page open the image in a separate tab, note its URL, which will look like http://0.0.0.0:8080/images/6/6e/Logo.jpg
* Edit LocalSettings.php again and change the line '$wgLogos = [ '1x' => "$wgResourceBasePath/resources/assets/wiki.png" ];' to, in this example, '$wgLogos = [ '1x' => "/images/6/6e/Logo.jpg" ];'.
* Empty your browser cache, or try in a different browser you haven't used before, and you'll see your logo!

Installing extensions
-----

This starterkit provides a single extension, [EmbedVideo](https://www.mediawiki.org/wiki/Extension:EmbedVideo#Installation), but you can use its installation as a template to install your own extensions.

Extensions are installed in the Dockerfile, and you will probably need to modify that in your own fork or copy of this repo.

Errors and PHP logs
-----

Errors and notices will not be displayed on screen. To see the error logs you can run:

    tail ./do-not-commit/php-log.log

LetsEncrypt
-----

If you would like to use LetsEncrypt to host your wiki on a secure HTTPS protocol:

#### First, deploy as normal

    ./scripts/deploy.sh

#### Second, edit the unversioned .env file at the root of your project on your production Docker host, adding the following

    # .env
    ...
    VIRTUAL_HOST=example.com
    LETSENCRYPT_HOST=example.com
    LETSENCRYPT_EMAIL=admin@example.com

#### Third, deploy again

    ./scripts/deploy.sh

#### Finally, set up Letsencrypt

Follow the instructions in the following blog posts:

* [Letsencrypt HTTPS for Drupal on Docker, October 03, 2017, Dcycle Blog](https://blog.dcycle.com/blog/170a6078/letsencrypt-drupal-docker/)
* [Deploying Letsencrypt with Docker-Compose, October 06, 2017, Dcycle Blog](https://blog.dcycle.com/blog/7f3ea9e1/letsencrypt-docker-compose/)

Making a backup and restoring from a backup
-----

    ./scripts/make-backup.sh

Backups are stored in ./do-not-commit/backups

To restore from a backup, run:

    ./scripts/revert-from-backup.sh

Using the database from the command line
-----

    docker-compose exec database /bin/bash
    ...
    mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD"
    ...
    use my_wiki

You can now perform database operations.

You are encouraged to create a backup before fiddling with the database (see above).

Getting a database from a remote environment
-----

You must start by defining the remote environment, for example "stage", by copying the example (dummy) environment information, and putting in your real environment information. Something like:

    cp ./scripts/remote/environments/example ./scripts/remote/environments/stage

Then modify the file ./scripts/remote/environments/fr/info.source.sh with the stage environment information.

Now, every time you want to fetch the data from your stage environment, you would run:

    ./scripts/get-database-from-remote.sh stage

Elastic Search
-----

I have followed the instructions at https://www.mediawiki.org/wiki/Extension:CirrusSearch, https://www.mediawiki.org/wiki/Extension:CirrusSearch#Configuration and https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/docs/settings.txt,
https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README

Although https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README says:

> Only Elasticsearch v6.8 is supported.

But https://www.mediawiki.org/wiki/Extension:CirrusSearch#Configuration says:

> You must install the version of Elastic Search compatible with the version of > MediaWiki you are currently using:
> MediaWiki 1.29.x - 1.30.x require Elasticsearch 5.3.x - 5.4.x.
> MediaWiki 1.31.x - 1.32.x require Elasticsearch 5.5.x - 5.6.x.
> MediaWiki 1.33.x - 1.38.x require Elasticsearch 6.5.x - 6.8.x. (6.8.23+ recommended)
> MediaWiki 1.39+ require Elasticsearch 7.10.2 (6.8.23+ is possible using a compatibility layer)

The above assertions seem contradictory to me, so I used version 7.17.8 of ElasticSearch for the following reasons:

* First, that is the exact 7 version at https://hub.docker.com/_/elasticsearch
* Next, version 6.8 gave me the following error when running "php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/UpdateSearchIndexConfig.php" as required in https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README:

    Elastica\Exception\ResponseException from line 179 of /var/www/html/extensions/Elastica/vendor/ruflin/elastica/src/Transport/Http.php: Validation Failed: 1: type is missing;2: type is missing;3: type is missing;4: type is missing;5: type is missing;6: type is missing;7: type is missing;8: type is missing;9: type is missing;10: type is missing;11: type is missing;12: type is missing;13: type is missing;14: type is missing;15: type is missing;16: type is missing;17: type is missing;

* Finally, I am using ElasticSearch in Docker and the 6.8 version refuses to install on an M1 mac, making it necessary to run it on an Intel VM.

The name of my ElasticSearch container is "elasticsearch", and I know it works because I can connect to it from my mediawiki container at:

    curl -X GET "elasticsearch:9200/"
    {
        "name" : "0173fd63636f",
        "cluster_name" : "docker-cluster",
        "cluster_uuid" : "K-JMS-IOTKSc6Oz3qikR3w",
        "version" : {
            "number" : "7.17.8",
            "build_flavor" : "default",
            "build_type" : "docker",
            "build_hash" : "120eabe1c8a0cb2ae87cffc109a5b65d213e9df1",
            "build_date" : "2022-12-02T17:33:09.727072865Z",
            "build_snapshot" : false,
            "lucene_version" : "8.11.1",
            "minimum_wire_compatibility_version" : "6.8.0",
            "minimum_index_compatibility_version" : "6.0.0-beta1"
        },
        "tagline" : "You Know, for Search"
    }

Once I had a running Mediawiki and ElasticSearch container, I followed the instructions at https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README:

I started with:

    wfLoadExtension( 'Elastica' );
    wfLoadExtension( 'CirrusSearch' );
    $wgDisableSearchUpdate = true;
    $wgCirrusSearchServers = [ 'elasticsearch' ];

Then I ran

    php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/UpdateSearchIndexConfig.php

This resulted in

    Updating cluster ...
    indexing namespaces...
    mw_cirrus_metastore missing, creating new metastore index.
    Creating metastore index... mw_cirrus_metastore_first	Scanning available plugins...none
    ok
            Green!Creating mw_cirrus_metastore alias to mw_cirrus_metastore_first.
        Indexing namespaces...done
    content index...
        Fetching Elasticsearch version...7.17.8...partially supported
    You use a version of elasticsearch that is partially supported, you should upgrade to 7.10.x

        Scanning available plugins...none
        Picking analyzer...english
        Inferring index identifier...my_wiki_content_first
        Creating index...ok
            Validating number of shards...ok
            Validating replica range...ok
            Validating shard allocation settings...
                Clearing 'include' allocations...done
            Validating max shards per node...ok
        Validating analyzers...ok
        Validating mappings...
            Validating mapping...different...corrected
        Validating aliases...
            Validating my_wiki_content alias...alias is free...corrected
            Validating my_wiki alias...alias not already assigned to this index...corrected
            Updating tracking indexes...done
    general index...
        Fetching Elasticsearch version...7.17.8...partially supported
    You use a version of elasticsearch that is partially supported, you should upgrade to 7.10.x

        Scanning available plugins...none
        Picking analyzer...english
        Inferring index identifier...my_wiki_general_first
        Creating index...ok
            Validating number of shards...ok
            Validating replica range...ok
            Validating shard allocation settings...
                Clearing 'include' allocations...done
            Validating max shards per node...ok
        Validating analyzers...ok
        Validating mappings...
            Validating mapping...different...corrected
        Validating aliases...
            Validating my_wiki_general alias...alias is free...corrected
            Validating my_wiki alias...alias not already assigned to this index...corrected
            Updating tracking indexes...done

Then I removed the line "$wgDisableSearchUpdate = true" from my LocalSettings.php

Then I ran an the indexing as described in https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README:

    php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipLinks --indexOnSkip
    [             my_wiki] Indexed 2 pages ending at 2 at 70/second
    Indexed a total of 2 pages at 70/second
    php $MW_INSTALL_PATH/extensions/CirrusSearch/maintenance/ForceSearchIndex.php --skipParse
    [             my_wiki] Indexed 2 pages ending at 2 at 49/second
    Indexed a total of 2 pages at 49/second

Then I DID NOT ADD the following line to LocalSettings.php:

    // $wgSearchType = 'CirrusSearch'; DO NOT ADD THIS

As that makes Searching result in "An error has occurred while searching: We could not complete your search due to a temporary problem. Please try again later.". We do not care about that, as the only reason we want Cirrus and Elastic Search is to perform a word count.

My wiki currently has one page, Main Page at index.php/Main_Page, and contains a number of sentences, among which the following:

    "MediaWiki FAQ"

Therefore I know I have at least 2 words in my wiki, and the above commands confirmed that the pages were indexed because it says "Indexed a total of 2 pages at 70/second".

You can now visit http://0.0.0.0:8187/index.php/Special:Statistics and see the total word count.

It is not clear, at this point, how this number is updated. Because when I add words to a page, the number stays the same.

Resources
-----

* [MediaWiki Docker image](https://hub.docker.com/_/mediawiki)

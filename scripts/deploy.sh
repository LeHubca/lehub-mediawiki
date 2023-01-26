#!/bin/bash
#
# Deploy an environment
#
set -e

echo ''
echo '-----'
echo 'Ensuring the integrity of the .env file.'
source ./scripts/lib/assert-env.source.sh

echo ''
echo '-----'
echo 'Pulling the latest docker images that we need.'
docker pull mariadb
docker pull mediawiki

echo ''
echo '-----'
echo 'Starting the environment.'
docker build --progress=plain -f="Dockerfile" .
docker-compose up -d --build
if [[ -f LocalSettings.php ]]; then
  echo '(LocalSettings.php exists, just updating the installation with existing details.)'
  docker cp LocalSettings.php $(docker-compose ps -q mediawiki):/var/www/html/LocalSettings.php
else
  echo '(LocalSettings.php does not exist, performing initial set up.)'
  docker-compose up -d
fi

if [[ ! -f ./LocalSettings.php ]]; then
  echo ''
  echo '-----'
  echo 'Importing starter data...'
  ./scripts/wait-for-database.sh
  cp ./starter-data/LocalSettings.example.php ./LocalSettings.php
  rm -rf ./do-not-commit/backups/starter
  docker-compose exec mediawiki /bin/bash -c 'mkdir -p /do-not-commit/backups'
  docker-compose exec mediawiki /bin/bash -c 'cp -r /starter-data/data /do-not-commit/backups/starter'
  ./scripts/revert-from-backup.sh starter
  docker-compose exec mediawiki /bin/bash -c 'rm -rf /do-not-commit/backups/starter'
  echo 'Redeploying...'
  ./scripts/deploy.sh
else
  echo ''
  echo '-----'
  echo 'Run the update script.'
  docker-compose exec -T mediawiki /bin/bash -c 'php maintenance/update.php'
  echo ''
  echo '-----'
  echo 'Resetting admin password.'
  ./scripts/reset-password.sh admin
  echo ''

  docker-compose exec -T mediawiki /bin/bash -c \
    '/docker-resources/install-or-update-cirrus.sh'

  NEED_TO_DEPLOY_AGAIN_BECAUSE_CIRRUS_WAS_JUST_INSTALLED=0

  cat .env|grep CIRRUS_HAS_BEEN_INSTALLED || NEED_TO_DEPLOY_AGAIN_BECAUSE_CIRRUS_WAS_JUST_INSTALLED=1

  # Cirrus is now installed, whether or not it was installed before.
  cat .env|grep CIRRUS_HAS_BEEN_INSTALLED || echo "CIRRUS_HAS_BEEN_INSTALLED=1" >> .env

  if [ "$NEED_TO_DEPLOY_AGAIN_BECAUSE_CIRRUS_WAS_JUST_INSTALLED" = 1 ]; then
    echo "Cirrus has just been installed, we need to deploy again for"
    echo "./docker-resources/install-or-update-cirrus.sh to perform some"
    echo "extra tasks."
    ./scripts/deploy.sh
  fi

  echo '-----'
  echo 'Getting the login details.'
  ./scripts/uli.sh
fi

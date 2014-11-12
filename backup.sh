#!/bin/bash

./readsites d

TOTAL_SITES=$(./readsites l)

while ((1));
do
  COUNTER=0
  for SITE in $TOTAL_SITES;
  do
    SITE_LOGIN=$(./readsites g $COUNTER l)

    echo Backing up site $SITE

    lftp -e "mirror --exclude _wpeprivate --exclude mwp_db --exclude mu-plugins --exclude object-cache.php --exclude managewp wp-content ./backups/$SITE; bye" -u $SITE_LOGIN sftp://livemercury.wpengine.com

    let COUNTER=COUNTER+1
  done;
done
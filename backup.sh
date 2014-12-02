#!/bin/bash

while ((1));
do
  ./readsites d

  TOTAL_SITES=$(./readsites l)

  COUNTER=0
  for SITE in $TOTAL_SITES;
  do
    echo Backing up site $SITE

    lftp -e "mirror ./ ./backups/$SITE; bye" -u $(./readsites g $COUNTER l) sftp://$(./readsites g $COUNTER h)

    let COUNTER=COUNTER+1
  done;
done
#!/bin/bash

TOTAL_SITES=$(./readsites l)

while ((1));
do
  COUNTER=0
  for SITE in $TOTAL_SITES;
  do
    SITE_HOST=$(./readsites g $COUNTER h)

    echo Pinging site $SITE

    DATE=$(date +"%a %b %e %H:%M")
    PING_OUTPUT=$(ping -o $SITE_HOST)

    if [ $? -ne 0 ];
    then
      echo $DATE - $SITE_HOST >> pingerr.log;
    fi

    let COUNTER=COUNTER+1
  done;
done
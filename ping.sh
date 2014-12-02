#!/bin/bash

while ((1));
do
  TOTAL_SITES=$(./readsites l)

  COUNTER=0
  for SITE in $TOTAL_SITES;
  do
    SITE_HOST=$(./readsites g $COUNTER h)

    DATE=$(date +"%a %b %e %H:%M")
    PING_OUTPUT=$(ping -o $SITE_HOST)

    if [ $? -ne 0 ];
    then
      echo $DATE - $SITE_HOST >> pingerr.log;
    fi

    let COUNTER=COUNTER+1
  done;
done
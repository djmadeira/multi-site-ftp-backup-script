#!/bin/bash

COUNTER=1
FILE=$1
DEST=$2

if [ -z "$FILE" ];
then
	echo "No config file supplied"
	exit
fi

if [ -z "$DEST" ];
then
	echo "No destination path supplied"
	exit
fi

NAME=$(csvr -r $COUNTER -c 0 $FILE)
while [ $? -eq 0 ];
do
	DIR=$(csvr -r $COUNTER -c DIR $FILE)
	PROTOCOL=$(csvr -r $COUNTER -c PROTOCOL $FILE)
	USER=$(csvr -r $COUNTER -c USER $FILE)
	PASS=$(csvr -r $COUNTER -c PASSWORD $FILE)
	HOST=$(csvr -r $COUNTER -c HOST $FILE)
	KEEP=$(csvr -r $COUNTER -c KEEP $FILE)
	DATE=$(date "+%y-%m-%d-%H-%M")

	echo "Backing up site \"$NAME\""

	if [ -z "$KEEP" ];
	then
		KEEP=0
	fi

	case $PROTOCOL in
	ftp | FTP)
		SSLENABLE="false"
		echo "WARNING: DOWNLOADING INSECURELY. YOU SHOULD ONLY USE FTP FOR PUBLIC FILE SHARING.";;
	*)
		SSLENABLE="true";;
	esac

	if [ ! -d $DEST/$NAME ];
	then
		mkdir -p $DEST/$NAME
	fi

	CONNERR=$(lftp -e "set ftp:ssl-allow $SSLENABLE; set net:max-retries 1; set cmd:trace true; ls; bye" -u $USER,$PASS $PROTOCOL://$HOST)

	if [ $? -eq 0 ]
	then
		lftp -e "set ftp:ssl-allow $SSLENABLE; mirror $DIR $DEST/$NAME; pwd; bye" -u $USER,$PASS $PROTOCOL://$HOST
	else
		echo "$CONNERR"
		echo "Error connecting to site \"$NAME\". Verify that the login, host and protocol are correct."
	fi

	if [ $KEEP -gt 0 ]
	then
		tar -zcf $DEST/$NAME.$DATE.tar.gz -C $DEST $NAME

		REMOVE="$(find $DEST -maxdepth 1 -not -type d | grep $NAME)"
		TOTALCOUNT=$(wc -l <<< "$REMOVE")
		RMCOUNT=$(($TOTALCOUNT - $KEEP))
		if [ $RMCOUNT -lt 0 ]
		then
			RMCOUNT=0
		fi
		REMOVE=$(tail -n $RMCOUNT <<< "$REMOVE")
	fi

	for RMFILE in $REMOVE;
	do
		rm -f $RMFILE
	done

	let COUNTER=COUNTER+1
	NAME=$(csvr -r $COUNTER -c 0 $FILE)
done
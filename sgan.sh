#!/bin/bash

CREATE_TABLE="CREATE TABLE scan_data (id INTEGER PRIMARY KEY,hash TEXT,location TEXT, status TEXT);";

TEMP_DB=/tmp/sgan.$RANDOM.sqlite
TEMP_NETCAT=/tmp/sgan.$RANDOM.netcat

sqlite3 $TEMP_DB "$CREATE_TABLE"

echo begin >> $TEMP_NETCAT

(find . -type f -print0 | xargs -0 md5sum)|while read line
do
 HASH=`echo $line | cut -f1 -d" "`
 LOCATION=`echo $line | cut -f2 -d" "`
 sqlite3 $TEMP_DB  "insert into scan_data (hash,location) values ('$HASH','$LOCATION');"
 echo $HASH >> $TEMP_NETCAT
done

echo end >> $TEMP_NETCAT

netcat hash.cymru.com 43 < $TEMP_NETCAT | sed -e '/^\#/d'

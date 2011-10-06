#!/bin/bash

CREATE_TABLE="CREATE TABLE scan_data (id INTEGER PRIMARY KEY,hash TEXT,location TEXT, status TEXT);";

TEMP_DB=/tmp/scan.$RANDOM.sqlite
#TEMP_NETCAT=/tmp/scan.$RANDOM.netcat
#TEMP_REPORT=/tmp/scan.$RANDOM.report.txt

sqlite3 $TEMP_DB "$CREATE_TABLE"


(find . -type f -print0 | xargs -0 md5sum)|while read line
do
 HASH=$line | cut -f1 -d" "
 LOCATION=$line | cut -f2 -d" "
 sqlite3 $TEMP_DB  "insert into scan_data (hash,location) values ('$HASH','$LOCATION');"
done



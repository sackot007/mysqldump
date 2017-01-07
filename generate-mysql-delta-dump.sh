#!/bin/sh

SCHEMA_NAME=$1
TABLE_NAME=$2
echo "Generating Delta feed for " $TABLE_NAME " in schema " $SCHEMA_NAME
FILE=./deltafeed/$SCHEMA_NAME_$TABLE_NAME-delta_`date +"%Y-%m-%d_%T"`.sql

DELTA_CONDITION=''

if [ ! $TABLE_NAME = "Notification" ]
then
        echo "In If"
        DELTA_CONDITION='--where=DATE(LastUpdatedTime)=DATE(CURDATE()-1)'
fi

echo $DELTA_CONDITION
echo "Run mysqldump command for "$SCHEMA_NAME"."$TABLE_NAME"  delta"
/usr/bin/mysqldump --defaults-extra-file=/home/adminkmp/dbscripts_delta/dbconfig.prop --replace --no-create-info --no-create-db $SCHEMA_NAME $TABLE_NAME $DELTA_CONDITION >> $FILE

echo "Gzip generated file: "$FILE
gzip $FILE
echo "Gzip process of file " $FILE "completed"

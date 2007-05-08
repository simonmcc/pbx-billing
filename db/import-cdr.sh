#!/bin/bash
#
SQLITE2=/home/servers/pbxware/pw/sh/sqlite 
PBXCDR=/home/servers/pbxware/pw/var/log/asterisk/cdr.db
LOCALCDR=cdr-`date +%Y%m%d`.db
CDRSQL=cdr-`date +%Y%m%d`.sql
CDRPSQL=cdr-`date +%Y%m%d`.psql

DBNAME=pbxware_dev
DBHOST=192.168.200.18
DBUSER=pbxware

cp $PBXCDR $LOCALCDR

sqlite $LOCALCDR '.dump cdr' > $CDRSQL

sed -e 's/start\t\tCHAR(19)/start timestamp/' \
    -e 's/answer\t\tCHAR(19)/answer timestamp/' \
    -e 's/end\t\tCHAR(19)/cend timestamp/' \
    -e 's/CREATE TABLE cdr /CREATE TABLE pbxcdrs/' \
    -e 's/INTO cdr VALUES/INTO pbxcdrs VALUES/' < $CDRSQL > $CDRPSQL


echo 'DROP TABLE pbxcdrs;' | psql -d $DBNAME -U $DBUSER -h $DBHOST
psql -d $DBNAME -U $DBUSER -h $DBHOST < $CDRPSQL

#!/bin/sh

. $HOME/.profile

cd
cd voltdb-iotcars/ddl

sqlcmd --servers=vdb1 < voltdb-iotcars-createDB.sql


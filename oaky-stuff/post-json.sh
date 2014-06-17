#!/bin/bash
set -e

USER=admin:admin
HOST=http://localhost:8080
CURL=curl

# curl -u admin:admin -X POST -T index-definition.json http://localhost:8080/oak:index/davide

if [ -z "$1" -o -z "$2" ] 
then
	echo "Usage: ./post-json.sh index-definition.json /oak:index/myindex"
	exit 1
else
	$CURL -u $USER -H "Accept: application/json" -H "Content-Type: application/json; charset=utf-8" -X POST -T $1 ${HOST}${2}
fi

#!/bin/bash
set -e

if [ -z "$1" ]
then
	echo "usage: ./delete-node.sh /content"
	exit 1
fi

curl -u admin:admin -H "Content-Type: application/json" -H "Accept: application/json" -X DELETE http://localhost:8080$1

#!/bin/bash
set -e
# execute a 'single line' of test. Useful for being reused by others
# shell scripts
#
# Usage:
#   atomic-benchmark.sh <oak-jar> <tests> <log-file> [pre-added-nodes] [nodes-per-iteration]
# 
#   [pre-added-nodes] and [nodes-per-iteration] are optional and mean respectively a number of nodes to be added 
#       before running the test and the number of nodes to be inserted during the test. Assuming the test will
#       cope with them.       
#
# for example
#
# ./atomic-benchmark.sh oak-run-*.jar "OrderedIndexInsertNoIndexTest OrderedIndexInsertStandardPropertyTest OrderedIndexInsertOrderedPropertyTest"  /var/log/foobar.log

FIXTURES=Oak-Tar
RUNTIME=15
WARMUP=0

if [ -z "$1" -o -z "$2" -o -z "$3" ]
then
    echo "Wrong command line. Please see in-line comments"
    exit 1
fi
        
OAK_JAR=$1
TESTS=$2
LOG=$3

PRE_ADDED_NODES=
if [ ! -z "$4" ] 
then
    PRE_ADDED_NODES="-DpreAddedNodes=${4}"
fi

NODES_PER_ITERATION=
if [ ! -z "$5" ] 
then
    NODES_PER_ITERATION="-DnodesPerIteration=${5}"
fi

java -Xmx2048m -Dprofile=false -Druntime=${RUNTIME} -Dwarmup=${WARMUP} \
   -Dlogback.configurationFile=logback-benchmark.xml \
   $PRE_ADDED_NODES \
   $NODES_PER_ITERATION \
   -jar ${OAK_JAR} benchmark \
   --concurrency 1 --runAsAdmin false --report false --randomUser true \
   $TESTS \
   $FIXTURES | tee -a $LOG
   

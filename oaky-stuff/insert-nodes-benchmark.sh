#!/bin/bash
set -e
# Execute the required benchmark(s) for testing
# the throughput of the OrderedIndex 
# 
# ./benchmark.sh <path-to-oak-jar> 
#
# for example
#
# ./benchmark.sh oak-run-*.jar 

TESTS="OrderedIndexInsertNoIndexTest OrderedIndexInsertStandardPropertyTest OrderedIndexInsertOrderedPropertyTest"
NOW=`date +%Y%m%d%H%M%S`
LOG="./benchmark-${NOW}.log"

NODES_ITERATION="100 200 300 400 500 600 700 800 900 1000"
OAK_JAR=oak-run-*.jar

if [ -z "$1" ] 
then
    echo "please provide correct command line (see comments) in file"
    exit 1
else
    OAK_JAR=$1
fi

for nodes in ${NODES_ITERATION}
do
    echo "Nodes per iteration: ${nodes}" | tee -a $LOG
    ./atomic-benchmark.sh $OAK_JAR "$TESTS" $LOG 0 $nodes
done

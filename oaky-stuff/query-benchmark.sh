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

TESTS="OrderedIndexQueryNoIndexTest OrderedIndexQueryStandardIndexTest OrderedIndexQueryOrderedIndexTest"
NOW=`date +%Y%m%d%H%M%S`
LOG="./benchmark-${NOW}.log"

NODES_ITERATION="100 200 300 400 500 600 700 800 900 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 20000 30000 40000 50000"
#NODES_ITERATION="10000"
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
    ./atomic-benchmark.sh $OAK_JAR "$TESTS" $LOG $nodes 0
done

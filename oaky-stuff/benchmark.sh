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

TESTS="NoIndexesOrderByInsertTest StandardPropertyIndexOrderByInsertTest OrderedPropertyIndexOrderByInsertTest"
FIXTURES=Oak-Tar
RUNTIME=60
WARMUP=30
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
	java -Xmx2048m -Dprofile=false -Druntime=${RUNTIME} -Dwarmup=${WARMUP} \
	    -Dlogback.configurationFile=logback-benchmark.xml \
        -DpreAddedNodes=${nodes} \
        -DnodesPerIteration=100 \
        -jar ${OAK_JAR} benchmark \
	    --concurrency 1 --runAsAdmin false --report false --randomUser true \
	    $TESTS \
	    $FIXTURES | tee -a $LOG
done

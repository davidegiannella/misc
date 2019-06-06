#!/bin/bash
# Copyright 2019g Davide Giannella
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------
#
# simple bash script that will go backwards in time by N commits and will compute the size of the generated artifact
# in a maven project.

set -e

GIT_REPO=${1:-""}
ARTIFACT_NAME=${2:-""}
NUMBER_COMMITS=${3:-""}
MVN_XTRAS=${4:-""}

COMMAND=`basename $0`
CURR_DIR=`pwd`
BUILD_DIR="${CURR_DIR}/target"
SKIP_TESTS="-DskipTests" # provides maven with skipping tests
SIZES_FILE="${BUILD_DIR}/sizes.csv"

function msg {
    level=${1:-""}
    m=${2:-""}
    echo "[${level}] ${m}"
}

function info {
    msg "INFO" "${1}"
}

function error {
    msg "ERROR" "${1}" >&2
}

function warn {
    msg "WARN" "${1}"
}

function usage {
    echo
    echo "======================================================================"
    echo "                                 USAGE "
    echo " \$ bash $COMMAND <GIT_REPO> <ARTIFACT_NAME> <NUMBER_COMMITS> [MVN_XTRAS]"
    echo
    echo "    - GIT_REPO. Mandatory. The ALREADY CLONED git repo on FS."
    echo "    - ARTIFACT_NAME. Mandatory. Name of generated jar for the size."
    echo "        It has to be relative and precise; for example"
    echo "        target/my-artifact-6.0.jar"
    echo "    - NUMBER_COMMITS. Mandatory. The number of commits to go backward"
    echo "        looking for the artifact size"
    echo "    - MVN_XTRAS. Any extra maven command line arguments. They will be "
    echo "        in as they are provided. For example \"-PmyProfile -Dvar=123\""
    echo "======================================================================"
}

if [ ! -d "${GIT_REPO}" ]
then
    error "missing or wrong GIT_REPO"
    usage
    exit 1
fi

if [ -z "${ARTIFACT_NAME}" ]
then
    error "missing artifact name"
    usage
    exit 1
fi

if [[ "${NUMBER_COMMITS}" =~ ^[^0-9]*$ ]]
then
    error "NUMBER_COMMITS is not a valid number. Only integer"
    usage
    exit 1
fi
# forcing integer
NUMBER_COMMITS=${NUMBER_COMMITS%.*}

if [ -d "${BUILD_DIR}" ]
then
    info "BUILD_DIR already there. Deleting."
    rm -rf ${BUILD_DIR} 2>&1 > /dev/null
fi
mkdir ${BUILD_DIR}

info "Going through ${NUMBER_COMMITS} commits"

cd $GIT_REPO
COMMIT_LIST=`git log -n ${NUMBER_COMMITS} --pretty=format:"%H" --reverse`
tmp=`mktemp`

for commit in $COMMIT_LIST
do
    meta=`git show ${commit} --pretty=format:"%H, %aI, %an, <%ae>" --no-patch`
    logFile="${BUILD_DIR}/${commit}.log"

    info "Processing ${commit} see ${logFile}"

    if ! ( exec git checkout --progress ${commit} &> "${tmp}" )
    then
        cat $tmp >> ${logFile}
        error "Failed in checkout commit: ${commit}. Halting. See ${logFile}"
        exit 1
    fi
    cat $tmp >> ${logFile}

    if ! (exec mvn clean package ${SKIP_TESTS} ${MVN_XTRAS} 2>&1 >> ${logFile} )
    then
        error "Failure in running maven build. See ${logFile}"
        exit 1
    fi

    if [ -f "${ARTIFACT_NAME}" ]
    then
        size=`ls -l ${ARTIFACT_NAME} | awk '{print $5}'`
    else
        error "The file ${ARTIFACT_NAME} cannot be found. Please double-check"
        size="FAIL"
    fi
    line="${size}, ${meta}"

    info "${line}"
    echo "${line}" >> ${SIZES_FILE}

    if ! ( exec git checkout --progress - &> ${tmp} )
    then
        cat $tmp >> ${logFile}
        error "Failed in checkout previous HEAD. Halting. See ${logFile}"
        exit 1
    fi
    cat $tmp >> ${logFile}
done

rm ${tmp}
cd $CURR_DIR
info "Done. Check ${SIZES_FILE} for all the sizes."
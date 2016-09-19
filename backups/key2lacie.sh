#!/bin/bash
set -e

# Copy the `key` to a backup drive (Lacie).
#
# Usage:
#   bash key2lacie.sh <source> <destination>

SOURCE=$1
DEST=$2
DT=`date +"%Y-%m-%d-%H%M"`
LOG="`pwd`/`basename ${0}`-${DT}.log"

if [ -z "$SOURCE" -o -z "$DEST" ]
then 
    echo "ERROR: provide source and destination"
    echo "Usage:"
    echo "    bash $0 <source> <destination>"
    exit 1
fi

if [ ! -d "$SOURCE" ]
then
    echo "ERROR: source directory is not there or not a directory. '${SOURCE}'"
    exit 1
fi

if [ ! -d "$DEST" ]
then
    echo "ERROR: backup volume not found. Manually mount the drive at '${DEST}'"
    exit 1
fi

echo "Backing up from '${SOURCE}' to '${DEST}' at ${DT}" | tee -a ${LOG}

rsync -rtDv --delete ${SOURCE} ${DEST} 2>&1 | tee -a ${LOG}

echo "Done. Logs on '${LOG}'"
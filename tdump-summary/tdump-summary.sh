#!/bin/bash
set -e

# generates a report in MarkDown format with an overall view of the provided thread dump.
#
# Usage:
#   ./tdump-summary.sh <path-to-tdump-file>

TD=$1
BN=`basename $0`
TMP1=`mktemp -t $BN`
TMP2=`mktemp -t $BN`

# Ignoring packages file
IGNORE_PKG="pkg-ignore.txt"

# Number of lines for filtering with head command
TOP=50

COMMENT_LINE_REGEX='^[:space:]*#.*'
EMPTY_LINE_REGEX='^[:space:]*$'

##
# print $1 as a code block in MarkDown syntax
function printCode {
    echo "    $1"
}

##
# empty all the created temp files
function emptyTmp {
    > $TMP1
    > $TMP2
}

##
# remove the created temp files
function cleanup {
    rm $TMP1
    rm $TMP2
}

##
# print the provided file in $1 as code for Markdown Syntax
function printFileCode {
    awk '{ print "    "$0 }' $1
}

if [ -f "$TD" ]
then
    echo "# Thread Dump Summary"
    echo "Analysing file: $TD"
    
    echo
    echo "## Number of thread dumps"
    num=`grep -c '^Full thread dump' $TD`
    printCode $num

    echo
    echo "## Top $TOP classes"
    emptyTmp    
    echo
    grep -E "^\tat" $TD | sed -E 's/^.*at (.*)\(.*/\1/' > $TMP1

    if [ -f "$IGNORE_PKG" ] 
    then
        echo "_excluding packages from file: ${IGNORE_PKG}_"
        echo
        while read package ; do
            if [[ $package =~ $COMMENT_LINE_REGEX || $package =~ $EMPTY_LINE_REGEX ]] 
            then
                : # Ignoring line starting with '#'
            else
                grep -Ev "$package" $TMP1 > $TMP2
                cp $TMP2 $TMP1
            fi
        done <"$IGNORE_PKG"
    else
        echo "_Ignore package file not found. Not excluding anything_"
        echo
    fi
    
    sort $TMP1 | uniq -c | sort -rn | head -n $TOP > $TMP2
    printFileCode $TMP2
    
    echo
    echo "## Thread status"
    echo
    emptyTmp
    grep java.lang.Thread.State ~/tmp/tds.log | sed 's/^[[:space:]]*\(.*\)$/\1/' | sort | uniq -c > $TMP1
    printFileCode $TMP1
    
    cleanup
else
    echo
    echo "Please provide path to the tdump file"
    echo "./tdump-summary.sh <path-to-tdump-file>"
    
    cleanup
    
    exit 1
fi
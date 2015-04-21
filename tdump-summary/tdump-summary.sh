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
ARGS="$@"

# Ignoring packages file
IGNORE_PKG="pkg-ignore.txt"

# Number of lines for filtering with head command
TOP=50

COMMENT_LINE_REGEX='^[:space:]*#.*'
EMPTY_LINE_REGEX='^[:space:]*$'
THREAD_LINE_REGEX='^\"(.*)\"'

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


##
# to be used straght in ifs: if hasOption "-myopt" ; then ...
#
# makes use of the global env variable ARGS
#
# $1 is the option to look for.
# return true (0) if the command line contains the provided function. false (1) otherwise.
function hasOption {
    for a in $ARGS
    do
        if [ "$a" = "$1" ]
        then
            return 0
        fi
    done
	return 1
}

##
# retrieve an option value passed in the form of -option <value>. Makes use of global variable ARGS.
# 
# $1 the option to be looked for
# return the next argument as value of empty if not found
function getOptionValue {
    isNext=1
    for a in $ARGS
    do
        if [ "$a" = "$1" ] 
        then
           isNext=0
           continue
        fi
        if [ $isNext -eq 0 ] 
        then
            echo $a
            return
        fi
    done
    echo ""
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
    grep java.lang.Thread.State $TD | sed 's/^[[:space:]]*\(.*\)$/\1/' | sort | uniq -c > $TMP1
    printFileCode $TMP1
        
      
    # if we have "-c" on the command line we want to know in which threads a specific class occurs  
    if hasOption "-c"
    then
        lookfor=`getOptionValue "-c"`
        
        echo
        echo "## Specific class lookup"
        echo
        echo "_${lookfor} found in threads_"
        echo
        currentThread=""
        alreadyProcessed=1
        while read -r line ; do
            if [[ $line =~ $THREAD_LINE_REGEX ]]
            then
                currentThread=$line
                alreadyProcessed=1
            else
                if [[ $line =~ .*${lookfor}.* && $alreadyProcessed -eq 1 ]]
                then
                    printCode $currentThread
                    alreadyProcessed=0
                fi
            fi
        done <"$TD"
    fi
    
    cleanup
else
    echo
    echo "Please provide path to the tdump file"
    echo "./tdump-summary.sh <path-to-tdump-file>"
    
    cleanup
    
    exit 1
fi
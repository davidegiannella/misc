# Thread Dump Summary

It's the effort of simplify my life when analysing thread dumps by
producing a quick report that could highlight bottlenecks and/or
blockers.

It will produce on the stdout a markdown formatted report based on the
provided set of thread dumps

_Feel free to ask or provide any new feature and/or bug fixing._

## Installation

1. Download the shell script and the exclusion txt file
2. Give the shell script execution permission
        chmod 777 tdump-summary.sh

## Usage

    ./tdump-summary.sh <path-to-tdumps>


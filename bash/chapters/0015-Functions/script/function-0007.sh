#!/usr/bin/env bash
# Script: function-0007.sh
custom1() {
    local localVar=324
    globalVar=123
    echo "localVar: $localVar"
    echo "Done with $FUNCNAME"
}
echo "Local variable before function: $localVar"
echo "Global variable before function: $globalVar"
custom1
echo "Local variable after function: $localVar"
echo "Global variable after function: $globalVar"

#!/usr/bin/env bash
#Script: unset_variable.sh

myLargeVariable="abcdefghijklmnopqrstuvwxyz..."
echo "Variable: '${myLargeVariable}'"

echo "Unsetting variable"
unset myLargeVariable
echo "Variable unset"

echo "Variable: '${myLargeVariable}'"

echo "End of Program"


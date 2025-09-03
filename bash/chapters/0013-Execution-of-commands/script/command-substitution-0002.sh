#!/usr/bin/env bash
#Script: command-substitution-0002.sh
echo "Saving the result of ls"
RESULT=$(ls)
echo -e "Result is:\n $RESULT"

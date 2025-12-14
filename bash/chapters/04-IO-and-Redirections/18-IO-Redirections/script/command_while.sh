#!/usr/bin/env bash
#Script: command_while.sh
regex="File_([0-9a-zA-Z])"
while read line; do
    if [[ $line =~ $regex ]]; then
        echo ${BASH_REMATCH[1]}
    else
        echo "Error"
    fi
done

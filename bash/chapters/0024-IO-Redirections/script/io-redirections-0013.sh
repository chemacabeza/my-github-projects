#!/usr/bin/env bash
#Script: io-redirections-0013.sh
myFunction() {
    local INPUT=()
    local index=0
    local IFS=$'\n'
		# Read from standard input
    while read -r MY_INPUT; do
        INPUT[$index]="$MY_INPUT"
        index=$(($index+1))
    done
    # Echo to standard output
    for item in ${INPUT[@]}; do
        local length=${#item}
        echo "ITEM[$item]: $length"
    done
}
# Piping "ls" command to "myFunction"
ls -l | myFunction

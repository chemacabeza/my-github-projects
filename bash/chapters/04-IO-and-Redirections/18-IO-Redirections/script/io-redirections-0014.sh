#!/usr/bin/env bash
#Script: io-redirections-0014.sh
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
# Piping "ls -l" command to "grep" command 
# Piping "grep" command to "myFunction"
ls -l | grep ".txt" | myFunction
# Echoing the full array of PIPESTATUS
echo "PIPESTATUS: ${PIPESTATUS[@]}"

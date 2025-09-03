#!/usr/bin/env bash
#Script: io-redirections-0016.sh
INPUT_ARGS=($@)
echo "Number of arguments: ${#INPUT_ARGS[@]}"
declare -i position=0
for arg in ${INPUT_ARGS[@]}; do
    echo "Argument[$position]: $arg"
    ((position++))
done

#!/usr/bin/env bash
#Script: loop-005.sh
# Declaration of an array
declare -a MY_ARRAY=("Item 1" "Item 2" "Item 3")
# Loop iterating through elements of the array
for ((i = 0; i < ${#MY_ARRAY[@]}; i++))
do
    echo "MY_ARRAY[$i]: ${MY_ARRAY[$i]}"
done

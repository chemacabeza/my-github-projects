#!/usr/bin/env bash
#Script: loop-001.sh
# Declaration of the array
declare -a MY_ARRAY=("Item1" "Item2" "Item3")
# Using the for loop to iterate through the array
for item in ${MY_ARRAY[@]}; do
    echo "Item: $item"
done

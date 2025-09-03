#!/usr/bin/env bash
#Script: loop-002.sh
# Declaration of the array
declare -a MY_ARRAY=("Item 1" "Item 2" "Item 3")
# Using the for loop to iterate through the array
for item in ${MY_ARRAY[@]}; do
    echo "Item: $item"
done

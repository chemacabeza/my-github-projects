#!/usr/bin/env bash
#Script: index_array_length.sh
MY_ARRAY=("value1" "value2" "value3")
echo "Length-1: ${#MY_ARRAY[*]}"
echo "Length-2: ${#MY_ARRAY[@]}"

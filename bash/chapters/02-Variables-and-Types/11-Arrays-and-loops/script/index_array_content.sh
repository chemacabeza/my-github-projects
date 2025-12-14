#!/usr/bin/env bash
#Script: index_array_content.sh
MY_ARRAY=("value1" "value2" "value3")
echo "Content 1: ${MY_ARRAY[*]}"
echo "Content 2: ${MY_ARRAY[@]}"


#!/usr/bin/env bash
#Script: index_array_add.sh
MY_ARRAY=("value1" "value2" "value3")
echo "Elements: ${MY_ARRAY[@]}"
MY_ARRAY+=("value4")
echo "Elements: ${MY_ARRAY[@]}"

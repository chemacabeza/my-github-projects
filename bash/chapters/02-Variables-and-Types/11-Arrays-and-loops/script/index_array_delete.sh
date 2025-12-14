#!/usr/bin/env bash
#Script: index_array_delete.sh
MY_ARRAY=("value1" "value2" "value3")
# Deleting second item of the array
unset MY_ARRAY[1]
# Printing the whole content of the array
echo "Content: ${MY_ARRAY[@]}"

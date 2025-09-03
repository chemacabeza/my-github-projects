#!/usr/bin/env bash
#Script: delete_array.sh
MY_ARRAY=( one two three four five six )
echo "Content: '${MY_ARRAY[@]}'"
# Deleting the array
unset MY_ARRAY
echo "Content after deletion: '${MY_ARRAY[@]}'"

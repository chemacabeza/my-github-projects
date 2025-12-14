#!/usr/bin/env bash
#Script: array_concatenate.sh
# Declare three different arrays
MY_ARRAY=( one two three four five six )
MY_ARRAY2=( seven eight nine ten eleven twelve )
MY_ARRAY3=( thirteen fourteen fifteen )
# Merge the previous three arrays into one
MERGED=("${MY_ARRAY[@]}" "${MY_ARRAY2[@]}" "${MY_ARRAY3[@]}")
# Print the content of the new array
echo "MERGED: ${MERGED[@]}"

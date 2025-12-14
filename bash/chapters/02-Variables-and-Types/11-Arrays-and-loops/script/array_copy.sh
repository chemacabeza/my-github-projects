#!/usr/bin/env bash
#Script: array_copy.sh
MY_ARRAY=( one two three four five six )
declare -p MY_ARRAY
echo -e "\nCopying MY_ARRAY to MY_ARRAY_COPY\n"
MY_ARRAY_COPY=(${MY_ARRAY[@]})
MY_ARRAY_COPY+=("seven")
echo "Original array: "
declare -p MY_ARRAY
echo "Copy array:"
declare -p MY_ARRAY_COPY

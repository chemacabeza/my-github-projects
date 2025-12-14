#!/usr/bin/env bash
#Script: index_array_replace_pattern_first.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Replace first occurrence
echo -e "\nReplace first occurrence"
echo "\${MY_ARRAY[@]/e/X}: ${MY_ARRAY[@]/e/X}"
echo "\${MY_ARRAY[@]/e*/X}: ${MY_ARRAY[@]/e*/X}"

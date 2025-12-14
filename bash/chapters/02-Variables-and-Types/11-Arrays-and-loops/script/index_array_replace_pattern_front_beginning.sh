#!/usr/bin/env bash
#Script: index_array_replace_pattern.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Replace first occurrence
echo -e "\nReplace first occurrence"
echo "\${MY_ARRAY[@]/e/X}: ${MY_ARRAY[@]/e/X}"
echo "\${MY_ARRAY[@]/e*/X}: ${MY_ARRAY[@]/e*/X}"
# Replace all occurrences
echo -e "\nReplace all occurrences"
echo "\${MY_ARRAY[@]//e/X}: ${MY_ARRAY[@]//e/X}"
echo "\${MY_ARRAY[@]//e*/X}: ${MY_ARRAY[@]//e*/X}"
# Removal of elements 
echo -e "\nRemoval of elements"
echo "\${MY_ARRAY[@]//e/}: ${MY_ARRAY[@]//e/}"
echo "\${MY_ARRAY[@]//f*/}: ${MY_ARRAY[@]//f*/}"
# Replace front-end occurrences of string
echo -e "\nReplace front-end occurrences of string"
echo "\${MY_ARRAY[@]/#e/XY}: ${MY_ARRAY[@]/#e/XY}"
echo "\${MY_ARRAY[@]/#f/XY}: ${MY_ARRAY[@]/#f/XY}"

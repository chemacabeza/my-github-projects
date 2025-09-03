#!/usr/bin/env bash
#Script: array_slice.sh
MY_ARRAY=( one two three four five six )
# Original content
echo "Content: ${MY_ARRAY[@]}"
# Slice of three elements
echo "\${MY_ARRAY[@]:2:3} : ${MY_ARRAY[@]:2:3}"
echo "\${MY_ARRAY[@]:2:30} : ${MY_ARRAY[@]:2:30}"

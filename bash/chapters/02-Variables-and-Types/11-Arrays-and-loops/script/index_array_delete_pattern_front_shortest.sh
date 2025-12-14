#!/usr/bin/env bash
#Script: index_array_delete_pattern_front_shortest.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Shortest match from front of string
echo "\${MY_ARRAY[@]#t*}: ${MY_ARRAY[@]#t*}"
echo "\${MY_ARRAY[@]#t*ee}: ${MY_ARRAY[@]#t*ee}"

#!/usr/bin/env bash
#Script: index_array_delete_pattern_back_longest.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Shortest match from front of string
echo "\${MY_ARRAY[@]#t*}: ${MY_ARRAY[@]#t*}"
echo "\${MY_ARRAY[@]#t*ee}: ${MY_ARRAY[@]#t*ee}"
# Longest match from the front of string
echo -e "\n\${MY_ARRAY[@]##t*}: ${MY_ARRAY[@]##t*}"
echo "\${MY_ARRAY[@]##t*ee}: ${MY_ARRAY[@]##t*ee}"
# Shortest match from the back of string
echo -e "\n\${MY_ARRAY[@]%*ee}: ${MY_ARRAY[@]%*ee}"
echo "\${MY_ARRAY[@]%t*ee}: ${MY_ARRAY[@]%t*ee}"
# Longest match from the back of string
echo -e "\n\${MY_ARRAY[@]%%*e}: ${MY_ARRAY[@]%%*e}"
echo "\${MY_ARRAY[@]%%f*e}: ${MY_ARRAY[@]%%f*e}"

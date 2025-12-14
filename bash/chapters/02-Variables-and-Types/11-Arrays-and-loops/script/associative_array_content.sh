#!/usr/bin/env bash
#Script: associative_array_content.sh
declare -A MY_ARRAY=(
    [key1]="value1" 
    [key2]="value2" 
    [key3]="value3"
)
echo "Content-1: ${MY_ARRAY[*]}"
echo "Content-2: ${MY_ARRAY[@]}"

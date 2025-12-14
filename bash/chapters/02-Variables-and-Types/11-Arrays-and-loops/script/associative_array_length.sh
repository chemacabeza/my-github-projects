#!/usr/bin/env bash
#Script: associative_array_length.sh
declare -A MY_ARRAY=(
    [key1]="value1" 
    [key2]="value2" 
    [key3]="value3"
)
echo "Length-1: ${#MY_ARRAY[*]}"
echo "Length-2: ${#MY_ARRAY[@]}"

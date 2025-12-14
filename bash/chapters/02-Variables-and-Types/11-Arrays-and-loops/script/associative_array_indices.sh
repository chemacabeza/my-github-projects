#!/usr/bin/env bash
#Script: associative_array_indices.sh
declare -A MY_ARRAY=(
    [key1]="value1" 
    [key2]="value2" 
    [key3]="value3"
)
echo "Indices: ${!MY_ARRAY[@]}"

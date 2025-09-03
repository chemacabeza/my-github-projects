#!/usr/bin/env bash
#Script: associative_array_delete.sh
declare -A MY_ARRAY=(
    [key1]="value1" 
    [key2]="value2" 
    [key3]="value3"
)
unset MY_ARRAY[key2]
declare -p MY_ARRAY

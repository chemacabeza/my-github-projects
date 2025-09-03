#!/usr/bin/env bash
#Script: associative_array_add.sh
declare -A MY_ARRAY=(
    [key1]="value1" 
    [key2]="value2" 
    [key3]="value3"
)
MY_ARRAY+=([key4]="value4")
declare -p MY_ARRAY

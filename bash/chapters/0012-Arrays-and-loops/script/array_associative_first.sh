#!/usr/bin/env bash
#Script: array_associative_first.sh
declare -A MY_ARRAY=(
    [key1]="value1" 
    [key2]="value2" 
    [key3]="value3"
)
echo "First item: $MY_ARRAY"

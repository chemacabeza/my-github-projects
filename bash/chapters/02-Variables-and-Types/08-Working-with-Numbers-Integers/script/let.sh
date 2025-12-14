#!/usr/bin/env bash
#Script: let.sh
# Using the post-increment operator"
let "myVar = 32"
echo "Orignal value of myVar: $myVar"
echo "Using post-increment operator"
let "myVar++"
echo "New value of myVar: $myVar" # 33
# Using the shift left operator
let "myNumber = 16"
echo "Original value of myNumber: $myNumber"
let "myNumber <<= 1"
echo "New value of myNumber: $myNumber" # 32

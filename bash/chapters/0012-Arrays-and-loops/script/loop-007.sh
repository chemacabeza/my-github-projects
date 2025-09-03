#!/usr/bin/env bash
#Script: loop-007.sh
# Initialize counter
i=0
# Using the single bracket operator
until [ $i -gt 4 ]; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separator and re-initialize the counter
echo "----------"
i=0
# Using the test operator
until test $i -gt 5; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separator and re-initialize the counter
echo "----------"
i=0
# Using the double bracket operator
until [[ $i > 6 ]]; do
    echo "Line#$i"
    i=$(($i+1))
done


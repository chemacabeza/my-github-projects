#!/usr/bin/env bash
#Script: if_statement_with_square_bracket.sh
# Declaring some variables
FILE_PATH="/etc/profile"
NUMBER_1=3
NUMBER_2=4
EMPTY=
# Test if the file exists
if [ -e $FILE_PATH ]; then
    echo "'$FILE_PATH' does exist"
fi
# Test if the variable is empty
if [ -z $EMPTY ]; then
    echo "The variable EMPTY has nothing"
fi
# Test if the variables are different
if [ $FILE_PATH != "different" ]; then
    echo "The values of the strings are different"
fi
# Test to compare numbers
if [ 3 -lt 7 ]; then
    echo "3 is less than 7"
fi
# Combined test
if [ $NUMBER_1 -lt $NUMBER_2 -a $FILE_PATH != "boo" ]; then
    echo "Condition is true"
fi

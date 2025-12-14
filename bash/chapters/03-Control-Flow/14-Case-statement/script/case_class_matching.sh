#!/usr/bin/env bash
#Script: case_class_matching.sh
# Asking the user for input
echo -n "Enter a single character: "
read INPUT_CHAR
# Making sure than only one character is entered
if [[ ${#INPUT_CHAR} > 1 ]]; then
    echo "You entered more than 1 character";
    exit
fi
# Printing the result
echo -n "The character '$INPUT_CHAR' "
# Selecting the correct input
case $INPUT_CHAR in
    [[:lower:]])
	echo "is a lowercase letter"
	;;
    [[:upper:]])
	echo "is an uppercase letter"
	;;
    [[:digit:]])
	echo "is a digit"
	;;
    *)
	echo "is unknown"
	;;
esac


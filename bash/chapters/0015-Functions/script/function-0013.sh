#!/usr/bin/env bash
#Script: function-0013.sh
# Declaring a function
my_function() {
    echo "NON_INTEGER_VALUE"
}
# Calling the function and storing the returned value
RESULT=$(my_function)
# Printing the result of the function
echo "Result is '$RESULT'"

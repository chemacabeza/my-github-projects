#!/usr/bin/env bash
# Script: function-0008.sh
my_function_1() {
    echo "Inside my_function_1 - 1"
}
my_function_1() { # Will override the previous declaration
    echo "Inside the override of my_function_1"
}
my_function_1

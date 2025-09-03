#!/usr/bin/env bash
#Script: printf_v_option.sh

printf "Beginning of example\n"
printf -v MY_VAR "First line of the variable\nSecond line of the variable\nThird line"
printf "Content of the variable:\n###\n$MY_VAR\n###\n"
printf "End of example\n"


#!/usr/bin/env bash
#Script: indirect_variable.sh

VARIABLE_2="Content"
VARIABLE_1=VARIABLE_2

echo "Value: ${!VARIABLE_1}"


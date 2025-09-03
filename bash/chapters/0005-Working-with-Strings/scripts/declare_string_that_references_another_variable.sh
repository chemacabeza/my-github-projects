#!/usr/bin/env bash
#Script: declare_string_that_references_another_variable.sh
value="a string that contains"
myVariable="This is $value 8 space characters"
echo "Variable: '$myVariable'"

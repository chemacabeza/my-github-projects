#!/usr/bin/env bash
#Script: declare_integer_negated.sh
declare -i myIntVar=45
myIntVar=$myIntVar+1
echo $myIntVar # 46
declare +i myIntVar
myIntVar=$myIntVar+1
echo $myIntVar # 46+1

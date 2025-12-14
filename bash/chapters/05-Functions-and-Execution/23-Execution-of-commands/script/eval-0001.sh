#!/usr/bin/env bash
#Script: eval-0001.sh
VAR1='$VAR2'
VAR2='$VAR3'
VAR3='Some message'
# Using the echo command directly
echo $VAR1
# Using eval
eval echo $VAR1
# Using eval eval
eval eval echo $VAR1


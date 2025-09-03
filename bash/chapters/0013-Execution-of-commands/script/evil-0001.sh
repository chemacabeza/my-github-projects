#!/usr/bin/env bash
#Script: evil-0001.sh
VAR1='$VAR2; date'
VAR2='$VAR3'
VAR3='Some message'
# Using echo directly
echo $VAR1
# Using eval with echo
eval echo $VAR1
# Using double eval with echo
eval eval echo $VAR1

#!/usr/bin/env bash
#Script: prompt-0001.sh
PROMPT_COMMAND='
result=$?  
if [[ "$result" != "0" ]]; then 
echo -n "[Last command: KO] "
else
echo -n "[Last command: OK] "
fi'

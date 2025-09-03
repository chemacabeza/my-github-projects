#!/usr/bin/env bash
#Script: prompt-0002.sh
PROMPT_COMMAND=(
"echo -n \"[\$(date +%Y/%m/%d-%H:%M:%S)] \""
'result=$?
if [[ "$result" != "0" ]]; then
echo -n "[Last command: KO] "
else
echo -n "[Last command: OK] "
fi'
"echo \"\""
)

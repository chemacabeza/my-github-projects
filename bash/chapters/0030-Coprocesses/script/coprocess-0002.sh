#!/usr/bin/env bash
#Script: coprocess-0002.sh
# Creating the coprocess
coproc MY_PYTHON { python -i; } 2>/dev/null
# Priting the PID of the coprocess
echo "Coprocess PID: $MY_PYTHON_PID"
# Defining functions
echo $'def my_function():\n    print("Hello from a function")\n' >&"${MY_PYTHON[1]}"
# Calling the function defined
echo $'my_function()\n' >&"${MY_PYTHON[1]}"
echo $'my_function()\n' >&"${MY_PYTHON[1]}"
echo $'print("-END-")\n' >&"${MY_PYTHON[1]}"
# Loop that processes the output of the coprocess
is_done=false 
while [[ "$is_done" != "true" ]]; do
  read var <&"${MY_PYTHON[0]}"
  if [[ $var == "-END-" ]]; then
     is_done="true"
  else
     echo $var
  fi
done

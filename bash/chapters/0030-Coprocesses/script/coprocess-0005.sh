#!/usr/bin/env bash
#Script: coprocess-0005.sh
INPUT=inputFifo
OUTPUT=outputFifo
#Creating fifo files
mkfifo $INPUT
mkfifo $OUTPUT
# Creating subshell with python
( python -i ) <inputFifo >outputFifo 2>/dev/null &
#Saving the PID of the python subshell
PID_PYTHON_JOB=$!
# Print Process ID of python subshell
echo "PID Python Job: $PID_PYTHON_JOB"
# Define funxtion
echo $'def my_function():\n    print("Hello from a function")\n' >$INPUT
# Calling the function defined
echo $'my_function()\n' >$INPUT
echo $'my_function()\n' >$INPUT
echo $'print("EOD")\n' >$INPUT
# Lopp taking care of the output of the subshell
is_done=false 
while [[ "$is_done" != "true" ]]; do
  read var <$OUTPUT
  if [[ $var == "EOD" ]]; then
     is_done="true"
  else
     echo $var
  fi
done
# Cleaning
exec 2>/dev/null
kill -9 $PID_PYTHON_JOB
rm $INPUT
rm $OUTPUT

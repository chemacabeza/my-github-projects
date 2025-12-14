#!/usr/bin/env bash
#Script: processes-0002.sh
echo "Before exec"
exec ls -l
echo "After exec" # WILL NOT BE EXECUTED

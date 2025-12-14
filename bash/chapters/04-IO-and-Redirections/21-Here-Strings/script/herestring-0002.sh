#!/usr/bin/env bash
#Script: herestring-0002.sh
MY_VAR="Variable Value"
cat <<< "The content of \$MY_VAR is: ${MY_VAR}"

#!/usr/bin/env bash
#Script: io-redirections-0006.sh
# Define log file
COMBINED_FILE="/tmp/combined_log.txt"
echo "Printing the contents of the '$COMBINED_FILE' log"
cat < $COMBINED_FILE
echo ""
echo "End of script"

#!/usr/bin/env bash
#Script: regexp-0006.sh
echo "Printing the files in the current directory"
ls *
echo "Setting GLOBIGNORE to ignore '*.sh' files"
GLOBIGNORE="*.sh"
echo "Printing the files in the current directory"
ls *
echo "End of program"

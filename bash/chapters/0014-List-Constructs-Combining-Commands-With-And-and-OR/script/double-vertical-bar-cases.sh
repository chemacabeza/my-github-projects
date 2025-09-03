#!/usr/bin/env bash
#Script: double-vertical-bar-cases.sh
# Succeeds and Succeeds
echo -n "case 1" || echo " succeeds"
echo "Result case 1: $?"
# Succeeds and Fails
echo "case 2" || rm does_not_exist
echo "Result case 2: $?"
# Fails and Succeeds
rm does_not_exist || echo "case 3, not executed"
echo "Result case 3: $?"
# Fails and Fails
rm does_not_exist || rm another_file_that_does_not_exist
echo "Result case 4: $?"
# End
echo "End of program"

#!/usr/bin/env bash
#Script: null-0001.sh
rm file_that_does_not_exist
echo "Result: $?"
rm file_that_does_not_exist || :
echo "Result: $?"

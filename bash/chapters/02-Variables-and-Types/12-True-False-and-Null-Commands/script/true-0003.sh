#!/usr/bin/env bash
#Script: true-0003.sh
rm file_that_does_not_exist
echo "Result: $?"
rm file_that_does_not_exist || true
echo "Result: $?"

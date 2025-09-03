#!/usr/bin/env bash
#Script: compare.sh
# Approach with $(...)
echo $(echo $(echo $(echo $(uname))))
# Approach with backticks
echo `echo \`echo \\\`echo \\\\\\\`uname\\\\\\\`\\\`\``

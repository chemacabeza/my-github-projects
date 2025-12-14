#!/usr/bin/env bash
#Script: test-or-and.sh
#       EXECUTED                  NOT EXECUTED                  EXECUTED
# vvvvvvvvvvvvvvvvvvv      vvvvvvvvvvvvvvvvvvvvvvvv    vvvvvvvvvvvvvvvvvvvvvvvvv
echo -n "Is executed, " || echo "It's not executed" && echo "It's also executed"
echo "Result: $?"
echo "End of program"

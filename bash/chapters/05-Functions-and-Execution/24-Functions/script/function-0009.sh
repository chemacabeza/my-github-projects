#!/usr/bin/env bash
#Script: function-0009.sh
echo "Before overriding"
echo "##########"
ls  # standard command 'ls'. Will print directory content
echo ""
ls() { # Overriding command 'ls'
    echo "Nothing to see here"
}
echo "After overriding"
echo "##########"
ls   # Will print "Nothing to see here"
echo ""

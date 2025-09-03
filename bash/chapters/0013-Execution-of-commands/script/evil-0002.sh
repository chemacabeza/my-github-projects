#!/usr/bin/env bash
#Script: evil-0002.sh

# Code used with privileges
some_important_function() {
  _array=$1
  # DANGER!
  eval echo "\"The third element is \${$_array[2]}\""    
}
a=(zero one two three four five)
some_important_function a

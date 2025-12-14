#!/usr/bin/env bash
#Script: heredoc-0007.sh
{ 
  cat; 
  echo ---; 
  cat <&3 
} <<EOF 3<<EOF2
hi
EOF
there
EOF2

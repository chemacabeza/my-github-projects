#!/usr/bin/env bash
#Script: io-redirections-0024.sh
if true; then
    echo "LINE 1"
    echo "LINE 2"
fi | while read line; do
   echo "Line read is '$line'"
done
echo "HOLA" | if [[ "$(read line; echo $line)" == "HOLO" ]]; then
    echo "OK"
else 
    echo "KO"
fi

#!/usr/bin/env bash
#Script: false-0003.sh
until false; do
    echo "This loop will run forever until it's interrupted manually with Control+C"
done

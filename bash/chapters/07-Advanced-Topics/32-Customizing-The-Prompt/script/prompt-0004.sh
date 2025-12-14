#!/usr/bin/env bash
#Script: prompt-0004.sh
TIME="\e[0;47m\e[1;34m\t\e[0m"
USER="\e[1;31m\u\e[0m"
HOST="\e[0;44m\e[4;32m\H\e[0m"
CURRENT_DIR="\e[1;33m\e[1;40\w\e[0m"
PS1="\n${TIME} ${USER}@${HOST} ${CURRENT_DIR}\n$ "

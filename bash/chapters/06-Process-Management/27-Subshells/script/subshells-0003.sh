#!/usr/bin/env bash
#Script: subshells-0003.sh
print_variables() {
    echo ""
    echo "#########"
    echo "### $1"
    echo "#########"
    echo "BASHPID: $BASHPID"
    echo "BASH_SUBSHELL: $BASH_SUBSHELL"
    echo "SHLVL: $SHLVL"
    echo "#########"
    echo "### END - $1"
    echo "#########"
    echo ""
}
custom() {
    print_variables "Custom"
}
print_variables "Main program"
(
    print_variables "Subshell"
    ( 
       print_variables "Subshell - 2"
       custom
    )
)
# Sub Bash Process
bash -c 'echo -e "Bash - SHLVL: $SHLVL\nBash - Subshell: $BASH_SUBSHELL\nBash - BASHPID:$BASHPID\n"'

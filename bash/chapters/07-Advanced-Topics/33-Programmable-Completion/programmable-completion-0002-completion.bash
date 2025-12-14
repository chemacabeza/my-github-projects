#!/usr/bin/env bash
#Script: programmable-completion-0002-completion.bash
_mycommand_completions(){
    COMPREPLY=("opt1" "opt2" "opt3")
}
complete -F _mycommand_completions programmable-completion-0001

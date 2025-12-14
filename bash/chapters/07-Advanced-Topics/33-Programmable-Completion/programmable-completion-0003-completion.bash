#!/usr/bin/env bash
#Script: programmable-completion-0003-completion.bash
_mycommand_completions(){
		COMPREPLY=($(compgen -f -g -u))
}
complete -F _mycommand_completions programmable-completion-0001

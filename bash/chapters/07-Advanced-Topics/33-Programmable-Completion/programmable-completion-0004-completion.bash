#!/usr/bin/env bash
#Script: programmable-completion-0004-completion.bash
_mycommand_completions(){
		COMPREPLY=($(compgen -f -g -u ${COMP_WORDS[1]}))
}
complete -F _mycommand_completions programmable-completion-0001

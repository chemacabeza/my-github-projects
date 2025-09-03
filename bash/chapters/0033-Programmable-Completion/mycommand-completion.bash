#!/usr/bin/env bash
# Script: mycommand-completion.bash

_mycommand_completions() {
   if [[ "$COMP_CWORD" == 1 ]]; then
      COMPREPLY=($(compgen -W "user video image" ${COMP_WORDS[1]}))
      return
   fi
}

complete -F _mycommand_completions mycommand

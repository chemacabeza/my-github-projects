#!/usr/bin/env bash
# Script: mycommand-completion.bash

_mycommand_completions() {
   if [[ "$COMP_CWORD" == 1 ]]; then
      COMPREPLY=($(compgen -W "user video image" ${COMP_WORDS[1]}))
      return
   fi

   local argument=${COMP_WORDS[ (( COMP_CWORD - 1 )) ]}

   if [[ "$COMP_CWORD" == 2 ]]; then
      case "$argument" in
         image) COMPREPLY=($(compgen -W "resize rotate" ${COMP_WORDS[2]})) ;;
         user)  COMPREPLY=($(compgen -W "add remove" ${COMP_WORDS[2]})) ;;
         video) COMPREPLY=($(compgen -W "compress record" ${COMP_WORDS[2]})) ;;
      esac
      return
   fi
}

complete -F _mycommand_completions mycommand

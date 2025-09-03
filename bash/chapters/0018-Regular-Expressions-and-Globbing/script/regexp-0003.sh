#!/usr/bin/env bash
#Script: regexp-0003.sh
email="myuser@mydomain.com"
if [[ $email =~ ([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,}) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"  # Full email
    echo "Username: ${BASH_REMATCH[1]}"    # myuser
    echo "Domain: ${BASH_REMATCH[2]}"      # mydomain
    echo "TLD: ${BASH_REMATCH[3]}"         # com
fi

#!/usr/bin/env bash
#Script: substring_replacement.sh
myVariable=AbCdEfGhIjKlMnOpQrSKtUvWxYz
# Replace the first instance
echo "\${myVariable/A*K/XXXX}  => ${myVariable/A*K/XXXX}"
# Replace the first instance
echo "\${myVariable/K*z/XXXX}  => ${myVariable/K*z/XXXX}"
# Replace all instances
echo "\${myVariable//A*K/XXXX} => ${myVariable//A*K/XXXX}"
# Replace all instances
echo "\${myVariable//K/XXXX}   => ${myVariable//K/XXXX}"

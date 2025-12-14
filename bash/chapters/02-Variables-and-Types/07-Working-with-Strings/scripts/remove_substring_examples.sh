#!/usr/bin/env bash
#Script: remove_substring_examples.sh
myVariable=AbCdEfGhIjKlMnOpQrSKtUvWxYz
# Remove shortest substring starting from the front
echo "\${myVariable#A*K}  => ${myVariable#A*K}"
# Remove longest substring starting from the front
echo "\${myVariable##A*K} => ${myVariable##A*K}"
# Remove shortest substring starting from the back
echo "\${myVariable%K*z}  => ${myVariable%K*z}"
# Remove longest substring starting from the back
echo "\${myVariable%%K*z} => ${myVariable%%K*z}"


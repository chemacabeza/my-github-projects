#!/usr/bin/env bash
#Script: specifiers_3.sh
# Flags
printf "Examples with Flags\n"
printf "|%f|\n" 12.345
printf "|%-f|\n" 12.345
printf "|%+f|\n" 12.345
printf "|%0f|\n" 12.345
printf "|% f|\n" 12.345
printf "\n"

# Flags + width
printf "Examples with Flags & Width\n"
printf "|%20f|\n" 12.345
printf "|%-20f|\n" 12.345
printf "|%+20f|\n" 12.345
printf "|%020f|\n" 12.345
printf "|% 20f|\n" 12.345
printf "\n"

# Flags + width + precision
printf "Examples with Flags & Width & Precision\n"
printf "|%20.2f|\n" "12.345"
printf "|%-20.2f|\n" "12.345"
printf "|%+20.2f|\n" "12.345"
printf "|%020.2f|\n" "12.345"
printf "|% 20.2f|\n" "12.345"


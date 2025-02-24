#!/bin/bash

BRB="\e[1;31;40m"
BOB="\e[1;91;40m"
BPB="\e[1;95;40m"
BWB="\e[1;0;40m"
BR="\e[1;31m"
BP="\e[1;95m"
RESET="\e[0m"

if [ "$#" -ne 1 ]; then
    echo -e "\n${BRB}Syntax${BWB}: ${BPB}compCS${BOB} <${BPB}file_name${BOB}>${BWB}.${RESET}\n"
    echo -e "${BRB}After compiling${BWB}, ${BRB}use ${BPB}./${BOB}<${BPB}file_name${BOB}>${BWB}.${RESET}\n"
    exit 1
fi

arquivo="$1"
output="${arquivo%.c}"
line_number_norminette=1
line_number_output=1

echo -e "\n${BRB}Executing ${BPB}norminette ${BRB}to check for norm noncompliance...${RESET}\n\n"
echo -e "${BR}NORMINETTE DISPLAY:${RESET}\n"
echo -e "${BR}---|-------------------------------------------------------------------| NORMINETTE NORM CHECK |------------------------------------------------------------------|${RESET}"

norminette -R CheckForbiddenSourceHeader "$arquivo" | while read -r line; do
    echo -e " $line_number_norminette | $line"
    ((line_number_norminette++))
done

echo -e "${BR}---|-------------------------------------------------------------------| NORMINETTE NORM CHECK |------------------------------------------------------------------|${RESET}"

cc -Wall -Wextra -Werror "$arquivo" -o "$output"

if [ $? -eq 0 ]; then
    echo -e "\n${BWB}Compilation Successful! ${BRB}Executable file${BWB}: ${BPB}$output${RESET}\n"
    
    echo -e "${BRB}Applying ${BPB}chmod ${BRB}permissions...${RESET}\n\n"
    chmod 711 "$arquivo"
    chmod 711 "$output"
    echo -e "${BR}INFO TABLE:${RESET}"
    echo -e "\n${BR}---| PERMISSIONS -----| LINKS -----| USER -----| GROUP -----| SIZE -----| FULL TIMESTAMP -----------------------| FILE NAME --------------------------------------|${RESET}"
    
    ls --full-time -l "$output" | awk '{
        printf "   | %-16s | %-10s | %-9s | %-10s | %-9s | %-37s | %-47s", $1, $2, $3, $4, $5, $6" "$7" "$8, $9
    }'

    ls --full-time -l "$output" | awk '{
        printf "\n   | %-16s | %-10s | %-9s | %-10s | %-9s | %-37s | %-47s", $1, $2, $3, $4, $5, $6" "$7" "$8, $9
    }'

    echo -e "\n${BR}---|------------------|------------|-----------|------------|-----------|---------------------------------------|-------------------------------------------------|${RESET}"

    echo -e "\n${BRB}Executing ${BPB}$output ${BRB}for display...${RESET}"
    echo -e "\n\n${BR}OUTPUT DISPLAY:${RESET}"
    echo -e "\n${BR}---|----------------------------------------------------------| COMPILED FILE: ${BP}$output ${BR}|--------------------------------------------------------|${RESET}"

    ./"$output"
    echo -e "\n${BR}---|----------------------------------------------------------| COMPILED FILE: ${BP}$output ${BR}|--------------------------------------------------------|${RESET}"

else
    echo -e "\n${BRB}Compilation Error${BWB}: ${BRB}Please check the debug log${BWB}.${RESET}\n"
fi

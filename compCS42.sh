#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e "\n\e[1;31;40mSyntax\e[1;0;40m: \e[1;95;40mcompCS\e[1;91;40m <\e[1;95;40mfile_name\e[1;91;40m>\e[1;0;40m.\e[0m\n"
    echo -e "\e[1;31;40mAfter compiling\e[1;0;40m, \e[1;31;40muse \e[1;95;40m./\e[1;91;40m<\e[1;95;40mfile_name\e[1;91;40m>\e[1;0;40m.\e[0m\n"
    exit 1
fi

arquivo="$1"
output="${arquivo%.c}"
line_number_norminette=1
line_number_output=1

echo -e "\n\e[1;31;40mExecuting \e[1;95;40mnorminette \e[1;31;40mto check for norm noncompliance...\e[0m\n\n"
echo -e "\e[1;31mNORMINETTE DISPLAY:\e[0m\n"
echo -e "\e[1;31m---|-------------------------------------------------------------------| NORMINETTE NORM CHECK |------------------------------------------------------------------|\e[0m"

norminette -R CheckForbiddenSourceHeader "$arquivo" | while read -r line; do
    echo -e " $line_number_norminette | $line"
    ((line_number_norminette++))
done

echo -e "\e[1;31m---|-------------------------------------------------------------------| NORMINETTE NORM CHECK |------------------------------------------------------------------|\e[0m"

cc -Wall -Wextra -Werror "$arquivo" -o "$output"

if [ $? -eq 0 ]; then
    echo -e "\n\e[1;0;40mCompilation Successful! \e[1;31;40mExecutable file\e[1;0;40m: \e[1;95;40m$output\e[0m\n"
    
    echo -e "\e[1;31;40mApplying \e[1;95;40mchmod \e[1;31;40mpermissions...\e[0m\n\n"
    chmod 711 "$arquivo"
    chmod 711 "$output"
    echo -e "\e[1;31mINFO TABLE:\e[0m"
    echo -e "\n\e[1;31m---| PERMISSIONS -----| LINKS -----| USER -----| GROUP -----| SIZE -----| FULL TIMESTAMP -----------------------| FILE NAME --------------------------------------|\e[0m"

    ls --full-time -l "$output" && "$arquivo" | awk '{
        printf "   | %-16s | %-10s | %-9s | %-10s | %-9s | %-37s | %-47s", $1, $2, $3, $4, $5, $6" "$7" "$8, $9
    }'

    echo -e "\n\e[1;31m---|------------------|------------|-----------|------------|-----------|---------------------------------------|-------------------------------------------------|\e[0m"

    echo -e "\n\e[1;31;40mExecuting \e[1;95;40m$output \e[1;31;40mfor display...\e[0m"
    echo -e "\n\n\e[1;31mOUTPUT DISPLAY:\e[0m"
    echo -e "\n\e[1;31m---|----------------------------------------------------------| COMPILED FILE: \e[1;95m$output \e[1;31m|--------------------------------------------------------|\e[0m"

    ./"$output"
    echo -e "\n\e[1;31m---|----------------------------------------------------------| COMPILED FILE: \e[1;95m$output \e[1;31m|--------------------------------------------------------|\e[0m"

else
    echo -e "\n\e[1;31;40mCompilation Error\e[1;0;40m: \e[1;31;40mPlease check the debug log\e[1;0;40m.\e[0m\n"
fi

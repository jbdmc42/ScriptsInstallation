#!/bin/bash

# colors definition
BRB="\e[1;31;40m"
BOB="\e[1;91;40m"
BPB="\e[1;95;40m"
BWB="\e[1;0;40m"
BR="\e[1;31m"
BP="\e[1;95m"
RESET="\e[0m"

# main syntax 
if [[ "$#" -lt 1 ]]; then
    echo -e "\n${BRB}Syntax${BWB}: ${BPB}compCS${BOB} <${BPB}file_name${BOB}>${BWB}.${RESET}\n"
    echo -e "${BRB}After compiling${BWB}, ${BRB}use ${BPB}./${BOB}<${BPB}file_name${BOB}>${BWB}.${RESET}\n"
    echo -e "${BRB}Use ${BPB}--git-commit ${BRB}to commit the file automatically (only works on github repositories)${BWB}.${RESET}\n"
    echo -e "${BRB}Use ${BPB}--add-args ${BRB}and then add your arguments to execute the compiled file with them${BWB}.${RESET}\n"
    exit 1
fi

# variable declaration
arquivo="$1"
output="${arquivo%.c}"
line_number_norminette=1

# verification for --add-args
if [[ "$2" == "--add-args" ]]; then
    shift 2
    args=("$@")
fi

# norminette execution with: norminette -R CheckForbiddenSourceHeader
echo -e "\n${BRB}Executing ${BPB}norminette ${BRB}to check for norm noncompliance...${RESET}\n\n"

# norminette errors table display
echo -e "${BR}NORMINETTE DISPLAY:${RESET}\n"
echo -e "${BR}-----|-----------------------------------------------| NORMINETTE NORM CHECK |----------------------------------------------|${RESET}"

norminette -R CheckForbiddenSourceHeader "$arquivo" | while read -r line; do
    printf " %3d | %s\n" "$line_number_norminette" "$line"
    ((line_number_norminette++))
done

echo -e "${BR}-----|-----------------------------------------------| NORMINETTE NORM CHECK |----------------------------------------------|${RESET}\n"

# file compilation with: cc -Wall -Wextra -Werror
cc -Wall -Wextra -Werror "$arquivo" -o "$output"

if [ $? -eq 0 ]; then
    echo -e "\n${BWB}Compilation Successful! ${BRB}Executable file${BWB}: ${BPB}$output${RESET}\n"
    
    # execution permission given using: chmod 711 for rwx--x--x on both files
    echo -e "${BRB}Applying ${BPB}chmod ${BRB}permissions...${RESET}\n\n"
    chmod 711 "$arquivo"
    chmod 711 "$output"

    # full timestamp table display
    echo -e "${BR}INFO TABLE:${RESET}"
    echo -e "\n${BR}---| PERMISSIONS -----| LINKS -----| USER -----| GROUP -----| SIZE -----| FULL TIMESTAMP -----------------------| FILE NAME --------------------------------------|${RESET}"
    
    # file display
    ls --full-time -l "$arquivo" | awk '{
        printf "   | %-16s | %-10s | %-9s | %-10s | %-9s | %-37s | %-47s", $1, $2, $3, $4, $5, $6" "$7" "$8, $9
    }'

    # compiled file display
    ls --full-time -l "$output" | awk ' {
        printf "\n   | %-16s | %-10s | %-9s | %-10s | %-9s | %-37s | %-47s", $1, $2, $3, $4, $5, $6" "$7" "$8, $9
    }'

    echo -e "\n${BR}---|------------------|------------|-----------|------------|-----------|---------------------------------------|-------------------------------------------------|${RESET}"

    # compiled file execution
    echo -e "\n${BRB}Executing ${BPB}$output ${BRB}for display...${RESET}"

    # compilation output table display
    echo -e "\n\n${BR}OUTPUT DISPLAY:${RESET}"
    echo -e "\n${BR}-----|-------------------------------------------| COMPILED FILE: ${BP}$output ${BR}|-----------------------------------------|${RESET}"
    ./"$output" "${args[@]}"| awk '{lines[NR]=$0} END {for (i=1; i<=NR-1; i++) printf " %3d | %s\n", i, lines[i]; printf " %3d | %s", NR, lines[NR]}'

    echo -e "\n${BR}-----|-------------------------------------------| COMPILED FILE: ${BP}$output ${BR}|-----------------------------------------|${RESET}\n"
    
    # compiled file deletion
    echo -e "${BRB}Removing ${BPB}$output${BRB} ...${RESET}\n"
    rm "$output"

    # compiled file deletion confirmation
    echo -e "${BRB}Trash files removed${BWB}.${RESET}\n"

    # github add/commit/push if flag --git-commit is found
    if [ "$2" == "--git-commit" ]; then
        echo -e "\n${BR}GITHUB:${RESET}\n"

        # github info display
        echo -e "${BR}-----|-------------------------------------------| GITHUB COMMIT |-----------------------------------------|${RESET}\n"
       	git rev-parse --is-inside-work-tree > /dev/null 2>&1

    # github add/commit
	if [ $? -eq 0 ]; then
    		file_path="$(pwd)/$arquivo"

            # github adding confirmation
    		echo -e "\n${BRB}Adding ${BPB}$file_path${BRB} ...${RESET}"
       		git add .

            # github added successfully confirmation
       		echo -e "\n${BRB}Added ${BPB}$file_path${BWB}.${RESET}"

            # github committing confirmation
       		echo -e "\n${BRB}Committing ${BPB}$file_path${BRB} ...${RESET}"
       		git commit -m "Added $file_path"

            # github committed successfully confirmation
       		echo -e "\n${BRB}Committed ${BPB}$file_path${BWB}.${RESET}"

            # github push wait for user confirmation
       		echo -e "\n${BRB}Do you want to ${BPB}push${BWB}?${RESET}"
       		while true; do

                    # github user choice input
            		read -p "Enter your choice (y/n): " choice
            		if [ "$choice" == "y" ]; then

                        # github pushing confirmation by user input
            			echo -e "\n${BRB}Pushing${BPB}$file_path${BRB} ...${RESET}"
                		git push
                		if [ $? -eq 0 ]; then

                            # github push successful confirmation
                			echo -e "\n${BRB}Pushed ${BPB}$file_path ${BRB}to ${BPB}github repository${BWB}.${RESET}"
                			break
                		else
                            # github couldnt-push error
                			echo -e "\n${BRB}Couldn't push ${BPB}$file_path ${BRB}to ${BPB}github repository${BWB}.${RESET}"
                			echo -e "\n${BRB}Please retry${BWB}.${RESET}"
                			break
                		fi
            		elif [ "$choice" == "n" ]; then
                        # github push stopped by user input
                		echo -e "\n${BRB}No changes pushed.${RESET}"
                		break
            		else
                        # github invalid-option error
                		echo -e "\n${BRB}Not a valid option.${BWB} Please try again (y/n)${BWB}.${RESET}"
            		fi
            	done
	else
            # github not-a-repository error
    		echo -e "${BRB}You are not on a ${BPB}github repository${BWB}.${RESET}"
        fi
    fi
else
    # compilation error message
    echo -e "\n${BRB}Compilation Error${BWB}: ${BRB}Please check the debug log${BWB}.${RESET}\n"
fi  


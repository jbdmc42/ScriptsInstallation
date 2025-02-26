#!/bin/bash

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo -e "\n\e[1;31;40mSyntax\e[1;0;40m: \e[1;95;40mopenVSC \e[1;91;40m<\e[1;95;40mfile_name.\e[1;95;40mc\e[1;91;40m>\e[0m\n"
    echo -e "\e[1;31;40mUse \e[1;95;40m--with-header \e[1;31;40mto open the file and automatically generate the header\e[1;0;40m.\e[0m\n"
    echo -e "\e[1;31;40mInstall \e[1;95;40mxdotool \e[1;31;40mwith\e[1;0;40m: \e[1;95;40msudo apt install xdotool\e[1;0;40m.\e[0m\n"
    echo -e "\e[1;31;40mInstall \e[1;95;40mnorminette header plugin \e[1;31;40min Visual Studio Code to generate automatic headers\e[1;0;40m.\e[0m\n"
    exit 1
fi

arquivo="$1"

if [ ! -f "$arquivo" ]; then
    echo -e "\n\e[1;31;40mError\e[1;0;40m: \e[1;95;40m$arquivo\e[1;31;40m doesn't exist in the current context\e[1;0;40m.\e[0m\n"
    exit 1
fi

echo -e "\n\e[1;31;40mOpening \e[1;95;40m$arquivo \e[1;31;40m...\e[0m\n"
code "$arquivo"

if [ "$2" == "--with-header" ]; then
    echo -e "\e[1;31;40mWaiting for \e[1;95;40mVSCode \e[1;31;40mto open before generating \e[1;95;40mheader \e[1;31;40m...\e[0m\n"
    sleep 2

    if command -v xdotool &> /dev/null; then
        xdotool search --onlyvisible --class code windowactivate --sync key ctrl+alt+h
    else
        echo -e "\n\e[1;95;40mxdotool \e[1;31;40mnot found\e[1;0;40m. \e[1;31;40mInstall it using\e[1;0;40m: \e[1;95;40msudo apt install xdotool\e[0m"
        exit 1
    fi
fi

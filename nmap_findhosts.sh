#!/bin/bash

if [ $# -lt 1 ]; then
	echo "[+] This script will run a nmap ping scan, made by Rien Strootman"
	echo "[+] Usage: findhosts.sh <iprange: xxx.xxx.xxx> <file to save to>"
	exit 1
elif [ $# -gt 2 ]; then
	echo "[-] You gave more than 2 arguments, exiting prematurly"
	echo "[-] Usage: findhosts.sh <iprange: xxx.xxx.xxx> <file to save to>"
	exit 1

else
	if [[ ! $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}.$ ]]; then
			iprange=$( echo "$10/24" )
		else
			iprange=$1
		fi
	else
		iprange=$(echo "$1.0/24")
	fi

	if [ -z $2 ]; then
		if [[ $iprange == *"/"* ]]; then
			savefile=$( echo ${iprange/"0/24"/"0-256"} )
		else
			savefile=$1
		fi
	else
		savefile=$2
	fi
	savefile=$( echo "ips.$savefile" )
	echo "[+] Started scanning IP(range)" $iprange
	nmap -sn $iprange -oG $savefile
	echo "[+] Scan completed. Started to grep IP's from result at" $savefile
	cat $savefile | awk '/Status: Up/ {print$2}' > ips.$savefile
	echo "[+] Results can be found at "$savefile
	echo "[+] You can run findports.sh "$savefile "to find ports on all found hosts"
	echo "[+] Exiting program"
fi

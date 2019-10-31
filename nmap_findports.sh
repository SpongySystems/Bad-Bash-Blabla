#!/usr/bin/env bash

scan() {
        echo "[+] Start a TCP(all ports) and UDP(top 1000 ports) scan on $1"
        nmap -sU -T4 $1 -oG ports.udp.$name$addname &
	nmap -T4 -p- $1 -oG ports.tcp.$name$addname &
	wait
	echo "[+] Results saved in ports.tcp/udp.$name$addname"
}

if [ $# -lt 1 ]; then
        echo "[+] This script will run a nmap port scan, made by Rien Strootman"
        echo "[+] Usage: findports.sh <ip or file with ips> <file to save to (optional)>"
        exit 1
elif [ $# -gt 2 ]; then
    	echo "[-] You gave more than 2 arguments, exiting prematurly"
       	echo "[-] Usage: ./findports.sh <ip or file with ips> <file to save to (optional)>"
	exit 1
else
	if [[ $1 == ips.* ]]; then
		ips=$( cat $1 | awk '/Status: Up/ {print$2}')
		if [ -z $2 ]; then
			name="${1:4}"
		else
			name=$2
		fi
		for ip in $ips
		do
			addname=$( echo $ip | cut -d . -f 4 )
			addname=$( echo ".$addname" )
			scan $ip
		done
	else
		if [ -z $2 ]; then
			name=$1
		else
			name=$2
		fi
		addname=""
		scan $1
	fi
fi

echo "[+] All scans completed"
echo "[+] Exiting program"

#!/bin/bash
if [[ ! $1 == "ports."* ]]; then
	echo "[-] No grepable file from ./nmap.findports.sh was given"
	echo "[-] Exiting program"
	exit 1
elif [ $# -lt 1 ]; then
	echo "[+] This program will take a grepable file from nmap.findports.sh and run a detailed nmap scan"
	echo "[+] Nmap will only scan on ports that are open and only on hosts that are known to be up"
	echo "[+] Program was made by Rien Strootman"
	exit 1
elif [ $# -gt 2 ]; then
	echo "[-] You gave more than 2 arguments, exiting prematurly"
        echo "[-] Usage: ./nmap.detailedscan.sh <file from nmap.findports.sh> <file to save to (optional)>"
fi

#determains if a TCP or UDP scan has to be perfomed
if [[ $1 == "ports.udp"* ]]; then
	porttype="-sU "
else
	porttype=""
fi

raw=$(cat $1 | grep Ports)
for element in $raw; do
        if [[ $element =~ ^[0-9] ]]; then
                if [[ $element == *"."* ]]; then
                        ip=$element
                elif [[ $element == *"/"* ]]; then
                        if [[ $element == *","* ]]; then
                                port=$( echo $element | cut -d / -f 1 )
                                ports="$ports,$port"
                        else
                                port=$( echo $element | cut -d / -f 1 )
                                ports="$ports,$port"
				ports=${ports:1}
				if [ -z $2 ]; then
					if [[ $1 == *"ports."* ]]; then
						cutter="${1:6}"
						savefile=$( echo "osresults.$cutter" )
					else
						savefile=$( echo "osresults.$ip" )
					fi
				else
					i=$((i+1))
					savefile=$( echo "osresult.$2.$ip" )
				fi
				echo "[+] Start scanning $ip on ports $ports"
				nmap $porttype-T4 -A -p$ports $ip -oN $savefile
				echo "[+] Scanning of $ip finished and saved as $savefile"
				ports=""
                        fi
                fi
        fi
done
echo "[+] All scans completed"

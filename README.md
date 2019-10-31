# Here you find my Bash scripts.

The power from these scripts are from running them after each other. This limits scantime, because hosts and ports that are not up, will be skipped. This will result in a faster scan in general.

nmap_findhosts.sh
Find all hosts that are up on an internal network and save it to a file that can be used in nmap_findports

nmap_findports.sh
Find open ports on a host or multiple hosts (pingscan on all tcp and top 1000 udp) and save it into two files (tcp and udp) that can be used by nmap_detailedscan as an input

nmap_detailedscan.sh
Scan on only known open ports (if any) with detailes about the services version and OS.

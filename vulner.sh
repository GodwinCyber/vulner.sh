#!/bin/bash


automate () {
	figlet -m 60 "VULNER [//^^_^^\\]"
	echo "[*] All files will be saved in a file on your current directory."
	echo "[*] Choose the action will like to perfom."
	echo -e "\n1. [*] Network Devices Detection!. \n2. [*] Enumeration of the Network Devices Selected!. \n3. [*] Vulnerability scanning of the Network Devices Found!. \n4. [*] Brute Forcing for Weak Password!."
	echo " "
	read -p "[!!] Please Choose a Number: " OPTION
	clear
	
	case $OPTION in
	1)
		figlet -m 10 "Network Devices Detection!!!"
		#1. Map Network Devices and Open Ports (40 Points) 
		#1.1 Automatically identify the LAN network range – (10 Points)
		#1.2 Automatically scan the current LAN – (10 Points)
		
		Devices_Scan () {
			read -p "[!!] Enter the Network Address Range to scan: " NET_RANGE
		
		
			Nmap_ScanType () {
				echo "[**] Thses are the available nmap scans!!!"
				echo -e "\n1. [*] Fast Scan!!. \n2. [*] Version Detection!!. \n3. [*] Scan for all port and Purposes!!. \n4. [*] Scan Specific Port!!. \n5. [*] Back to Main Menu!!."
			}
			Nmap_ScanType
		
		read -p "[!!] Please select a number to perform a scan: " NUM_SCAN
		case $NUM_SCAN in
		1)
			nmap -F $NET_RANGE -oA NmapFastScan
			;;
		2) 
			nmap -sV $NET_RANGE -F -Pn -oA NmapVersion
			;;
		3)
			nmap -A $NET_RANGE -p- -sV -sC -oA NmapAllPort
			;;
		4)
			read -p "[!!] Enter Port/Ports to scan, sperate Ports by comma: " PORT
			nmap -sV $NET_RANGE -p $PORT -oA NmapPort
			;;
		5)
			automate
			;;
		*)
			echo "[*] Network address entered!!!"
			;;
		esac
		}
		Devices_Scan
		;;
		
#*******************************************************************************************************************************
	
	2)
		figlet -m 10 "Enumerate on the Network Devices Selected!!"
		#1.3 Enumerate each live host – (10 Points)
		Enumerate () {
			read -p "[!!] Enter the Network Address Range to Scan: " NET_RANGE
			
			Nmap_ScanType () {
				echo "[*] These are the avilabel nmap scan for enumeration!!"
				echo -e "\n1. [*] Default Script Scan!!. \n2. [*] Vulnerability Scan!!. \n3. [*] Specific Ports Enumeration Using NSE Script!!. \n4. [*] Back to the Main Menu!!."
			}
			Nmap_ScanType
			
		read -p "[!!] Enter a number to perform a scan: " NUM_SCAN
		case $NUM_SCAN in
		1)
			nmap -sV $NET_RANGE -p- --script=default -oA NmapScriptDefault
			;;
		2)
			nmap -sV $NET_RANGE -p- --script=vuln -oA NmapSciptVuln
			;;
		3)
			read -p "[!!] Enter Desired port to Scan: " PORT
			read -p "[!!] Enter the Corresponding Service Name: " SERVICE
			echo " "
			echo "[*] Choose a service from NSE enum Script: \n$(locate *.nse | grep -i $SERVICE)"
			read CHOICE
			nmap -sV $NET_RANGE -p $PORT --script=$CHOICE -oA NmapEnumPort
			;;
		4)
			automate
			;;
		*)
			echo "[*] No Number Entered. Exit"
			;;
		esac	
		}
		Enumerate
		;;
		
#*******************************************************************************************************************************
		#1.4 Find potential vulnerabilities for each device – (10 Points)
	3)
		figlet -m 5 "Vulnerability scanning of the Network Devices Found!!"
			
			vuln_finder () {
				read -p "[!!] Enter Network Address Range to Scan: " NET_RANGE
				echo "[*] Scanning for Vulnerabilities on each Live Host!!"
				nmap -sV $NET_RANGE -oA NmapVulnFinder 2>/dev/null
				seachsploit --nmap NmapVulnFinder 2>/dev/null vuln.txt
				echo " "
				clear
				echo "[!!] Scan Completed, the vuln.txt contains the vulnerability of the scan"
				echo "Thank You!!!"
				sleep 2
				exit
			}
			vuln_finder
			;;

#*******************************************************************************************************************************
			#2. Check for Weak Passwords Usage (40 Points)
			#2.1 Allow the user to specify a user list – (5 Points)
			#2.2 Allow the user to specify a password list – (5 Points)
			#2.3 Allow the user to create a password list – (5 Points)
			#2.4 If a login service is available, Brute Force with the password list – (15 Points)
			#2.5 If more than one login service is available, choose the first service – (10 Points)
					
	4)
		figlet -m 4 "Brute Forcing for Weak Password!!!"
			
			password_checker () {
				read -p "[*] Enter the first three octet to scan: " NETWORK_ADD
				echo "[!!] Finding the Live IP address on the Network!!"
				for i in `seq 1 255`
				do 
					ping -c 1 $NETWORK_ADD.$i | grep ttl | awk '{print $4}' | cut -d: -f1 &
				done > liveIP.txt
				sleep 2
				clear
				echo -e "[!!] Found Devices $(date) \n$(cat liveIp.txt)!!"
				sleep 2
				echo "[!!] Nmap scanning ongiong, kindly waite!!"
				for i in $(cat liveIP.txt)
				do 
					nmap -F $i -Pn
				done
				sleep 2
				figlet -m 4 "Create a Password List from Your Dictory"
				read -p "[*] Choose user list from the directory for brute forcing: " USER_LST
				read -p "[*] Choose a Password List from current directory for brute forcing: " PASS_LST
				read -p "[*] Enter IP address from nmap scan for brute forcing: " IP
				read -p "[*] Enter service (e.g ssh, ftp) to scan for brute forcing: " SERVICE
				echo " "
				clear
				echo "[!!] Brute Force starting!!!"
				hydra -L $USER_LST -P $PASS_LST $IP $SERVICE -vV
				echo "Thank You, Exit!!"
				sleep 2
				exit
			}
			password_checker
			;;
		
		*)
			echo "No Option Selected"
			exit
			;;
		esac
		
}
automate

#!/Bin/bash
# TAGS: ctf box
# INFO: This scantype is for first recon a CTF-Box

source $WDIR/lib.sh

## Dependencies
VARSET=("IP")
TOOLSET=("nmap")

## Functions
info()
{
    echo "[I] The following checks will be performed:"
    echo " |  [C] Quick TCP Scan"
    echo " |  [C] Full TCP Scan - Full & Aggressive"
    echo " |  [C] Quick UDP"
    echo "[I] Scantype: $0 "
    echo -e "\n"
}

## Check requirements
check_root
check_varset ${VARSET[@]}
check_toolset ${TOOLSET[@]}

## Main
### info
info

### Perform
info_msg "Quick TCP Scan"
check_msg "nmap -vv -T4 -sS -F $IP"
nmap -vv -T4 -sS -F $IP

info_msg "Full TCP Scan - Full & Aggressive"
check_msg "nmap -vv -T4 -sS -F -sV -sC -A --version-all $IP"
nmap -vv -T4 -sS -F -sV -sC -A --version-all $IP

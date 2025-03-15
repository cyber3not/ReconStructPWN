#!/bin/bash

# Colors
## Define Colors
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
RESET="\e[0m"

## Color Print Functions
error_msg() { echo -e "${RED}[ERROR]${RESET} $1"; }
info_msg() { echo -e "${BLUE}[INFO]${RESET} $1"; }
warn_msg() { echo -e "${YELLOW}[WARNING]${RESET} $1"; }
check_msg() { echo -e "${GREEN}[CHECK]${RESET} $1";}
menu_msg() { echo -e "${CYAN}[MENU]${RESET} $1" ;}

# Checker
check_toolset()
{
local tools=("$@")

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        warn_msg "$tool is not installed or not found!"
    else
        info_msg "$tool installed."
    fi
done
}


check_varset()
{
local vars=("$@")

for var in "${vars[@]}"; do
    if [[ -z "${!var}" ]];then
        error_msg "Variable: $var missing!"
        exit 1
    fi
done


}


check_root(){
if [[ $EUID -ne 0 ]]; then
    error_msg "This script must be run as root!"
    exit 1
fi
}

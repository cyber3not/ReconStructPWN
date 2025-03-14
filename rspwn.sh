#!/bin/bash
source ./lib.sh

## Functions
help(){
    echo "Usage: $0 <TARGET> [Options]"
    echo "Input Options:"
    echo "-u <URL>"
    echo "-d <DOMAIN>"
    echo "-i <IP>"
    exit 1
}



## Pre run Checks
### If no Argument
if [[ $# -lt 1 ]];then
    help
fi

### Check Skeleton
if [[ ! -d ./scans || ! -d ./scantypes ]];then
    error_msg "Skeleton is broken - check folder structure."
    exit 1
fi



## Arguments
### Positional
t=$1
shift

### Short Flag Options
OPTSTRING=":u:i:d:"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    u) u=${OPTARG} ;;
    d) d=${OPTARG} ;;
    i) i=${OPTARG} ;;
    :) exit 1 ;;
    ?) error_msg "Invalid option: -${OPTARG}."
      exit 1 ;;
  esac
done


## RuntimeVars
### From Input
TARGET=$t
URL=$u
DOMAIN=$d
IP=$i
echo "$0" $IP

### Script
WDIR="$(pwd)"
start="$(date +%s)"
SCAN_PATH="$WDIR/scans/$TARGET"
SCRIPT_PATH="$WDIR/scantypes/"
LOGDATE="$(date +%Y-%m-%d_%H-%M-%S)"
LOGFILE="$LOGDATE".txt

### Export Vars for Subscripts
export URL DOMAIN IP WDIR



## Main
### Create Unique Scan path
mkdir -p "$SCAN_PATH"
cd "$SCAN_PATH"

info_msg "Starting scan against $TARGET:"
sleep 1

### Go
scripts=("$SCRIPT_PATH"/*.sh)

# Entferne den absoluten Pfad aus den Dateinamen
script_names=()
for script in "${scripts[@]}"; do
    script_names+=("$(basename "$script")")
done

options=("${script_names[@]}" "Abort")

menu_msg "Choose a scan type that you want to execute on $TARGET:"
select opt in "${options[@]}"; do
    if [[ "$opt" == "Abort" ]]; then
        echo "Abort"
        exit 0
    elif [[ -n "$opt" ]]; then
        echo "Start $opt ..."

        SCANTYPE_FOLDER=$(echo $opt | cut -d '.' -f 1)
        mkdir $SCANTYPE_FOLDER

        bash "$SCRIPT_PATH/$opt" | tee -a ./$SCANTYPE_FOLDER/$LOGFILE
        break
    else
        echo "Invalid input, please select a number from the list."
    fi
done


## End
### Calculate Time
end=$(date +%s)
seconds=$[$end - $start]

if [[ "$seconds" -gt 59 ]];then
    minutes=$[$seconds / 60 ]
    TIME="$minutes minutes"
else
    TIME="$seconds seconds"
fi

info_msg "Scan $TARGET took $TIME"
exit 0

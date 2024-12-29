#!/bin/bash
#
# Author:       Simon N. Thornton
# Created:      2024/01/23
# Modified:     2024/12/24 $Id$
# Function:     Read/Write Roth thermostat
#
# --- SOH ---
# 
# Function:  Read/Write Roth thermostats
#
# Syntax:    rothread.sh [-d] [-i host] [-s] [-h] [-r variable] [-w variable=value]
#            rothread.sh -s                           # Show current status of controller and thermostats
#            rothread.sh -r G0.SollTempMinVal
#            rothread.sh -w G0.SollTempMinVal=18      # Set minimum allowed value on  Thermostat 0 to 18 C
#            rothread.sh -w G0.Name="Kitchen"         # Set Thermostat name to "Kitchen"
#            rothread.sh -w G0.OPMode=1               # Set Thermostat to Night mode (0=Normal, 1=Night, 2=Holiday)
#            rothread.sh -r R0.numberOfPairedDevices  # Number of connected thermostats
#
# Note:      values on write are in the format XX.xx or XXXX e.g. 18C can be entered as 18 or 1800
#
# Params:
#           -i xxx                         IP Address/name of Roth controller
#           -r G[0-max]Variable            Read variable (each thermostat has an instance from 0 to R0.numberOfPairedDevices-1)
#           -w G[0-max]Variable=value      Write value to variable
#
#           -s                             Show status of controller and thermostats (-s is optional, no params is same)
#           -d                             Debug mode
#           -h                             Show this help
#
# Gx.OPMode
#       0 = Normal
#       1 = Night
#       2 = Holiday
#
# (c) Simon N. Thornton 2024,  email programmer[at]eazimail.com with comments or otherwise.
#
# --- EOH ---
#
# History
# 2024/12/24    SNT Tweaked status item to replace CR & LF with pipe (|)
#

# In debug mode it does not write to either log
#DEBUG=1

# Set this to the IP of your controller
sIP=${sIP:-x.x.x.x}

# You can delete this once you set sIP
if [[ "${sIP}" == "x.x.x.x" ]]; then printf "Error: change x.x.x.x to your controller IP address!\n\n"; exit 1; fi


sURLPFX=http://${sIP}/cgi-bin
sLOG=/var/tmp/roth-stats.csv
sLOG1=/var/tmp/roth-stats1.csv
sLOG2=/var/tmp/roth-stats2.csv
sDATE=$(date +"%Y/%m/%d,%H:%M:%S")


printf "\nRoth Thermostat interface\n=========================\n\n%-25s:\t%s\n" "IP" ${sIP} 1>&2

# How many thermostats are connected?
if [[ -z "${iDEVS}" ]]; then
        iDEVS=$(curl ${sURLPFX}/readVal.cgi?totalNumberOfDevices 2>/dev/null)
        if [[ -z "$iDEVS" ]]; then iDEVS=10; fi
fi
printf "%-25s:\t%s" "Thermostats" ${iDEVS} 1>&2
iDEVS=$((iDEVS-1))
printf " (0-${iDEVS})\n\n" 1>&2




# -------------------------------------------------
# ---------- Functions -----------

# ------------------
# print help page
# ------------------
show_help () {
        cat $0 | awk '
                BEGIN {nPrn=0}
                /^# --- SOH ---/{nPrn=1}
                /^# --- EOH ---/{nPrn=0}
                {       if (nPrn>1) {
                                printf "%s\n",substr($0,2)
                                nPrn++;
                        } else
                                if (nPrn==1) nPrn++;

                 }
        '
        printf "\n"
}
#
# Function:     read status of all connected thermostats
#
GetStatus () {
        local sCMD sQUERY a sHDR sLIN iCNT aFIELDNAM aFIELDVAL

        iCNT=0
        # Device ssettings
        for a in CD.uname CD.upass STELL-APP STELL-BL ST-APP STM-BL hw.IP hw.Addr hw.DNS1 hw.DNS2 hw.GW hw.NM hw.HostName totalNumberOfDevices numberOfSlaveControllers VPI.href VPI.state isMaster ; do
                sRES=$(curl ${sURLPFX}/readVal.cgi?${a} 2>/dev/null)
                if [[ -n "$sRES" ]]; then
                        printf "%-25s:\t${sRES}\n" $a
                        aFIELDNAM[${iCNT}]=$a
                        aFIELDVAL[${iCNT}]="${sRES}"
                        iCNT=$((iCNT+1))
                fi
        done

        # Status
#       sRES=$(curl ${sURLPFX}/GetSrvInfo.exe 2>/dev/null | awk '{printf "\n\t\t\t\t%s",$0}' | tr -d '\015' | tr '\012' '|')
        sRES=$(curl ${sURLPFX}/GetSrvInfo.exe 2>/dev/null | tr -d '\015' | tr '\012' '|' | sed 's/|$//g')
        if [[ -n "$sRES" ]]; then
                printf "%-25s:\t${sRES}\n" "Status"
                aFIELDNAM[${iCNT}]=Status
                aFIELDVAL[${iCNT}]="${sRES}"
                iCNT=$((iCNT+1))
        fi


        # Room temp/set temp
        sQUERY="name RaumTemp SollTemp SollTempMaxVal SollTempMinVal SollTempStepal TempSIUnit Weekprog WeekProgEna OPMode OPModeEna kurzID ownerKurzID"
        sHDR=$(echo -n ${sQUERY} | tr ' ' ',')

        for a in $(seq 0 $iDEVS); do
                sLIN=""
                sHDR=""
                for sCMD in ${sQUERY}; do
                        sRES=$(curl ${sURLPFX}/readVal.cgi?G${a}.${sCMD} 2>/dev/null)
                        if [[ -n "$sRES" ]]; then
                                case "${sCMD}" in
                                                RaumTemp|SollTemp|SollTempMaxVal|SollTempMinVal)
                                                sRES=$(echo -n ${sRES} | awk '{printf "%02d.%02d\n",substr($0,0,length($0)-2),substr($0,length($0)-1)}')
                                                ;;
                                        DateTime)
                                                sRES=$(date -d "@${sRES}")                      # convert epoch date to date string
                                                ;;
                                        OPMode)
                                                case ${sRES} in
                                                        0)      sRES=$(printf "%d\t%s" ${sRES} "Normal")
                                                                ;;
                                                        1)      sRES=$(printf "%d\t%s" ${sRES} "Night")
                                                                ;;
                                                        2)      sRES=$(printf "%d\t%s" ${sRES} "Holiday")
                                                                ;;
                                                        *)      sRES=$(printf "%d\t%s" ${sRES} "Anomalous value")
                                                esac
                                                ;;
                                esac

                                if [[ -z "${sLIN}" ]]; then
                                        sHDR="Date,Time,IP,${sCMD}"
                                        sLIN="${sDATE},${sIP},${sRES}"
                                else
                                        sHDR="${sHDR},${sCMD}"
                                        sLIN="${sLIN},${sRES}"
                                fi
                                printf "G%d.%-22s:\t%s\n" $a "${sCMD}" "${sRES}"
                                aFIELDNAM[${iCNT}]=G${a}.${sCMD}
                                aFIELDVAL[${iCNT}]="${sRES}"
                                iCNT=$((iCNT+1))
                        fi
                done
                if [[ -z "${DEBUG}" ]]; then                                            # In DEBUG mode we do not output anything
                        if [[ ! -e ${sLOG} ]]; then echo ${sHDR} >${sLOG}; fi
                        printf "${sLIN}\n" >>${sLOG}
                else
                        if [[ ${#sLIN} -gt 0 ]]; then printf "${sHDR}\n${sLIN}\n";fi
                fi
        done

        # system
        sQUERY="DateTime ErrorCode OPModeRegler Safety SystemStatus Taupunkt WeekProgWarn kurzID numberOfPairedDevices uniqueID"
        sHDR=$(echo -n ${sQUERY} | tr ' ' ',')

        for a in $(seq 0 $iDEVS); do
                sLIN=""
                sHDR=""
                for sCMD in ${sQUERY}; do
                        sRES=$(curl ${sURLPFX}/readVal.cgi?R${a}.${sCMD} 2>/dev/null)
                        if [[ -n "$sRES" ]]; then
                                case "${sCMD}" in
                                        RaumTemp|SollTemp|SollTempMaxVal|SollTempMinVal)
                                                sRES=$(echo -n ${sRES} | awk '{printf "%02d.%02d\n",substr($0,0,length($0)-2),substr($0,length($0)-1)}')
                                                ;;
                                        DateTime)
                                                sRES="${sRES} / "$(date -d "@${sRES}")                  # convert epoch date to date string
                                                ;;
                                esac

                                if [[ -z "${sLIN}" ]]; then
                                        sHDR="Date,Time,IP,${sCMD}"
                                        sLIN="${sDATE},${sIP},${sRES}"
                                else
                                        sHDR="${sHDR},${sCMD}"
                                        sLIN="${sLIN},${sRES}"
                                fi
                                printf "R%d.%-22s:\t%s\n" $a "${sCMD}" "${sRES}"
                                aFIELDNAM[${iCNT}]=R${a}.${sCMD}
                                aFIELDVAL[${iCNT}]="${sRES}"
                                iCNT=$((iCNT+1))
                        fi
                done
                if [[ -z "${DEBUG}" ]]; then                                            # In DEBUG mode we do not output anything
                        if [[ ! -e ${sLOG} ]]; then echo ${sHDR} >${sLOG1}; fi
                        printf "${sLIN}\n" >>${sLOG1}
                else
                        if [[ ${#sLIN} -gt 0 ]]; then printf "${sHDR}\n${sLIN}\n";fi
                fi
        done

# Print CSV header
        if [[ ! -e ${sLOG2} ]]; then
                for a in $(seq 0 ${iCNT}); do
                        printf "%s" ${aFIELDNAM[${a}]}
                        if [[ $a -lt ${iCNT} ]]; then printf ",";fi
                done >>${sLOG2}
                printf "\n" >>${sLOG2}
        fi

# Print CSV values
        for a in $(seq 0 ${iCNT}); do
                printf "\"%s\"" "${aFIELDVAL[${a}]}"
                if [[ $a -lt ${iCNT} ]]; then printf ",";fi
        done  >>${sLOG2}
        printf "\n" >>${sLOG2}  
}


ReadValue () {
        local sRES sPFX sCMD
        sCMD="curl ${sURLPFX}/readVal.cgi?${sKEY}"

        if [[ -n "${@}" ]]; then sPFX="$@ "; fi
        sRES=$(${sCMD} 2>/dev/null)
        sVAL=$(echo -n ${sRES} | awk '{printf "%02d.%02d\n",substr($0,0,length($0)-2),substr($0,length($0)-1)}')
        if [[ -n "${sVAL}" ]]; then
                printf "%s=%-25s%s\n" "${sKEY}" "${sVAL}" "${sPFX}"
        else
                printf "%-25s:\t${sKEY} returned no value\n%-25s\t${sCMD}\n" "Variable error" " " 1>&2
        fi
}

WriteValue () {
        local sVALIN sRES
        sVALIN=${sVAL}          # Save current value as ReadValue overwrites this
        ReadValue "Current"
        sRES=$(curl ${sURLPFX}/writeVal.cgi?${sKEY}=${sVALIN} 2>/dev/null)
        ReadValue "New    ${sRES}"
}


# -------------------------------------------------


# Get command line
sCMD=status
while getopts "dishr:w:" o; do
        case $o in
                d)      DEBUG=1
                        ;;
                i)      sIP=${OPTARG}
                        ;;
                s)      sCMD=status
                        ;;
                h)      show_help
#                       printf "\n===============================================\n\n"
#                       GetStatus
                        exit 0
                        ;;
                r)      sCMD=read
                        sKEY="${OPTARG##*=}"
                        unset sVAL
                        ;;
                w)      sCMD=write
                        sKEY="${OPTARG%%=*}"
                        case ${sKEY} in
                                *OPMode|R0.DateTime)
                                        sVAL=${OPTARG##*=}
                                        ;;
                                *)
                                        sVAL=$(echo -n "${OPTARG##*=}0000" | tr -d '.' | cut -b1-4)
                                        ;;
                        esac
                        ;;
                *)      sCMD=status
                        ;;
        esac
done
shift $(($OPTIND - 1))

#
case  ${sCMD} in
        status) GetStatus
                ;;
        write)  WriteValue
                ;;
        read)   ReadValue
                ;;
esac

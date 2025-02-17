#!/bin/bash
#
# AUTHOR:       <The Best Zabbix admin>
# 
# WEBSITE:      https://github.com/linuxsquad/zabbix_mdraid
#
# DATE:         2013-12-31
#
# DESCRIPTION:  LLD for SW RAID (MDRAID)
#
# PRE-REQUISIT:    
#
# INPUT:        see below
#
# OUTPUT:       MD RAID parameters
#              
# RELEASE NOTE:
#  20250216 - Added "chmod 777 ${JSONFILE}" To avoid permission problems

typeset JSONFILE="/tmp/zabbix_mdraid_discovery.json"

#echo "OPTIND is now $OPTIND"
while getopts ":Dm:e:s:d:" optname
do
    case "$optname" in
    "e")
        # Extract string values
        /sbin/mdadm --detail ${MD_dev} | grep "${OPTARG}" | awk -F":" '{print $2}' | tr -d [[:space:]]
    ;;
    "s")
        # echo "Size of the array"
        /sbin/mdadm --detail ${MD_dev} | grep "${OPTARG}" | awk -F":" '{print $2}' | sed -e "s/(.*//" | tr -d [[:space:]]
    ;;
    "d")
        # echo "Devices in the array"
        /sbin/mdadm --detail ${MD_dev} | tail -n+2 | grep "/dev/" | awk -v x=${OPTARG} '$4 == x {print $5,$6,$7}'
    ;;
    "m")
        # echo "Setting MD RAID"
        MD_dev="${OPTARG}"
    ;;
    "D")
        # echo "Discovery"
        echo -en "{\n \"data\":[" > ${JSONFILE}
        cat /proc/mdstat | grep ^md | while read line
        do
            MDdev=`echo $line | awk '{print $1}'`
            echo -en "\n { \"{#MD_DEVICE}\":\"/dev/${MDdev}\" }," >> ${JSONFILE}
        done
        echo -e " ]\n}" >> ${JSONFILE}
        # this awkward way to handle removal of coma from the last line"          
        cat ${JSONFILE} | sed -e 's/}, ]/}\n ]/'
        chmod 777 ${JSONFILE}
    ;;
    "?")
        echo "Unknown option $OPTARG"
    ;;
    ":")
        echo "No argument value for option $OPTARG"
    ;;
    *)
        # Should not occur
        echo "Unknown error while processing options"
    ;;
    esac
    # echo "OPTIND is now $OPTIND"
done

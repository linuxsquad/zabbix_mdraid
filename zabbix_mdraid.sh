#!/bin/bash
#
# AUTHOR: <The Best Zabbix admin>
#
# DATE:   2013-12-31
#
# DESCRIPTION:     LLD for SW RAID (MDRAID)
#
# PRE-REQUISIT:    
#
# INPUT:      see below
#
# OUTPUT:     MD RAID parameters
#              
# RELEASE NOTE:

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
	    echo -e "{\n\t\"data\":["	    
	    typeset -i nbLines
	    typeset -i cntLines=0
	    nbLines=`cat /proc/mdstat | grep ^md | wc -l`
	    cat /proc/mdstat | grep ^md | while read line
	    do
	    	cntLines=${cntLines}+1
		MDdev=`echo $line | awk '{print $1}'`
		if [ ${cntLines} -eq ${nbLines} ]; then
			echo -e "\t{ \"{#MD_DEVICE}\":\t\"/dev/${MDdev}\" }"
		else
			echo -e "\t{ \"{#MD_DEVICE}\":\t\"/dev/${MDdev}\" },"
		fi
	    done
	    echo -e "\t]\n}"	    
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
#    echo "OPTIND is now $OPTIND"
done

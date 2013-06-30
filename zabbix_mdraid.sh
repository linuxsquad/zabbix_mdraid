#!/bin/bash


#echo "OPTIND is now $OPTIND"
while getopts ":te:s:d:" optname
do
    case "$optname" in
	"t")
            echo "MD test status"
	    echo mdadm --test /dev/md0
            ;;
	"e")
	    # Extract string values
	    item=$(mdadm --detail /dev/md0 | grep "${OPTARG}" | awk -F":" '{print $2}')
	    echo ${item// /}
            ;;
	"s")
            # echo "Size of the array"
	    item=$(mdadm --detail /dev/md0 | grep "${OPTARG}" | awk -F":" '{print $2}')
	    echo ${item%%\ \(*}
            ;;
	"d")
            # echo "Devices in the array"
	    item=$(mdadm --detail /dev/md0 | tail -n+2 | grep "/dev/" | awk -v x=${OPTARG} '$4 == x {print $5,$6,$7}' )
	    echo ${item}
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


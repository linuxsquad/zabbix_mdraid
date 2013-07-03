
This Zabbix template is design to handle Software RAID (MD) on Linux OS.

Design and Implementaion:

- auto-discovery for all active MDs
- no assumption made about MD name
- currently, only two HDD/SSD reported as members of the array
- trigger is constructed to monitor RAID State.
- to avoid flipping, the trigger will fire if state change sustain for  
 more than one collection cycle

TO DO list
- indtroduce items: failed device, number of failed devices
- auto-discover array devices


Referrence:

https://www.kernel.org/doc/Documentation/md.txt

http://unix.stackexchange.com/questions/47163/whats-the-difference-between-mdadm-state-active-and-state-clean

* thanks to volter, GNU/Colossus @ IRC #zabbix
- thanks to LSI RAID 

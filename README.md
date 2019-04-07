Zabbix template handles Software RAID (MD) on Linux
==================

Design and Implementaion:
-----------------

- auto-discovery for all active MDs
- no assumption made about MD name
- currently, only two HDD/SSD reported as members of the array
- trigger is constructed to monitor RAID State.
- to avoid flipping, the trigger will fire if state change sustain for  
 more than one collection cycle


TO DO list
------

- indtroduce items: failed device, number of failed devices
- auto-discover array devices


Installation
----------------

| File           | Target location                    |
| ------------------------- | ------------------- |
| userparameter_mdraid.conf | /etc/zabbix/zabbix_agentd.d/ |
| zabbix_mdraid.sh | /usr/local/bin/ |
| zabbix_mdraid | /etc/sudoers.d/ |

Apply necessary permissions
```
chmod 400 /etc/sudoers.d/zabbix_mdraid
chown root:root /etc/sudoers.d/zabbix_mdraid
```

Note: sudoers drop-in should not be blindly placed in a folder, but inspected first for conflicts with other drop-ins

Restart the agent to finish configuration. e.g. `systemctl restart zabbix-agent`

Referrence:
-------

- https://www.kernel.org/doc/Documentation/md.txt
- http://unix.stackexchange.com/questions/47163/whats-the-difference-between-mdadm-state-active-and-state-clean
- Zabbix LSI RAID template https://www.zabbix.com/wiki/templates/start

#xen-virtualistion-step-by-step
_available for ubuntu server 12.04 x64 only_

This is our simple scirpt for xen-hypervisor installation.
Modify this script according to your case... :D
* * *
###how to use it
for help
`./main.sh -h`
![help menu](http://i.imgur.com/rsMpzIz)

####steps to be followed:
1. Fist update your ubuntu and install xen
`./main.sh -n`
`./main.sh -i`

2. Then reboot your pc
`sudo reboot`

3. Now chekck if xen is running
`./main.sh -c`

4. Now install xapi and configure bridge
`./main.sh -x`
`sudo ./main.sh -cb`

* * *
Backing up all VM running on a server: ./xen-backup-all.sh root@host
host.pem

Backup VM by name:
`/xen-backup-vm.sh vmname root@host host.pem`

Restore VM:
`xe vm-import filename=vmname.xva`
* * *
[Extra Documentation:](http://lukasz.cepowski.com/projects/xen-backup)
[Xen Steup Steps eXpalined in more details... and more referneces](https://help.ubuntu.com/community/Setting%20up%20Xen%20and%20XAPI%20%28XenAPI%29%20on%20Ubuntu%20Server%2012.04%20LTS%20and%20Managing%20it%20With%20Citrix%20XenCenter%20or%20OpenXenManager)

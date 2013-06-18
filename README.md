#xen-virtualistion-step-by-step
_available for ubuntu server 12.04 x64 only_

This is our simple scirpt for xen-hypervisor installation.

##setup xen with ease with shell scripts
* * *
##how to use it
for help `./main.sh -h`

[help menu](http://i.imgur.com/rsMpzIz)

####steps to be followed:
1.
`./main.sh -n`
`./main.sh -i`

Then reboot your pc `sudo reboot`

Now chekck if xen is running `./main.sh -c`


`./main.sh -i`


Backing up all VM running on a server: ./xen-backup-all.sh root@host
host.pem

Backup VM by name:
`/xen-backup-vm.sh vmname root@host host.pem`

Restore VM:
`xe vm-import filename=vmname.xva`

[Extra Documentation:](http://lukasz.cepowski.com/projects/xen-backup)
[Xen Steup Steps Xpalined](https://help.ubuntu.com/community/Xen)

#!/bin/bash

clear
echo -e "**This script assumes you are installing \n\t template: "Ubuntu 10.04 \(64-bit\)" \n\t with storage repo name-label: 'srepo' <created earlier>\n\t network-interface: 'xenbr0' <created earlier>"

#create a vm form a template of Ubutnu 10.04 64bit
VMID=$(xe vm-install new-name-label=TestVM1 template="Ubuntu Lucid Lynx 10.04 (64-bit)")

#get the uuid of the storage repo
LOCALSRID=$(xe sr-list name-label="srepo" --minimal)

#allocate 30Gb space out of the stroage repo
VDIID=$(xe vdi-create name-label="VDI for ubutnu" sr-uuid=$LOCALSRID type=user virtual-size=30GiB)

VBDID=$(xe vbd-create vdi-uuid=$VDIID vm-uuid=$VMID bootable=false type=Disk device=xvda)

#install for the network, use repository by ntc
xe vm-param-set uuid=$VMID other-config:install-repository=http://np.archieve.ubuntu.com/ubuntu/

#Allocate memory 1GB max
xe vm-memory-limits-set uuid=$VMID static-min=512MiB dynamic-min=512MiB dynamic-max=1GiB static-max=1GiB

#Network settings
VNETID=xe network-list bridge=xenbr0 --minimal
xe vif-create vm-uuid=$VMID network-uuid=$VNETID mac=random device=0

# xe vm-cd-add vm=$VMID device=1 cd-name=centos62_x86_64_mini.iso

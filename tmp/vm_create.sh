#!/bin/bash
set -e
set -x

template=`xe template-list name-label="Ubuntu Lucid Lynx 10.04 (64-bit)" --minimal`
#template=4e5bd641-e476-7648-5ec0-15a884f9af43
vm=`xe vm-install template=$template new-name-label=testvm` sr-uuid=828ee6d7-8f6d-aa65-e863-3c7edf956012
network=`xe network-list bridge=xenbr0 --minimal`
vif=`xe vif-create vm-uuid=$vm network-uuid=$network device=0`

xe vm-param-set uuid=$vm other-config:install-repository=http://np.archive.ubuntu.com/ubuntu
xe vm-param-set uuid=$vm other-config:"disks: <provision><disk device="0" size="8589934592" sr="" bootable="true" type="system"/></provision>"
xe vm-param-set uuid=$vm PV-args="auto-install/enable=true interface=auto netcfg/dhcp_timeout=600 hostname=testvm domain=cflan.net"
xe vm-param-set uuid=$vm memory-static-max=1073741824
xe vm-param-set uuid=$vm memory-static-min=616448000
xe vm-param-set uuid=$vm memory-dynamic-max=1073741824
xe vm-param-set uuid=$vm memory-dynamic-min=616448000
xe vm-start uuid=$vm

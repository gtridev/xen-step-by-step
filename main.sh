#!/bin/bash

WD="$(dirname $0)"
PRG="$(basename $0)"

function Usage {
    echo -e "Usage: \tmy_gen [OPTIONS]"
    echo -e "\t	-i|--install) xen_install"
    echo -e "\t	-c|--chk) check_if_xen_installed"
    echo -e "\t	-x|--install_xapi) install_xapi"
    echo -e "\t	-n|--init) init"
    echo -e "\t	-cb|--createbr) create_bridge"
    echo -e "\t -h|--help) show this help menu"
    exit
}

#check the number of arguments
if [ $# -eq 0 ]; then
    Usage;
    exit 1;
fi

function init {
    cat logo
    # cat ./logo
    space=$(echo -e "\n\t\t\t\t")

    echo "$space Welcome Geek --to this xen step-by-step script. \
 $space Its for Ubuntu Users only...sorry for that:( \
 $space Plez go through https://help.ubuntu.xom/community/Xen if needed\
 $space ............................................................... "

    #components we need to be installed
    echo "$space During the whole installation process we will be installing: \
 $space *xen-hypervisor \
 $space *openssh-server \
 $space *bridge-utils\
 $space *xcp-xapi"


    #first get some updates on your system
    sudo apt-get update

    #install ssh server first...
    #It isNot necessary that ssh server is pre-installed
    sudo apt-get install openssh-server

}

#init
function xen_install {

    #first Install xen
    #$sudo apt-get install xen-hypervisor
    sudo apt-get install xen-hypervisor-amd64

    #adjust xen as a default boot opiton in grub menu and update grub
    sudo sed -i 's/GRUB_DEFAULT=.*\+/GRUB_DEFAULT="Xen 4.1-amd64"/' /etc/default/grub

    #sudo update-grub

    #Disable apparmor at boot
    sudo sed -i 's/GRUB_CMDLINE_LINUX=.*\+/GRUB_CMDLINE_LINUX="apparmor=0"/' /etc/default/grub

    #Restrict "dom0" to 1GB of memory and 1 VCPU
    sudo sed -i '/GRUB_CMDLINE_LINUX=/a\GRUB_CMDLINE_XEN="dom0_mem=1G,max:1G dom0_max_vcpus=1"' /etc/default/grub

    #Update Grub with the config changes we just made
    sudo update-grub
    exit

    #Reboot the server so that Xen boots on the server
    #sudo reboot
}

function check_if_xen_installed {
    #Once the server is back online ensure that Xen is running
   if [ "$(cat /proc/xen/capabilities)" == "control_d" ]
     then
       echo "Bravo... Xen is Running"
   fi

    #should display "control_d"
}

function xapi_install {
	#install XCP-XAPI
	sudo apt-get install xcp-xapi

	#setup the default toolstack
 	sudo sed -i 's/TOOLSTACK=.*/TOOLSTACK=xapi/' /etc/default/xen

	# Disable xend from starting at boot
	sudo sed -i -e 's/xend_start$/#xend_start/' -e 's/xend_stop$/#xend_stop/' /etc/init.d/xend

	#disable service xendomains
	sudo update-rc.d xendomains disable

	#Fix for "qemu" which emulates the console does not have the keymaps in the correct location
	sudo mkdir /usr/share/qemu;
	sudo ln -s /usr/share/qemu-linaro/keymaps /usr/share/qemu/keymaps
}

##Network configuration
#ask user for ip_addr, netmask, gateway, dns-server
function create_bridge {

    echo "installing the bridge-utils"
    #fist install brige controller

    sudo apt-get install bridge-utils

    sudo mv /etc/network/interfaces /etc/network/interfaces.save.$(date '+%a-%h-%d-%Y')
    #create a bond called xenbr0
    # Xen network interface for "dom0"

    #sudo sed -i 's/auto/#auto/' /etc/network/interfaces
    sudo echo -e "auto xenbr0\niface xenbr0 inet static\n" > /etc/network/interfaces
    #bridge_ports eth0
    #iface eth0 inet manual

    sudo echo "please provide valid static values"
    read -p "IP Address: [default: 192.168.2.165]  " addr; if [ "${#addr}" -eq 0 ]; then  addr="192.168.2.165"; fi
    read -p 'Sub NetMask:[default: 255.255.254.0] ' nmsk; if [ "${#nmsk}" -eq 0 ]; then nmsk='255.255.254.0' ; fi
    read -p 'Gateway:    [default: 192.168.2.1] ' gway ;  if [ "${#gway}" -eq 0 ]; then gway='192.168.2.1'	 ; fi
    read -p 'DNS Server: [default: 192.168.2.5] ' dsrv ;  if [ "${#dsrv}" -eq 0 ]; then dsrv='192.168.2.5'	 ; fi

    sudo echo -e "address $addr\nnetmask $nmsk\ngateway $gway\ndns-nameservers $dsrv" >>/etc/network/interfaces
    #     echo -e "address $addr\nnetmask $nmsk\ngateway $gway\ndns-nameservers $dsrv" >/tmp/file
    sudo echo -e " bridge_ports eth0 \n iface eth0 inet manual" >> /etc/network/interfaces
    echo -e "\n\nSo the input provided is: "
    echo "---------------------------"
    cat /etc/network/interfaces
#   cat /tmp/file

    #Configure xcp to use "bridge" networking instead of "openswitch"
    sudo sed -i 's/openvswitch/bridge/'  /etc/xcp/network.conf

    #then restart network to check everythings works well...
    sudo /etc/init.d/networking restart
}

#installing the virtual machines
function virtual_machine_install {
    uuid=$(xe vm-install template='Other install media' new-name-label=$2)

    #set memory range {dynamic,static}
    #formula for these values is StaticMin ≤ DynamicMin ≤ DynamicMax ≤ StaticMax
    xe vm-param-set uuid=$uuid memory-static-max=1073741824  #1gb
    xe vm-param-set uuid=$uuid memory-dynamic-max=1073741824 #1gb
    xe vm-param-set uuid=$uuid memory-dynamic-min=524288000  #512mb
    xe vm-param-set uuid=$uuid memory-static-min=524288000   #512mb

    #set the targeted memory for domain to be used --fixed size method :P
    xe vm-memory-target-set uuid=$uuid  target=1073741824

    xe vm-param-set uuid=$uuid  other-config:install-repository=http://np.archive.ubuntu.com/ubuntu/
    xe vif-create vm-uuid=$uuid  network-uuid=6827e6bd-319f-6c05-2f4b-c19f687c0362 mac=random device=0
    xe vm-start uuid=$uuid

}



while true; do
    case $1 in
	-h|--help) Usage; exit;;
	-i|--install) xen_install; break;;
	-c|--chk) check_if_xen_installed;break;;
	-x|--install_xapi) install_xapi; break;;
	-n|--init) init; break;;
	-cb|--createbr) create_bridge; break;;
	-vmi|--virtualmc_install) virtual_machine_install; break;;
	--) break;;
    esac
done

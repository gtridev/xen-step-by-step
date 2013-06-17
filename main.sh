#!/bin/bash

WD="$(dirname $0)"
PRG="$(basename $0)"

function Usage {
    echo -e "Usage: \tmy_gen [OPTIONS]"
    echo -e "\t-i   |--install xen-hypervisor"
    echo -e "\t-csr | --creat Storrage repository"
    echo -e "\t-h   | --help\tDisplay this message"
    exit
}

#check the number of arguments
if [ $# -eq 0 ]; then
    Usage;
    exit 1;
fi

function init {
#cat logo
    cat ./logo
    echo "Welcome to this xen step-by-step script...\
	Its for Ubuntu Users only...sorry:(\
	Plez go through https://help.ubuntu.xom/community/Xen "

    
    #first get some updates on your system
    sudo apt-get update
    
    #install ssh server first...
    #It isNot necessary that ssh server is pre-installed
    sudo apt-get install openssh-server
    
}

#init
function xen_install {
    
    #init
    #first Install xen 
    #$sudo apt-get install xen-hypervisor
    sudo apt-get install xen-hypervisor-amd64
    
    #adjust xen as a default boot opiton in grub menu and update grub
    sed -i 's/GRUB_DEFAULT=.*\+/GRUB_DEFAULT="Xen 4.1-amd64"/' /etc/default/grub

    #sudo update-grub

    #Disable apparmor at boot 
    sudo sed -i 's/GRUB_CMDLINE_LINUX=.*\+/GRUB_CMDLINE_LINUX="apparmor=0"/' /etc/default/grub

    #Restrict "dom0" to 1GB of memory and 1 VCPU
    sudo sed '/GRUB_CMDLINE_LINUX=/a\GRUB_CMDLINE_XEN="dom0_mem=1G,max:1G dom0_max_vcpus=1"' /etc/default/grub 

    #Update Grub with the config changes we just made
    sudo update-grub
    exit

    #Reboot the server so that Xen boots on the server
    #sudo reboot
}

function check_if_xen_installed {
    #Once the server is back online ensure that Xen is running
   if [ "$(cat /proc/xen/capabilities)" == "control_d" ]
      echo "Bravo... Xen is Running"
   fi
   
    #should display "control_d"
}


while true; do
    case $1 in
	-h|--help) Usage; exit;;
	-i|--install) xen_install; break;;
	-c|--chk) check_if_xen_installed;break;;
	-x|--install_xapi) install_xapi; break;;
	-n|--init) init; break;;
	
	--) break;;
    esac 
done





#!/bin/bash

@echo "Welcome to this xen step-by-step script...\
	Its for Ubuntu Users only...sorry:(\
	Plez go through https://help.ubuntu.xom/community/Xen "
#cat logo
cat logo

#first get some updates on your system
sudo apt-get update

#install ssh server first...
#It isNot necessary that ssh server is pre-installed
sudo apt-get install openssh-server

#first Install xen 
#sudo apt-get install xen-hypervisor
sudo apt-get install xen-hypervisor-amd64

#adjust xen as a default boot opiton in grub menu and update grub
sudo sed -i 's/GRUB_DEFAULT=.*\+/GRUB_DEFAULT="Xen 4.1-amd64"/' /etc/default/grub
#sudo update-grub

#Disable apparmor at boot 
sudo sed -i 's/GRUB_CMDLINE_LINUX=.*\+/GRUB_CMDLINE_LINUX="apparmor=0"/' /etc/default/grub

#Restrict "dom0" to 1GB of memory and 1 VCPU
sed '/GRUB_CMDLINE_LINUX=/a\GRUB_CMDLINE_XEN="dom0_mem=1G,max:1G dom0_max_vcpus=1"' /etc/default/grub 

#Update Grub with the config changes we just made
sudo update-grub

#Reboot the server so that Xen boots on the server
sudo reboot

#Once the server is back online ensure that Xen is running
#cat /proc/xen/capabilities should display "control_d"








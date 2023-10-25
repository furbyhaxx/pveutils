#!/bin/bash


echo "net.ipv4.ip_forward=1" >> "/etc/sysctl.conf"
echo "vm.swapiness=0" >> "/etc/sysctl.conf"

# disable swap
swapoff -a



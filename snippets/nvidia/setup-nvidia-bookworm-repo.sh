#!/bin/bash

# remove residues
echo "> Cleanup old attempts." 
rm /etc/apt/preferences.d/cuda-repository-pin-600
rm /etc/apt/sources.list.d/cuda-debian12-x86_64.list
sudo apt remove --purge '*nvidia*'
sudo apt remove --purge '*cuda*'

# update
sudo apt update

apt install -y nvidia-driver

# add nvidia bookworm repo
echo "> Adding Cuda Repository."
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb

FILE="/etc/apt/sources.list.d/cuda-debian12-x86_64.list"
if [ ! -f "$FILE" ]; then
cat <<EOF | tee /etc/apt/sources.list.d/cuda-debian12-x86_64.list
deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/ /
EOF
echo

fi

# set repo priority
echo "> Preffer Cuda Repository."
cat <<EOF | tee /etc/apt/preferences.d/nvidia-repo-priority
Package: *
Pin: release o=NVIDIA,l=NVIDIA CUDA
Pin-Priority: 1000
EOF
echo


sudo apt update -y

#sudo apt-mark unhold nvidia-driver

sudo apt upgrade -y
sudo apt install -y nvidia-driver
sudo apt -y install cuda-toolkit-12-3
sudo apt-mark hold nvidia-driver

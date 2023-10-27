#!/bin/bash


# Enroll the new signing key:
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-archive-keyring.gpg
sudo mv cuda-archive-keyring.gpg /usr/share/keyrings/cuda-archive-keyring.gpg

# Enable the network repository:
echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | sudo tee /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list

# Add pin file to prioritize CUDA repository:
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600


read -p "Do you want to install the latest cuda? (YES/no) " yn

case $yn in 
	yes|YES|y|Y|"" ) echo ok, we will proceed;;
	no|NO|n|N ) echo exiting...;
		exit;;
	* ) echo wrong input, exiting;
	exit 1;
esac

sudo apt update

# Install CUDA SDK:
sudo apt install -y cuda-toolkit

# Install CUDA GDS
sudo apt install -y nvidia-gds

# Alter PATH
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

echo "Done"

read -p "Do you want to reboot now (YES/no) " yn
case $yn in 
	yes|YES|y|Y|"" ) echo ok, we will proceed;;
	no|NO|n|N ) echo exiting...;
		exit;;
	* ) echo wrong input, exiting;
	exit 1;
esac

sudo reboot

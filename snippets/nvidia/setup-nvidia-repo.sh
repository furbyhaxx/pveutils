#!/bin/bash


# Enroll the new signing key:
#wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-archive-keyring.gpg
#sudo mv cuda-archive-keyring.gpg /usr/share/keyrings/cuda-archive-keyring.gpg
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb

# Enable the network repository:
#echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | sudo tee /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list

# Add pin file to prioritize CUDA repository:
#wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
#sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
echo "> Pin Cuda Repository."
cat <<EOF | tee /etc/apt/preferences.d/priority-nvidia
Package: *
Pin: release o=NVIDIA,l=NVIDIA CUDA
Pin-Priority: 100
EOF
echo

echo "> Updating APT packages."
sudo apt update

read -p "Do you want to install the latest nvidia driver and hold it on this version? (YES/no) " yn

case $yn in 
	yes|YES|y|Y|"" ) echo ok, we will proceed;;
	no|NO|n|N ) echo exiting...;
		exit;;
	* ) echo wrong input, exiting;
	exit 1;
esac


apt install -y nvidia-driver

sudo apt-mark hold nvidia-driver

read -p "Do you want to install the latest cuda version? (YES/no) " yn

case $yn in 
        yes|YES|y|Y|"" ) echo ok, we will proceed;;
        no|NO|n|N ) echo exiting...;
                exit;;
        * ) echo wrong input, exiting;
        exit 1;
esac


# Install CUDA SDK:
#sudo apt install -y cuda-toolkit
sudo apt install -y cuda-toolkit-12-3

# Install CUDA GDS
#sudo apt install -y nvidia-gds

# Alter PATH
echo "> Set environment variables."
cat <<EOF | tee /etc/environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/cuda/bin"
LD_LIBRARY_PATH="/usr/local/cuda/lib64"
echo


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

#!/bin/bash

git clone https://github.com/keylase/nvidia-patch.git

cd nvidia-patch

chmod +x patch.sh
chmod +x patch-fbc.sh

./patch.sh
./patch-fbc.sh

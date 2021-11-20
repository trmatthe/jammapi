#!/bin/bash

printf "1. Installing Dependencies\n"
sudo apt update
sudo apt install -y git
cd ~/dev
git clone https://github.com/rtomasa/JammaPi
cd ~/dev/JammaPi
chmod +x install.sh

printf "2. Installing Joystick Driver\n"
sudo sh -c "echo 'i2c-dev' >> /etc/modules"
## This is for autoboot driver but Pi hangs
##sudo sh -c "echo 'joypi' >> /etc/modules"
cd ~/dev/JammaPi/joypi/
make clean
cd ~/dev/JammaPi/joypi/src/
# The following 2 lines are due to GCC greater than 5.0.0
rm mcp23017.c
mv mcp23017-5.c mcp23017.c
cd ~/dev/JammaPi/joypi/
make
sudo make install
sudo insmod joypi.ko

printf "Installing jammapi overlay\n"
sudo sh -c "echo 'dtparam=i2c_vc=on' >> /boot/config.txt"

printf "4. Removing Temporal Files\n"
cd ~/dev
sudo rm -r JammaPi

printf "++ INSTALLATION COMPLETED!!! ++\n"
printf "++ REBOOT TO MAKE CHANGES ACTIVE!!! ++\n"
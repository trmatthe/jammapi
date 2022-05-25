#!/usr/bin/env bash

# 19-may-2022 trmatthe: Rewritten installer to be idempotent, simplified source file swapping
#             based on gcc version to make likely case the default.

TARGET=/lib/modules/$(uname -r)/kernel/drivers/input/joystick/joypi.ko

# build the kernel module
cd joypi
make

if [[ $? -gt 0 ]]; then
  echo "make failed with $?, exiting."
  exit
fi

if [[ ! -f "$TARGET" ]]; then
  sudo make install
  sudo depmod -a
else 
  echo "joypi.ko already exists, do you want to continue?"
  select cont in "Y" "n"; do
    case $cont in
      Y) sudo make install; sudo depmod -a; break;;
      n) exit;;
    esac
  done
fi

# add to /etc/modules if necessary
ADDED=""
if [[ $(grep "i2c-dev" /etc/modules 1&>/dev/null) -eq 0 ]]; then
  echo i2c-dev  | sudo tee -a /etc/modules
  ADDED=$ADDED"i2c-dev to /etc/modules\n"
fi

if [[ $(grep "joypi" /etc/modules 1&>/dev/null) -eq 0 ]]; then
  echo joypi | sudo tee -a /etc/modules
  ADDED=$ADDED"joypi to /etc/modules\n"
fi

if [[ $(grep "dtparams=i2c_vc=on" /boot/config.txt 1&>/dev/null) -eq 0 ]]; then
  echo "dtparams=i2c_vc=on" | sudo tee -a /boot/config.txt
  ADDED=$ADDED"dtparams=i2c_vc=on to /boot/config.txt\n"
fi

if [[ -n  "$ADDED" ]]; then
  echo "The following changes were made:\n$ADDED"
fi

echo "Module built for kernel $(modinfo -F vermagic) and kernel is $(uname -r)"
sudo insmod "$TARGET"

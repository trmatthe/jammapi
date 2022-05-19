# JammaPi

Script for installing the RGB-Pi JammaPi driver.

Forked from the installer repo and modified to make more robust:

1. Old version swapped in a modified source file for the .ko I have manually done this
   because I can't see any reason for leaving a manual step.

2. Script now checks to see if /etc/modules and /boot/config.txt have had entries added: if
   so they won't be added again.

3. I saw an issue where the module built, but was configured for a different kernel to the 
   running image, so now dump the vermagic and running release for verification.



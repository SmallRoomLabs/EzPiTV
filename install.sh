#!/bin/bash

export LC_ALL=C

#--------------------------------------------------------------------------------------

# Change repo
sed -i "s/mirrordirector.raspbian.org/mirror.ox.ac.uk\/sites\/archive.raspbian.org\/archive/" /etc/apt/sources.list
false; until [[ $? -eq 0 ]]; do
  apt-get update
done

#

# Use dropbear instead of openssh
apt-get -y remove openssh-server
false; until [[ $? -eq 0 ]]; do
  apt-get install -y dropbear
done

# Use busybox logger instead of rsyslog
false; until [[ $? -eq 0 ]]; do
  apt-get install -y busybox-syslogd
done
dpkg --purge logrotate dphys-swapfile rsyslog

# Remove uneccessary packages
dpkg --purge avahi-daemon libnss-mdns bluez pi-bluetooth bluez-firmware triggerhappy libraspberrypi-doc
dpkg --purge python-rpi.gpio python python2.7 dh-python apt-listchanges lsb-release python3-apt python3 python3.5
dpkg --purge python-apt-common python-minimal python2.7-minimal python3-minimal python3.5-minimal
dpkg --purge gdb libpython2.7:armhf libpython3:armhf libpython3.5:armhf
dpkg --purge libpython-stdlib:armhf libpython2.7-stdlib:armhf libpython3-stdlib:armhf libpython3.5-stdlib:armhf
dpkg --purge libpython2.7-minimal:armhf libpython3.5-minimal:armhf
dpkg --purge nfs-common libnfsidmap2:armhf
dpkg --purge raspi-config lua5.1 luajit libluajit-5.1-common
dpkg --purge openssh-sftp-server openssh-client openssh-server ssh

# Clean up leftovers
apt -y autoremove

# Make sure we have the latest and greatest packages
false; until [[ $? -eq 0 ]]; do
  apt-get upgrade -y
done

# Install some requred packages for EzPiTV
false; until [[ $? -eq 0 ]]; do
  apt-get install -y joe
done

false; until [[ $? -eq 0 ]]; do
  apt-get install -y git
done

false; until [[ $? -eq 0 ]]; do
  apt-get install -y curl
done

false; until [[ $? -eq 0 ]]; do
  apt-get install -y ffmpeg
done

false; until [[ $? -eq 0 ]]; do
  apt-get install -y phantomjs 
done

false; until [[ $? -eq 0 ]]; do
  apt-get install -y imagemagick
done

# Remove cached packages
apt-get clean

#--------------------------------------------------------------------------------------

# Disable screen blanking/saver
sed -i s/$/\ consoleblank=0/ /boot/cmdline.txt

#--------------------------------------------------------------------------------------

# Create a ramdisk for current image
mkdir -p /mnt/tmpfs
chmod 0777 /mnt/tmpfs/
mount -o size=7M -t tmpfs none /mnt/tmpfs

#--------------------------------------------------------------------------------------

# Setup framenbuffer screen format
cat << EOF > /boot/config.txt
# For more options and information see
# http://rpf.io/configtxt
# Some settings may impact device functionality. See link above for details

# uncomment if you get no picture on HDMI for a default "safe" mode
#hdmi_safe=1

# uncomment this if your display has a black border of unused pixels visible
# and your display can output without overscan
#disable_overscan=1

# uncomment the following to adjust overscan. Use positive numbers if console
# goes off screen, and negative if there is too much border
#overscan_left=16
#overscan_right=16
#overscan_top=16
#overscan_bottom=16

# uncomment to force a console size. By default it will be display's size minus
# overscan.
framebuffer_width=1080
framebuffer_height=1920

# Display orientation
gpu_mem=128
display_rotate=1

# uncomment if hdmi display is not detected and composite is being output
#hdmi_force_hotplug=1

# uncomment to force a specific HDMI mode (this will force VGA)
#hdmi_group=1
#hdmi_mode=1

# uncomment to force a HDMI mode rather than DVI. This can make audio work in
# DMT (computer monitor) modes
#hdmi_drive=2

# uncomment to increase signal to HDMI, if you have interference, blanking, or
# no display
#config_hdmi_boost=4

# uncomment for composite PAL
#sdtv_mode=2

#uncomment to overclock the arm. 700 MHz is the default.
#arm_freq=800

# Uncomment some or all of these to enable the optional hardware interfaces
#dtparam=i2c_arm=on
#dtparam=i2s=on
#dtparam=spi=on

# Uncomment this to enable the lirc-rpi module
#dtoverlay=lirc-rpi

# Additional overlays and parameters are documented /boot/overlays/README

# Enable audio (loads snd_bcm2835)
#dtparam=audio=on
EOF

#--------------------------------------------------------------------------------------

git clone https://github.com/SmallRoomLabs/EzPiTV.git
chown -R pi:pi *
mv EzPiTV/* .
rm -rf EzPiTV
gcc -O2 -o ppmto565 ppmto565.c

#--------------------------------------------------------------------------------------

sed -i '$i/home/pi/drawscreen.sh &' /etc/rc.local

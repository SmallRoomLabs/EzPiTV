#!/bin/bash

#--------------------------------------------------------------------------------------

# Have the SSH deamon start automatically
update-rc.d ssh enable

#--------------------------------------------------------------------------------------

# Create a ramdisk for current image
mkdir -p /mnt/tmpfs
mount -o size=7M -t tmpfs none /mnt/tmpfs

#--------------------------------------------------------------------------------------

# Remove uneccessary packages
dpkg --purge triggerhappy 
dpkg --purge avahi-daemon libnss-mdns 
dpkg --purge bluez pi-bluetooth bluez-firmware

# Make sure we get the latest and greatest packages
apt-get update
apt-get upgrade -y

# Requred packages for EzPiTV
apt-get install -y curl ffmpeg phantomjs imagemagick figlet

# Some extra convenience packages
apt-get install -y joe git nmap ngrep 

# Use dropbear instead of openssh
apt-get install -y dropbear
sed -i s/NO_START=1/NO_START=0/ /etc/default/dropbear
/etc/init.d/ssh stop
/etc/init.d/dropbear start
apt-get -y remove openssh-server
apt -y autoremove

#--------------------------------------------------------------------------------------

# Disable screen blanking/saver
sed -i s/$/\ consoleblank=0/ /boot/cmdline.txt

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

sudo sed -i '$i/home/pi/drawscreen.sh &' /etc/rc.local

# EzPiTV
## RaspberryPi image player using Google Slides

### Installation

- Install Raspbian Stretch Lite from https://www.raspberrypi.org/downloads/raspbian/ 
- Flash it to the SD card using Etcher https://etcher.io/ 
- copy [boot] /issue.txt to /ssh.txt
- edit [boot] cmdline.txt and remove the `init=/usr/lib/raspi-config/init_resize.sh` from the end of line 
- replace the contents of [rootfs] /etc/wpa_supplicant/wpa_supplicant.conf with the following 
```
country=SE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="Telia-5472AD"
    psk="230C338812"
    scan_ssid=1
}
```
- Eject the SD card safely from the computer and boot the RPi with it
- Connect with SSH to the address displayed at the bottom of the screen using pi/raspberry
- Execute the installation script with
```
wget -O - "https://raw.githubusercontent.com/SmallRoomLabs/EzPiTV/master/install.sh?token=AAT2zt7V28Xz80O6aMWoUcE1YQAkhgluks5aqDc8wA%3D%3D" | sudo bash```


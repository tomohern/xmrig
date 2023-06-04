#!/bin/bash

sudo systemctl stop xmrig.service
sudo systemctl disable xmrig.service
sudo rm /etc/systemd/system/xmrig.service
sudo apt purge msr-tools -y
rm ~/xmrig/xmrig-6.19.2-focal-x64.tar.gz
rm -rf ~/xmrig-6.19.2/

#!/bin/bash

#Download and extract xmrig
wget https://github.com/xmrig/xmrig/releases/download/v6.19.2/xmrig-6.19.2-focal-x64.tar.gz && tar xzvf xmrig-6.19.2-focal-x64.tar.gz -C ~/

#Update config file with the correct number of CPU cores
procs=$(nproc)
echo $procs
if [[ $procs -eq 4 ]]
then
sed -i 's/    "cpu": true,/    "cpu": {\n        "rx": [0, 1, 2, 3],\n    },/' config.json
elif  [[ $procs -eq 8 ]]
then
sed -i 's/    "cpu": true,/    "cpu": {\n        "rx": [0, 1, 2, 3, 4, 5, 6, 7],\n    },/' config.json
elif  [[ $procs -eq 12 ]]
then
sed -i 's/    "cpu": true,/    "cpu": {\n        "rx": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],\n    },/' config.json
else
echo 'error'
fi

#Update config file with correct hostname
name=$(hostname)
echo $name
sed -i 's/            "pass": "rig1",/            "pass": "'$name'",/' config.json

#Copy Config file to xmrig directory
cp config.json ~/xmrig-6.19.2/

#Run the randomx boost script
cd ~/xmrig-6.19.2/
wget https://raw.githubusercontent.com/xmrig/xmrig/master/scripts/randomx_boost.sh
#chmod +x randomx_boost.sh
sudo apt install msr-tools
sudo ./randomx_boost.sh

#Install and start service
sudo cp ~/xmrig/xmrig.service /etc/systemd/system/
sudo systemctl enable --now xmrig

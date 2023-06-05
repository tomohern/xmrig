#!/bin/bash

##Run the randomx boost script
#wget https://raw.githubusercontent.com/xmrig/xmrig/master/scripts/randomx_boost.sh
#chmod +x randomx_boost.sh
sudo apt install msr-tools -y
sudo ~/xmrig/randomx_boost.sh

#Download and extract xmrig
wget https://github.com/xmrig/xmrig/releases/download/v6.19.2/xmrig-6.19.2-focal-x64.tar.gz && tar xzvf xmrig-6.19.2-focal-x64.tar.gz -C ~/

#Update config file with the correct number of CPU cores
procs=$(nproc)
echo $procs
if [[ $procs -eq 4 ]]
then
sed -i 's/    "cpu": true,/    "cpu": {\n        "rx": [0, 1, 2, 3],\n    },/' ~/xmrig/config.json
elif  [[ $procs -eq 8 ]]
then
sed -i 's/    "cpu": true,/    "cpu": {\n        "rx": [0, 1, 2, 3, 4, 5, 6, 7],\n    },/' ~/xmrig/config.json
elif  [[ $procs -eq 12 ]]
then
sed -i 's/    "cpu": true,/    "cpu": {\n        "rx": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],\n    },/' ~/xmrig/config.json
else
echo 'error'
fi

#Update config file with correct hostname
name=$(hostname)
echo $name
sed -i 's/            "pass": "rig1",/            "pass": "'$name'",/' ~/xmrig/config.json

#Copy Config file to xmrig directory
cp ~/xmrig/config.json ~/xmrig-6.19.2/

#Install and start service
user=$(whoami)
sed -i "s/user1/$user/g" ~/xmrig/xmrig.service
sudo cp ~/xmrig/xmrig.service /etc/systemd/system/
sudo systemctl enable --now xmrig

echo "To monitor use: journalctl -u xmrig -n 50 -f"

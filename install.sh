#!/bin/bash

wget https://github.com/xmrig/xmrig/releases/download/v6.19.2/xmrig-6.19.2-focal-x64.tar.gz
tar xzvf xmrig-6.19.2-focal-x64.tar.gz -C ~/
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

name=$(hostname)
echo $name
sed -i 's/            "pass": "rig1",/            "pass": "'$name'",/' config.json

cp config.json ~/xmrig-6.19.2/

cd ~/xmrig-6.19.2/
wget https://github.com/xmrig/xmrig/blob/master/scripts/randomx_boost.sh
chmod +x randomx_boost.sh
sudo apt install msr-tools
./randomx_boost.sh
sudo cp xmrig.service /etc/systemd/system/
sudo systemctl enable --now xmrig

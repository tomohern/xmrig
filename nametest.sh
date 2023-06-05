#!/bin/bash

#Update config file with correct hostname
name=$(hostname)
model=$(sudo dmidecode -t system | awk -F ' ' '/Product Name/ {print $4}')
cpu=$(lscpu | awk -F ' ' '/Model name/ {print $5}')
result="$name-$model-$cpu"
echo $result

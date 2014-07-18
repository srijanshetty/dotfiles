#!/bin/zsh

IP=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}' | awk -F : '{print $2}')

if [ -n "$IP"]; then
    IP=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}' | awk -F : '{print $2}')
fi

echo $IP

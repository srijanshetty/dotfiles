#!/bin/zsh

ifconfig wlan0 | grep 'inet ' | awk '{print $2}' | awk -F : '{print $2}'

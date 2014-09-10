#!/bin/sh

/home/srijan/Documents/GitHub/xSwipe/xSwipe.pl &
btsync &> /dev/null
sudo service auth start

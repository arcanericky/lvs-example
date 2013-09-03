#!/bin/sh

DIRECTOR_PRIMARY_ADDRESS=192.168.139.130

netstat -rn
echo

echo Adding default route to directory primary address
CMD="route add default gw $DIRECTOR_PRIMARY_ADDRESS"
echo '  '$CMD
$CMD
echo

netstat -rn

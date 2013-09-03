#!/bin/sh

DIRECTOR_PRIMARY_ADDRESS=192.168.139.130

netstat -rn
echo

echo Adding default route to directory primary address
echo '  'route add default gw $DIRECTOR_PRIMARY_ADDRESS
route add default gw $DIRECTOR_PRIMARY_ADDRESS
echo

netstat -rn

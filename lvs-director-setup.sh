#!/bin/sh

DIRECTOR_SUBNET=192.168.139
DIRECTOR_ALIAS_OCTET=131
DIRECTOR_BALANCE_PORT=2202
REALSERVER1=192.168.139.132:22
REALSERVER2=192.168.139.129:22
DIRECTOR=$DIRECTOR_SUBNET.$DIRECTOR_ALIAS_OCTET

echo Enabling IP forwarding...
echo 1 > /proc/sys/net/ipv4/ip_forward

echo Creating IP alias...
CMD="ifconfig eth0:$DIRECTOR_ALIAS_OCTET $DIRECTOR broadcast $DIRECTOR_SUBNET.255 netmask 255.255.255.0"
echo '  '$CMD
$CMD 

echo Clearing virtual server table...
CMD="ipvsadm -C"
echo '  '$CMD
$CMD 

echo Adding load balance port...
CMD="ipvsadm -A -t $DIRECTOR:$DIRECTOR_BALANCE_PORT -s rr"
echo '  '$CMD
$CMD

echo Adding real servers...
CMD="ipvsadm -a -t $DIRECTOR:$DIRECTOR_BALANCE_PORT -r $REALSERVER1 -m -w 1"
echo '  '$CMD
$CMD

CMD="ipvsadm -a -t $DIRECTOR:$DIRECTOR_BALANCE_PORT -r $REALSERVER2 -m -w 1"
echo '  '$CMD
$CMD

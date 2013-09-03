#!/bin/sh

DIRECTOR_SUBNET=192.168.139
DIRECTOR_ALIAS_OCTET=131
REALSERVER1=192.168.139.132:22
REALSERVER2=192.168.139.129:22
DIRECTOR=$DIRECTOR_SUBNET.$DIRECTOR_ALIAS_OCTET

echo Creating IP alias...
echo '  'ifconfig eth0:$DIRECTOR_ALIAS_OCTET $DIRECTOR broadcast $DIRECTOR_SUBNET.255 netmask 255.255.255.0
ifconfig eth0:$DIRECTOR_ALIAS_OCTET $DIRECTOR broadcast $DIRECTOR_SUBNET.255 netmask 255.255.255.0

echo Clearing virtual server table...
echo '  'ipvsadm -C
ipvsadm -C

echo Adding load balance port...
echo '  'ipvsadm -A -t $DIRECTOR:2202 -s rr
ipvsadm -A -t $DIRECTOR:2202 -s rr

echo Adding real servers...
echo '  'ipvsadm -a -t $DIRECTOR:2202 -r $REALSERVER1 -m -w 1
ipvsadm -a -t $DIRECTOR:2202 -r $REALSERVER1 -m -w 1
echo '  'ipvsadm -a -t $DIRECTOR:2202 -r $REALSERVER2 -m -w 1
ipvsadm -a -t $DIRECTOR:2202 -r $REALSERVER2 -m -w 1

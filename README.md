### Simple Load Balancing using Linux Virtual Servers (LVS)
If you need to spin up a quick environment for load balance Linux systems, Linux Virtual Servers is a good way to do it. It should be built into your Linux kernel, but you'll need the command line front end to configure it. In addition, you'll need two Linux servers to use as your pool of real servers along with a third server that will function as your load balancer (referred to as a director). Hint: virtual machines are great for this.

#### Director
On your machine which functions as a director you'll need the command line utility for configuring LVS. Get it with:
```
$ apt-get install ipvsadm
```

Clone this project with:
```
$ git clone https://github.com/arcanericky/lvs-example.git
```

You'll be giving your director an additional IP address called an IP alias. Be sure to use one that's not already on the network. Choosing an IP address in the same subnet and adding 1 to the last octet will probably work. If you need help finding an available IP address on your subnet, LVS may not be for you.

Modify the `lvs-director-setup.sh` script to reflect the subnet and last IP octet of the IP alias you'll be using for your director along with the incoming port to balance.
```
DIRECTOR_SUBNET=192.168.139
DIRECTOR_ALIAS_OCTET=131
DIRECTOR_BALANCE_PORT=2202
```
Then modify the IP addresses and destination ports of your real servers.
```
REALSERVER1=192.168.139.132:22
REALSERVER2=192.168.139.129:22
```
Execute the script as root on your director and the last lines should look something like this:
```
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.139.131:2202 rr
  -> 192.168.139.129:ssh          Masq    1      0          0
  -> 192.168.139.132:ssh          Masq    1      0          0
```
Incoming connections are now balanced to your real servers but your real servers won't know how to talk back, so let's configure them next.

#### Real Servers
The real servers need to be configured with a route to get back to the director. Modify the `lvs-realserver-setup.sh` with the director's IP alias and execute as root. You should see something like this:
```
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         192.168.139.130 0.0.0.0         UG        0 0          0 eth0
```

Your connections should now be load balanced using round robin.

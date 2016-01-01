#########################################################################
# File Name: /root/github/tools/openstack.sh
# Author: huxining
# mail: yige2008123@126.com
# Created Time: 2015年04月23日 星期四 15时28分01秒
#########################################################################
#!/bin/bash

#update subnet
neutron subnet-update  300252b9-a653-4a93-85e3-4951d079803f   --host-routes  type=dict list=true  destination=10.10.10.0/24,nexthop=10.10.10.1
neutron subnet-update  300252b9-a653-4a93-85e3-4951d079803f   --allocation_pools type=dict list=true start=192.168.34.2,end=192.168.34.10 start=192.168.34.20,end=192.168.34.40
neutron subnet-update  300252b9-a653-4a93-85e3-4951d079803f   --dns-nameservers list=true 8.8.8.8 8.8.4.4

#create subnet
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.122.10,end=192.168.122.20 --gateway=192.168.122.1 public 192.168.122.0/24

#add router rule
neutron router-update b37ddf7e-49a8-44b3-ab0b-d1b8540cde3a --routes type=dict list=true destination=40.0.1.0/24,nexthop=10.0.0.3 

#clear static router
neutron router-update b37ddf7e-49a8-44b3-ab0b-d1b8540cde3a  --routes action=clear -v


#tc
tc class replace dev qg-cf73871f-8a parent 1: classid 1:10 htb rate 200000Kbit  ceil 200000Kbit burst 5000k cburst 5000k prio 1

tc qdisc replace dev qg-cf73871f-8a parent 1:10 handle 10: sfq

tc filter replace dev qg-cf73871f-8a  parent 1: protocol ip prio 1 u32 match ip dst 172.31.254.1/24 flowid 1:10

#ingress
tc qdisc add dev ifbcf73871f-8a handle ffff: ingress
tc filter add dev ifbcf73871f-8a  parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifbcf73871f-8a 
tc filter replace dev ifbcf73871f-8a  parent 1: protocol ip prio 1 u32 match ip src 172.31.254.1/24 flowid 1:10

#tc delete 
tc filter delete dev qg-cf73871f-8a  parent 1: protocol ip prio 1
tc filter delete dev ifbcf73871f-8a  parent 1: protocol ip prio 1

tc class delete dev qg-cf73871f-8a parent 1: classid 1:10  


#hashlimit
-A neutron-openvswi-d19ec3170-b -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name 19ec31707b3fa5e -j DROP 
-A neutron-openvswi-d19ec3170-b -p udp -m udp --dport 53 -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name 19ec31700846cb0 -j DROP 
-A neutron-openvswi-d507d54df-9 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name 507d54df7b3fa5e -j DROP 
-A neutron-openvswi-d507d54df-9 -p udp -m udp --dport 53 -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name 507d54df0846cb0 -j DROP 
-A neutron-openvswi-d5be8430f-7 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name 5be8430f7b3fa5e -j DROP 
-A neutron-openvswi-d5be8430f-7 -p udp -m udp --dport 53 -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name 5be8430f0846cb0 -j DROP 
-A neutron-openvswi-dce91cdfb-5 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name ce91cdfb7b3fa5e -j DROP 
-A neutron-openvswi-dce91cdfb-5 -p udp -m udp --dport 53 -m hashlimit --hashlimit-above 5000/sec --hashlimit-burst 10000 --hashlimit-mode srcip --hashlimit-name ce91cdfb0846cb0 -j DROP 


#shell
for cluster in hlgw mm shzh xd hyjt qn sp zhj lg sh zhsh ghxw shjhl; do echo $cluster":"; clush -g $cluster"_api" 'rpm -qa| grep python-neutronclient';done

#port update
neutron port-update bdc1e837-3dd4-4c38-8a4d-4ad15cd3b1a2  --binding:profile type=dict  uos_pps_limits="['tcp:syn::500']"

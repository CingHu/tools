#########################################################################
# File Name: /root/github/learn/maintance.sh
# Author: huxining
# mail: yige2008123@126.com
# Created Time: 2015年05月30日 星期六 20时28分01秒
#########################################################################
#!/bin/bash 

1. puppet

puppet agent -vt

2. traceroute

traceroute -n 1.2.4.8

3. ipmitool
ipmitool lan print
ipmitool user
ipmitool user list
ipmitool user list 1
ipmitool user set password 2 PQ79ISF7ha7G

4.tcpdump
tcpdump -lnvvvei qg-0621205e-01  icmp

5. ovs

(1) ovs-appctl
ovs-appctl upcall/show
ovs-appctl vlog/list 
ovs-appctl dpif/dump-flows br-tun
ovs-appctl dpif/show


(2) ovs-vsctl 
ovs-vsctl list sflow

6. ifstat 

ifstat -d 1


7.conntrack:
conntrack -L
cat nf_conntrack|wc -l 
cat /proc/net/ip_conntrack|grep 10.251.0.119

cat /proc/net/ip_conntrack | cut -d ' ' -f 10 |cut -d '=' -f2 |sort |uniq -c |sort -nr |head -n 5
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_max 
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_buckets 
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_syn_sent
exit
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_syn_sent
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_max 
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_icmp_timeout 
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_max_retrans 
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established 
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout_stream 

8. sar

sar -n TCP 1
sar -n IP
sar -n DEV 1 | grep eth 


tcpdump -lnvvvei eth3 -c 10000 > result_eth3
cat result_eth3 |python stats_packet.py

9. mpstat 

mpstat -P ALL 1 10000
iftop 
iostat
vmstat

10 ethtool 
ethtool -k eth3 
ethtool -i eth3
ethtool -S eth3

11 tcpdump -ni eth0 -c 1000 > tmp.txt && cat tmp.txt | awk '{print $3}' | grep -vE '^ *$'|awk -F'.' '{print $1"."$2"."$3"."$4}'| sort | uniq -c | sort -n

12 rabbitmqctl list_connections channels name | sort -k1,1nr

13 rabbitmqadmin -uopenstack -pabK1LaP1ald11 get queue=servicevm_agent requeue=true queue=servicevm_agent 

14 查看syn连接
   netstat -an | grep SYN | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | more
   netstat -n|grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n20 

15 查看TIME_WAIT连接
   tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F"." '{print $1″."$2″."$3″."$4}' | sort | uniq -c | sort -nr |head -20

16 用tcpdump嗅探80端口的访问看看谁最高
   netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20
   netstat -ant |awk '/:80/{split($5,ip,":");++A[ip[1]]}END{for(i in A) print A,i}' |sort -rn|head -n20 

17 查看80端口连接数最多的20个IP
   netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn  
   netstat -n | awk '/^tcp/ {++S[$NF]};END {for(a in S) print a, S[a]}'  
   netstat -n | awk '/^tcp/ {++state[$NF]}; END {for(key in state) print key,"\t",state[key]}'  
   netstat -n | awk '/^tcp/ {++arr[$NF]};END {for(k in arr) print k,"\t",arr[k]}'  
   netstat -n |awk '/^tcp/ {print $NF}'|sort|uniq -c|sort -rn  
   netstat -ant | awk '{print $NF}' | grep -v '[a-z]' | sort | uniq -c

18 查看TCP连接状态 
   netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr

19 logrotate
   日志文件分割工具

20 nping
   可以发出任何类型的ping包

21 history
export HISTTIMEFORMAT='%Y.%m.%d-%T :: ' HISTFILESIZE=50000 HISTSIZE=50000 

21 查看启动时间
date -d @$(echo $(($(date +%s)-$(cat /proc/uptime|cut -d. -f1))))

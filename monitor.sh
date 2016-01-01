#########################################################################
# File Name: monitor.sh
# Author: huxining
# mail: yige2008123@126.com
# Created Time: 2015年05月21日 星期四 17时53分56秒
#########################################################################
#!/bin/bash 

1. 包数监控
sar -n DEV 1 | grep eth3
sar -n DEV 1 | grep ethA

2. 发送大量的数据包工具
hping3

3. ip连通性检测，类似tracerouter
mtr

4.dig监控
timeout 2 dig @101.71.89.162 >/dev/null 2>&1 ;echo $? 

5. 监控进程占用的带宽
nethogs

6. 监控网络流量
ntop

7.  性能监控方法
uptime
dmesg | tail
vmstat 1
mpstat -P ALL 1
pidstat 1
iostat -xz 1
free -m
sar -n DEV 1
sar -n TCP,ETCP 1
top

8。 监控工具
zabbix
nagios
openTSDB
open-Falcon
Cloud Insight



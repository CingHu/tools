
1. 在compute node,发现回来的dhcp的报文在table 4中丢弃了，原因不明，解决办法

   ovs-ofctl del-flows br-tun  "table=4"
   ovs-ofctl add-flow  br-tun "table=4,priority=1 tun_id=0xa actions=mod_vlan_vid:2,resubmit(,10)"

2.在 network node发现vm 发送过来的dhcp报文,在table 2中丢弃了，　原因不明，　解决办法

  ovs-ofctl del-flows  br-tun --strict  "table=2,priority=0"

3.在compute node查看是否有流将报文封装为tunnel, 解决办法
 在openvswitch的配置文件中加入
[ustack ]
ovs_reset = True
加入这个参数后,flow在重启agent之后便不会重复下

4.访问外网不通
  1.修改ifcfg-eth0的配置文件,重启网络
  2.确认host可以ping通,因为uos的VM有antisnoop功能,所以需要修改br-ex的mac为eth0的mac,eth0的mac另取
  3.在router的namespace里ping外网网关不通,查看路由表,tcpdump -i eth1 -vvnxxsSe icmp
  4.添加address-pair

    (1)获取token
curl -i -s -X POST https://identity.api.ustack.com/v3/auth/tokens -H "Content-Type:application/json" -d '{
  "auth": {
      "identity": {
          "methods": [
             "password"
          ],
          "password": {
            "user": {
              "id": "9d0772ba255b48c1999a77152e973845",
              "password": "yanjiao3886891"
            }
          }
      },
      "scope": {
          "project": {
              "id": "72aa8b21431c4f44a7854ba24c367ff6"
          }
      }
  }
}'

PORT=6ef52696-5f86-4d81-8c6d-e4969b679fde
TOKEN=9cebb03c1e4b433ca72d1ea472160b22

下边的mac为qg的mac

    curl -s -X PUT https://bj1.network.api.ustack.com/v2.0/ports/$PORT -H "X-Auth-Token: "$TOKEN  -H "Content-Type: application/json" -H "Accept: application/json" -d '{
    "port": {
        "allowed_address_pairs": [
            {
                "mac_address": "fa:16:3e:3d:92:60",
                "ip_address": "10.250.4.205"
            }
        ]
    }
}'

    curl -s -X PUT https://bj1.network.api.ustack.com/v2.0/ports/$PORT -H "X-Auth-Token: "$TOKEN  -H "Content-Type: application/json" -H "Accept: application/json" -d '{
    "port": {
        "allowed_address_pairs": [
            {
                "mac_address": "fa:16:3e:3d:92:60",
                "ip_address": "10.250.4.203/22"
            }
        ]
    }
}'

curl -s -X PUT https://bj1.network.api.ustack.com/v2.0/ports/$PORT -H "X-Auth-Token: "$TOKEN  -H "Content-Type: application/json" -H "Accept: application/json" -d '{
    "port": {
        "allowed_address_pairs": [
            {
                "mac_address": "86:5a:01:ae:80:43",
                "ip_address": "10.250.5.1"
            }
        ]
    }
}'

5.l3 agent执行失败,是因为filers文件没有更新, 同时UOS弃用l3-agent使用vpn-agnet替代

6. 4789为vxlan封装的udp端口号,通过在tcpdump -i eth0 port 4789可以查看是否有vxlan报文
[root@control-network ~]# ovs-dpctl show
system@ovs-system:
        lookups: hit:1609927 missed:381165 lost:0
        flows: 5
        masks: hit:3563728 total:2 hit/pkt:1.79
        port 0: ovs-system (internal)
        port 1: br-ex (internal)
        port 2: br-int (internal)
        port 3: br-tun (internal)
        port 4: vxlan_sys_4789 (vxlan: df_default=false, ttl=0)
        port 5: eth0
        port 6: qr-55a0177f-02 (internal)
        port 7: tap6074f63e-f5 (internal)
        port 8: qg-3a6f6342-78 (internal)

#test
#==========================================================================================
curl -i -s -X POST https://10.0.0.39:35357/v3/auth/tokens -H "Content-Type:application/json" -d '{
"auth": {
        "identity": {
            "methods": [
                "password"
            ],
            "password": {
                "user": {
                    "id": "510c80377eb447a7834c0d3cc4addaf2",
                    "password": "123456"
                }
            }
        },
        "scope": {
            "project": {
                "id": "17ced357a26a44c0b4e475a819d772be"
            }
        }
    }
}'


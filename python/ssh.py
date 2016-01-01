#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pexpect
import sys

def ssh_cmd(ip, user, passwd, cmd):
    ret = -1
    ssh = pexpect.spawn('ssh %s@%s' % (user, ip))
    try:
        i = ssh.expect(['password:', 'continue connecting (yes/no)?'], timeout=5)
        if i == 0 :
            ssh.sendline(passwd)
        elif i == 1:
            ssh.sendline('yes\n')
            ssh.expect('password: ')
            ssh.sendline(passwd)
        ssh.expect('SG-6000# ')
        ssh.sendline(cmd)
        ssh.expect('SG-6000# ')
        print ssh.before
        #r = ssh.read()
        #print r
        ret = 0
    except pexpect.EOF:
        print "EOF"
        ssh.close()
        ret = -1
    except pexpect.TIMEOUT:
        print "TIMEOUT"
        ssh.close()
        ret = -2
    return ret 

def test():
    cmd = 'show interface'#你要执行的命令列表
    username = "hillstone"  #用户名
    passwd = "hillstone"    #密码
    ip="10.0.0.144"
    ssh_cmd(ip, username, passwd, cmd)

def help():
    print("CMD:")
    print("    hillstonessh ip username passwd cmd\n")
    print("Excample:")
    print("    hillstonessh 10.0.0.144 hillstone hillstone \"show interface\"\n")
    sys.exit(1)

if __name__=='__main__':
    if len(sys.argv) < 5:
        print("\nERROR: inpute param error!\n")
        help()

    ip = sys.argv[1]
    username = sys.argv[2]
    passwd = sys.argv[3]
    cmd = sys.argv[4]

    ssh_cmd(ip, username, passwd, cmd) 

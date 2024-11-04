#!/bin/bash 

route add default gw 10.5.1.1 
route del default gw 10.5.1.254 

# Start SSH service
service ssh start

# Start Apache service
apachectl -D FOREGROUND

/usr/sbin/sshd -D
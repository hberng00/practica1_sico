#!/bin/bash 


# Start SSH service
service ssh start

# Start Apache service
apachectl -D FOREGROUND

# This is done to ensure that SSH traffic is routed through the router
route add default gw 10.5.0.1
route del default gw 10.5.0.254 

/usr/sbin/sshd -D
#!/bin/bash 

route add default gw 10.5.1.1 
route del default gw 10.5.1.254 

rsyslogd

# Start the services
service ssh start
service apache2 start
fail2ban-server


# Print a message to indicate services are running
echo "SSH and Apache services are running."

# Keep the container running
# Using tail to prevent the container from exiting
tail -f /dev/null
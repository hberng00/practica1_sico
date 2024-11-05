#!/bin/bash 

route add default gw 10.5.2.1
route del default gw 10.5.2.254

# Start the SSH service
service ssh start

# Print a message to indicate services are running
echo "SSH  services are running."

# Keep the container running
# Using tail to prevent the container from exiting
tail -f /dev/null
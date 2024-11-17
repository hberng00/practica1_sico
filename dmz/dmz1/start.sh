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

mkdir -p /home/cowrieuser/cowrie/var/log/cowrie /home/cowrieuser/cowrie/var/run
chown -R cowrieuser /home/cowrieuser/cowrie
chmod -R 755 /home/cowrieuser/cowrie

# Start Cowrie
su - cowrieuser -c "bash -c '. /home/cowrieuser/cowrie/venv/bin/activate && /home/cowrieuser/cowrie/bin/cowrie start'"

# Keep the container running
# Using tail to prevent the container from exiting
tail -f /dev/null
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y nmap hping3 openssh-server tcpdump net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config apache2   

RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose SSH and HTTP ports
EXPOSE 22 80

# Copy the start script
COPY ./start.sh .

# Copy the HTML file to the Apache directory
COPY ./index.html /var/www/html/index.html

# Make the start script executable
RUN chmod +x start.sh

# Start the services
CMD ["./start.sh"]

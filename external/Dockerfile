# Use the latest Ubuntu version as the base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nmap \
    hping3 \
    openssh-server \
    tcpdump \
    net-tools \
    iputils-ping \
    traceroute \
    vim \
    nano \
    iproute2 \
    iptables \
    pkg-config \
    apache2 && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Set root password
RUN echo 'root:root' | chpasswd

# Configure SSH settings
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose ports for SSH and HTTP
EXPOSE 22 80

# Copy the start script to the container
COPY ./start.sh /start.sh

# Copy the HTML file to the Apache directory
COPY ./index.html /var/www/html/index.html

# Make the start script executable
RUN chmod +x /start.sh

# Set the default command to execute the start script
CMD ["/start.sh"]

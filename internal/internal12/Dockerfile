# Use the latest Ubuntu version as the base image
FROM ubuntu:latest

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nmap \
    openssh-server \
    tcpdump \
    net-tools \
    iputils-ping \
    traceroute \
    vim \
    nano \
    iproute2 \
    iptables \
    pkg-config && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create the SSH daemon run directory
RUN mkdir -p /var/run/sshd

# Set root password and configure SSH to allow root login
RUN echo 'root:root' | chpasswd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Copy the start script into the container
COPY ./start.sh /start.sh

# Make the start script executable
RUN chmod +x /start.sh

# Set the command to run the start script
CMD ["/start.sh"]

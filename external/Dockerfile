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
    openssl && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Set root password
RUN echo 'root:root' | chpasswd

# Create SSL certificates
RUN mkdir -p /etc/ssl/private && \
    mkdir -p /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt

# Enable Apache SSL module
RUN a2enmod ssl

# Configure SSH settings
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose ports for SSH and HTTP
EXPOSE 22 80 443

COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl.conf

# Copy the start script to the container
COPY ./start.sh /start.sh

# Copy the HTML file to the Apache directory
COPY ./index.html /var/www/html/index.html

# Make the start script executable
RUN chmod +x /start.sh

# Set the default command to execute the start script
CMD ["/start.sh"]

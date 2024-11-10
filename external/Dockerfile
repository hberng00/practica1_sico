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
    apache2 \
    openssl

# Create directory for SSH daemon
RUN mkdir /var/run/sshd

# Set root password
RUN echo 'root:root' | chpasswd

# Create SSL certificates with default subject to avoid prompts
RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/apache-selfsigned.key \
    -out /etc/ssl/certs/apache-selfsigned.crt \
    -subj "/C=US/ST=State/L=Location/O=Organization/OU=Unit/CN=10.5.0.20"


# Enable Apache SSL module
RUN a2enmod ssl

# Configure SSH settings
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copy Apache SSL site configuration and enable it
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl.conf

# Expose ports for SSH, Apache, and HTTPS
EXPOSE 80 2222 443

# Copy the start script to the container
COPY ./start.sh /start.sh

# Copy the HTML file to the Apache directory
COPY ./index.html /var/www/html/index.html

# Make the start script executable
RUN chmod +x /start.sh

# Set the default command to execute the start script
CMD ["/start.sh"]

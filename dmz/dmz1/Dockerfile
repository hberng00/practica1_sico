FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nmap \
    openssh-server \
    fail2ban \
    tcpdump \
    net-tools \
    iputils-ping \
    traceroute \
    vim \
    nano \
    iproute2 \
    iptables \
    pkg-config \
    rsyslog \
    apache2 \
    libpam-google-authenticator \
    openssl && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    useradd -ms /bin/bash sshuser && echo "sshuser:1234" | chpasswd


# Create SSL certificates
RUN mkdir -p /etc/ssl/private && \
    mkdir -p /etc/ssl/certs
    

# Enable Apache SSL module
RUN a2enmod ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt

# Create SSH banner
RUN echo "************************************" > /etc/ssh/banner.txt && \
    echo "* Bienvenido al sistema de DMZ     *" >> /etc/ssh/banner.txt && \
    echo "* Alumno: Hugo Bernardo Garmilla   *" >> /etc/ssh/banner.txt && \
    echo "************************************" >> /etc/ssh/banner.txt

USER root

# Modify SSH configuration
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config && \
    sed -i 's/#MaxAuthTries 6/MaxAuthTries 2/' /etc/ssh/sshd_config && \
    sed -i 's/#ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#UsePAM no/UsePAM yes/' /etc/ssh/sshd_config && \
    echo 'Banner /etc/ssh/banner.txt' >> /etc/ssh/sshd_config && \
    echo 'AuthenticationMethods publickey keyboard-interactive' >> /etc/ssh/sshd_config

# Configure PAM for 2FA with Google Authenticator
RUN echo 'auth required pam_unix.so nullok_secure' >> /etc/pam.d/sshd && \
    echo 'auth required pam_google_authenticator.so nullok' >> /etc/pam.d/sshd

# Copy Fail2Ban configuration
COPY ./jail.local /etc/fail2ban/jail.local
 
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl.conf

# Expose ports for SSH, Apache, and HTTPS
EXPOSE 80 2222 443

# Copy HTML file for Apache
COPY ./index.html /var/www/html/index.html

# Copy and set permissions for start script
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

# Command to run when the container starts
CMD ["/start.sh"]

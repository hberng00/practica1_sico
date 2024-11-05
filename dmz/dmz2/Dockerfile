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
    apache2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Set up SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    useradd -m -s /bin/bash sshuser && echo "sshuser:sshpassword" | chpasswd

RUN cp ./etc/fail2ban/jail.conf ./etc/fail2ban/jail.local

# Create a banner
RUN echo "************************************" > /etc/ssh/banner.txt && \
    echo "* Bienvenido al sistema de DMZ     *" >> /etc/ssh/banner.txt && \
    echo "* Alumno: Hugo Bernardo Garmilla   *" >> /etc/ssh/banner.txt && \
    echo "************************************" >> /etc/ssh/banner.txt

# Modify SSH configuration
RUN sed -ri 's/^#?Port\s+.*/Port 2222/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitEmptyPasswords\s+.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?MaxAuthTries\s+.*/MaxAuthTries 2/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?Banner\s+.*/Banner \/etc\/ssh\/banner.txt/' /etc/ssh/sshd_config
    
# Configure Fail2Ban
RUN echo "[sshd]" > /etc/fail2ban/jail.local && \
    echo "enabled = true" >> /etc/fail2ban/jail.local && \
    echo "port = ssh" >> /etc/fail2ban/jail.local && \
    echo "filter = sshd" >> /etc/fail2ban/jail.local && \
    echo "logpath = /var/log/auth.log" >> /etc/fail2ban/jail.local && \
    echo "maxretry = 3" >> /etc/fail2ban/jail.local && \
    echo "findtime = 300" >> /etc/fail2ban/jail.local && \
    echo "bantime = 3600" >> /etc/fail2ban/jail.local  # Block IP for 1 hour


# Expose ports for SSH and Apache
EXPOSE 80 2222
    

# Copy the HTML file to the Apache directory
COPY ./index.html /var/www/html/index.html

# Copy and set permissions for the start script
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

# Set the working directory for the application
WORKDIR /home/sshuser/app

# Command to run when starting the container
CMD ["/start.sh"]

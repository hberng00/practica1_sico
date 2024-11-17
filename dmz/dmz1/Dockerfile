FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    net-tools \
    iputils-ping \
    traceroute \
    iproute2 \
    nmap \
    iptables \
    pkg-config \
    apache2 \
    curl \
    nano \
    fail2ban \
    libpam-google-authenticator \
    openssl \
    rsyslog \
    git \
    python3-venv \
    libssl-dev \
    libffi-dev \
    build-essential \
    libpython3-dev \
    python3-minimal \
    authbind

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    useradd -ms /bin/bash sshuser && echo "sshuser:1234" | chpasswd

RUN useradd -m cowrieuser

USER cowrieuser

WORKDIR /home/cowrieuser
RUN git clone https://github.com/cowrie/cowrie.git

WORKDIR /home/cowrieuser/cowrie

RUN python3 -m venv venv && \
   venv/bin/pip install -r requirements.txt


RUN cp /home/cowrieuser/cowrie/etc/cowrie.cfg.dist /home/cowrieuser/cowrie/etc/cowrie.cfg
RUN sed -i 's/hostname = svr04/hostname = Hugo/' /home/cowrieuser/cowrie/etc/cowrie.cfg
RUN cp /home/cowrieuser/cowrie/etc/userdb.example /home/cowrieuser/cowrie/etc/userdb.txt
RUN echo 'ataque:x:ataque' >> /home/cowrieuser/cowrie/etc/userdb.txt

USER root
# Create SSL certificates with default subject to avoid prompts
RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/apache-selfsigned.key \
    -out /etc/ssl/certs/apache-selfsigned.crt \
    -subj "/C=US/ST=State/L=Location/O=Organization/OU=Unit/CN=10.5.1.20"

# Enable Apache SSL module
RUN a2enmod ssl

# Create SSH banner
RUN echo "************************************" > /etc/ssh/banner.txt && \
    echo "* Bienvenido al sistema de DMZ     *" >> /etc/ssh/banner.txt && \
    echo "* Alumno: Hugo Bernardo Garmilla   *" >> /etc/ssh/banner.txt && \
    echo "************************************" >> /etc/ssh/banner.txt


USER root

# Modify SSH configuration
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config && \
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
 
# Copy Apache SSL site configuration and enable it
COPY ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl.conf

# Expose ports for SSH, Apache, and HTTPS
EXPOSE 80 22 443 

# Copy HTML file for Apache
COPY ./index.html /var/www/html/index.html

# Copy files
COPY ./start.sh /start.sh

# Set execute permission for start.sh
RUN chmod +x /start.sh

# Command to run when the container starts
CMD ["/start.sh"]

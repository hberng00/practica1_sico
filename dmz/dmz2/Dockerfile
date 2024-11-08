FROM ubuntu:latest

# Instalar paquetes necesarios
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
    apache2  \
    libpam-google-authenticator && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Configuración de SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    useradd -ms /bin/bash sshuser && echo "sshuser:1234" | chpasswd

# Crear un banner para SSH
RUN echo "************************************" > /etc/ssh/banner.txt && \
    echo "* Bienvenido al sistema de DMZ     *" >> /etc/ssh/banner.txt && \
    echo "* Alumno: Hugo Bernardo Garmilla   *" >> /etc/ssh/banner.txt && \
    echo "************************************" >> /etc/ssh/banner.txt

USER root

# Modificar configuración de SSH
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config && \
    sed -i 's/#MaxAuthTries 6/MaxAuthTries 2/' /etc/ssh/sshd_config && \
    sed -i 's/#ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#UsePAM no/UsePAM yes/' /etc/ssh/sshd_config && \
    echo 'Banner /etc/ssh/banner.txt' >> /etc/ssh/sshd_config && \
    echo 'AuthenticationMethods publickey keyboard-interactive' >> etc/ssh/sshd_config

# Configuración de PAM para 2FA con Google Authenticator
RUN echo 'auth required pam_unix.so nullok_secure' >> /etc/pam.d/sshd && \
    echo 'auth required pam_google_authenticator.so nullok' >> /etc/pam.d/sshd

# Copy host Fail2Ban configuration.
COPY ./jail.local /etc/fail2ban/jail.local


# Exponer puertos para SSH y Apache
EXPOSE 80 2222

# Copiar archivo HTML para Apache
COPY ./index.html /var/www/html/index.html

# Copiar y dar permisos al script de inicio
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

# Comando de inicio del contenedor
CMD ["/start.sh"]

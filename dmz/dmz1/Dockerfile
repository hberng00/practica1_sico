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
    apache2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configuración de SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    useradd -m -s /bin/bash sshuser && echo "sshuser:sshpassword" | chpasswd

# Crear un banner para SSH
RUN echo "************************************" > /etc/ssh/banner.txt && \
    echo "* Bienvenido al sistema de DMZ     *" >> /etc/ssh/banner.txt && \
    echo "* Alumno: Hugo Bernardo Garmilla   *" >> /etc/ssh/banner.txt && \
    echo "************************************" >> /etc/ssh/banner.txt

# Modificar configuración de SSH
RUN sed -ri 's/^#?Port\s+.*/Port 2222/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitEmptyPasswords\s+.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?MaxAuthTries\s+.*/MaxAuthTries 2/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?Banner\s+.*/Banner \/etc\/ssh\/banner.txt/' /etc/ssh/sshd_config

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

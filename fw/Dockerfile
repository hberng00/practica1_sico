FROM ubuntu:24.04

RUN apt-get update && apt-get install -y nmap openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config

RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Habilitar IP forwarding
RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

COPY ./start.sh .

RUN chmod +x start.sh


CMD ["/bin/bash", "./start.sh"]

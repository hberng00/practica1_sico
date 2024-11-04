FROM ubuntu:24.04

RUN apt-get update && apt-get install -y nmap openssh-server tcpdump net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config apache2

RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22 80

# Copy the HTML file to the Apache directory
COPY ./index.html /var/www/html/index.html

COPY ./start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]


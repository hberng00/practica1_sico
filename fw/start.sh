#!/bin/bash
sysctl -w net.ipv4.ip_forward=1

# Aplicar los cambios de sysctl
sysctl -p

# Configurar políticas por defecto de iptables
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT



# Permitir tráfico relacionado y establecido
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Permitir tráfico loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir tráfico ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT


# Iniciar el servicio SSH
/usr/sbin/sshd -D
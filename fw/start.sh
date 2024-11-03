#!/bin/bash
sysctl -w net.ipv4.ip_forward=1

# Aplicar los cambios de sysctl
sysctl -p

# Configurar políticas por defecto de iptables
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfico relacionado y establecido
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# Permitir tráfico loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir tráfico ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Permitir tráfico TCP desde 10.5.2.0/24 hacia 10.5.0.0/24
iptables -A FORWARD -s 10.5.2.0/24 -d 10.5.0.0/24 -p tcp -j ACCEPT
iptables -A FORWARD -s 10.5.2.0/24 -d 10.5.0.0/24 -p udp -j ACCEPT
iptables -A FORWARD -s 10.5.2.0/24 -d 10.5.0.0/24 -p icmp -j ACCEPT


# Iniciar el servicio SSH
/usr/sbin/sshd -D
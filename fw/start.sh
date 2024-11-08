#!/bin/bash
sysctl -w net.ipv4.ip_forward=1

# Aplicar los cambios de sysctl
sysctl -p

# Configurar políticas por defecto de iptables
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfico relacionado y establecido
#iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir tráfico loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir tráfico ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/minute --limit-burst 10 -j ACCEPT

# Permitir nuevas conexiones de la red interna hacia la red externa.
iptables -A FORWARD -p tcp -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT
iptables -A FORWARD -p udp -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT
iptables -A FORWARD -p icmp -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT

#Permitir conexiones  tcp a las dmzs
iptables -A FORWARD -p tcp -s 10.5.0.0/16 -d 10.5.1.0/24 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.5.0.0/16 -d 10.5.1.0/24 --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.5.2.20 -d 10.5.1.0/24 --dport 2222 -j ACCEPT

# Cambiar la IP de origen para los paquetes.
iptables -t nat -A POSTROUTING -s 10.5.2.0/24 -d 10.5.0.0/24 -j SNAT --to 10.5.0.1

# Keep the container running
# Using tail to prevent the container from exiting
tail -f /dev/null
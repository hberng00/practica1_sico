#!/bin/bash

# Configura las rutas según las necesidades de la VPN
route add default gw 10.5.2.1
route del default gw 10.5.2.254 


# Inicia el servicio SSH
service ssh start


# Mensaje de confirmación
echo "Servicios SSH y WireGuard están corriendo."

# Mantiene el contenedor en ejecución
tail -f /dev/null

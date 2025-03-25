#!/bin/bash

set -e  # Habilita el modo de salida en caso de error

CONFIG_DIR="/etc/systemd/system/docker.service.d"
CONFIG_FILE="$CONFIG_DIR/override.conf"

# Crear el directorio de configuración si no existe
sudo mkdir -p "$CONFIG_DIR"

# Escribir la configuración para habilitar HTTP en Docker
echo "[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375 --tls=false
" | sudo tee "$CONFIG_FILE" > /dev/null

# Recargar y reiniciar Docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# Verificar si el puerto 2375 está activo
if netstat -tulpn | grep -q ":2375"; then
    echo "✅ Docker HTTP API habilitado en el puerto 2375"
else
    echo "❌ Error: No se pudo habilitar Docker HTTP API"
    exit 1
fi

#!/bin/bash

set -e

echo "🔧 Configurando Docker para escuchar en HTTP (tcp://0.0.0.0:2375)..."

# Paso 1: Configurar daemon.json
DAEMON_JSON="/etc/docker/daemon.json"
echo "📄 Editando $DAEMON_JSON"
cat > $DAEMON_JSON <<EOF
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2375"]
}
EOF

# Paso 2: Crear override systemd
OVERRIDE_DIR="/etc/systemd/system/docker.service.d"
OVERRIDE_CONF="$OVERRIDE_DIR/override.conf"

echo "📁 Creando override en systemd"
mkdir -p "$OVERRIDE_DIR"

cat > "$OVERRIDE_CONF" <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

# Paso 3: Recargar y reiniciar Docker
echo "🔄 Recargando systemd y reiniciando Docker"
systemctl daemon-reexec
systemctl daemon-reload
systemctl restart docker

echo "✅ Docker ahora escucha en http://0.0.0.0:2375"
echo "⚠️ No uses esto en producción sin TLS"

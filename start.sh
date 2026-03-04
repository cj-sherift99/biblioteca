#!/bin/sh
set -e

echo "🔧 Iniciando Tailscale daemon..."
tailscaled --state=mem: --tun=userspace-networking --socks5-server=localhost:1055 &
TAILSCALED_PID=$!

sleep 4

echo "🔗 Conectando a red Tailscale..."
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="render-biblioteca" \
  --accept-routes

echo ""
echo "✅ Estado de Tailscale:"
tailscale status

echo ""
echo "🚀 Iniciando proxy → http://${LOCAL_TARGET}"
node proxy.js

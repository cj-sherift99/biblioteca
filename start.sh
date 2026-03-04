#!/bin/sh
set -e

echo "🔧 Iniciando Tailscale daemon..."
tailscaled --state=mem: --tun=userspace-networking &
sleep 4

echo "🔗 Conectando a red Tailscale..."
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="render-biblioteca" \
  --netfilter-mode=off \
  --accept-routes

echo ""
echo "✅ Estado de Tailscale:"
tailscale status

echo ""
echo "🚀 Iniciando proxy → ${LOCAL_TARGET}"
node proxy.js

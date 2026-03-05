#!/bin/sh
set -e

echo "🔧 Arrancando Tailscale daemon en modo userspace..."
tailscaled --state=mem: --tun=userspace-networking &

echo "🔗 Conectando a Tailscale..."
sleep 3   # tiempo mínimo para que arranque el daemon

tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="render-biblioteca" \
  --netfilter-mode=off \
  --accept-routes \
  --reset

echo "✅ Tailscale conectado:"
tailscale status

echo "🚀 Arrancando proxy Node.js..."
exec node proxy.js
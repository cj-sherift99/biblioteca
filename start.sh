#!/bin/sh

echo "🔧 Arrancando Tailscale daemon..."
tailscaled --state=mem: --tun=userspace-networking &

echo "🔗 Conectando Tailscale en background..."
(
  sleep 2
  tailscale up \
    --authkey="${TAILSCALE_AUTHKEY}" \
    --hostname="render-biblioteca" \
    --netfilter-mode=off \
    --accept-routes \
    --reset
  echo "✅ Tailscale conectado:"
  tailscale status || true
) &

echo "🚀 Arrancando proxy Node.js..."
exec node proxy.js
EOF
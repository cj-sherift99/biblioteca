#!/bin/sh

echo "🔧 Arrancando Tailscale daemon..."
tailscaled --state=mem: --tun=userspace-networking &

echo "🚀 Arrancando proxy Node.js..."
node proxy.js &
NODE_PID=$!

echo "⏳ Esperando que tailscaled esté listo..."
sleep 5

echo "🔗 Conectando a Tailscale..."
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="render-biblioteca" \
  --netfilter-mode=off \
  --accept-routes \
  --reset

echo "✅ Estado Tailscale:"
tailscale status || true

echo "👁 Monitoreando proceso Node..."
wait $NODE_PID

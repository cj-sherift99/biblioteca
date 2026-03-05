#!/bin/sh
echo "🔧 Arrancando Tailscale daemon..."
tailscaled --state=mem: --tun=userspace-networking &

echo "🔗 Conectando Tailscale..."
sleep 2
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="render-biblioteca" \
  --netfilter-mode=off \
  --accept-routes \
  --reset

# Espera hasta que Tailscale esté fully up y el target sea pingueable
echo "⏳ Esperando conexión estable..."
until tailscale ping 100.90.166.10 --timeout=2s >/dev/null 2>&1; do
  echo "🔄 Intentando ping al target... (espera 2s)"
  sleep 2
done

echo "✅ Tailscale conectado:"
tailscale status || true

echo "🚀 Arrancando proxy Node.js..."
exec node proxy.js
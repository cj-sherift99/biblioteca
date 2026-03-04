#!/bin/sh

echo "🔧 Iniciando Tailscale daemon..."
tailscaled --state=mem: --tun=userspace-networking &

echo "⏳ Esperando que tailscaled arranque..."
sleep 5

echo "🔗 Conectando a red Tailscale..."
tailscale up \
  --authkey="${TAILSCALE_AUTHKEY}" \
  --hostname="render-biblioteca" \
  --netfilter-mode=off \
  --accept-routes \
  --reset

RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "❌ tailscale up falló con código $RESULT"
fi

echo ""
echo "✅ Estado de Tailscale:"
tailscale status || echo "(no se pudo obtener estado)"

echo ""
echo "🚀 Iniciando proxy → ${LOCAL_TARGET}"
node proxy.js

# Biblioteca ISTLT — Proxy Render + Tailscale

Expone la biblioteca local (Ubuntu con Tailscale) a internet mediante Render.

## Arquitectura
```
Internet → Render (proxy) → Tailscale → Ubuntu local (puerto 3000)
```

## Variables de entorno en Render

| Variable           | Valor                        |
|--------------------|------------------------------|
| `TAILSCALE_AUTHKEY`| Tu auth key de Tailscale     |
| `LOCAL_TARGET`     | `http://100.90.166.10:3000`  |

## Deploy

1. Subir este repo a GitHub
2. En Render → New Web Service → conectar repo
3. Runtime: **Docker**
4. Agregar las variables de entorno
5. Deploy

## Notas
- Tu Ubuntu debe estar encendido y con Tailscale activo
- La Auth Key expira en 90 días (renovar en tailscale.com/admin)
- Render free tier se "duerme" tras 15 min de inactividad

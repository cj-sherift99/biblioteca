const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app  = express();
const PORT = process.env.PORT || 10000;

// IP Tailscale de tu Ubuntu + puerto de la biblioteca
const TARGET = process.env.LOCAL_TARGET || 'http://100.90.166.10:3000';

console.log(`📡 Proxy configurado → ${TARGET}`);

// Health check para Render
app.get('/health', (req, res) => {
  res.json({ status: 'ok', target: TARGET, time: new Date().toISOString() });
});

// Proxy de todo el tráfico al servidor local
app.use('/', createProxyMiddleware({
  target: TARGET,
  changeOrigin: true,
  ws: true,
  timeout: 30000,
  proxyTimeout: 30000,
  on: {
    error: (err, req, res) => {
      console.error(`[proxy error] ${err.message}`);
      if (!res.headersSent) {
        res.status(502).send(`
          <!DOCTYPE html>
          <html>
          <head>
            <title>Biblioteca ISTLT — No disponible</title>
            <style>
              body { font-family: sans-serif; background: #0e1235; color: #fff;
                     display: flex; align-items: center; justify-content: center;
                     min-height: 100vh; margin: 0; text-align: center; }
              .box { padding: 40px; }
              h1 { color: #fecc09; font-size: 2rem; margin-bottom: 12px; }
              p  { color: #bab9ba; }
            </style>
          </head>
          <body>
            <div class="box">
              <h1>📚 Biblioteca ISTLT</h1>
              <p>El servidor local no está disponible en este momento.</p>
              <p style="margin-top:8px;font-size:0.85rem;opacity:0.6">Intenta de nuevo en unos minutos.</p>
            </div>
          </body>
          </html>
        `);
      }
    },
    proxyReq: (proxyReq, req) => {
      console.log(`→ ${req.method} ${req.url}`);
    }
  }
}));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🌐 Proxy escuchando en puerto ${PORT}`);
  console.log(`📚 Biblioteca → ${TARGET}\n`);
});

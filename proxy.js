const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app  = express();
const PORT = process.env.PORT || 10000;
const TARGET = process.env.LOCAL_TARGET || 'http://100.90.166.10:3000';

console.log(`📡 Proxy configurado → ${TARGET}`);

app.get('/health', (req, res) => {
  res.json({ status: 'ok', target: TARGET, time: new Date().toISOString() });
});

// Aquí insertas el nuevo endpoint de testeo
app.get('/test-target', async (req, res) => {
  try {
    const response = await fetch(TARGET);
    res.send(`OK: ${await response.text()}`);
  } catch (err) {
    res.status(500).send(`Error: ${err.message}`);
  }
});

app.use('/', createProxyMiddleware({
  target: TARGET,
  changeOrigin: true,
  ws: true,
  timeout: 60000,
  proxyTimeout: 60000,
  on: {
    error: (err, req, res) => {
      console.error(`[proxy error] ${err.message}`);
      // Página amigable de espera con auto-recarga
      if (!res.headersSent) {
        res.status(503).send(`
          <!DOCTYPE html>
          <html>
          <head>
            <title>Biblioteca ISTLT — Conectando...</title>
            <meta http-equiv="refresh" content="5">
            <style>
              body { font-family: sans-serif; background: #0e1235; color: #fff;
                     display: flex; align-items: center; justify-content: center;
                     min-height: 100vh; margin: 0; text-align: center; }
              .box { padding: 40px; }
              h1 { color: #fecc09; font-size: 2rem; margin-bottom: 12px; }
              p  { color: #bab9ba; }
              .spinner { margin: 20px auto; width: 40px; height: 40px;
                         border: 4px solid rgba(255,255,255,0.1);
                         border-top-color: #fecc09;
                         border-radius: 50%; animation: spin 1s linear infinite; }
              @keyframes spin { to { transform: rotate(360deg); } }
            </style>
          </head>
          <body>
            <div class="box">
              <h1>📚 Biblioteca ISTLT</h1>
              <div class="spinner"></div>
              <p>Conectando al servidor... La página se recargará automáticamente.</p>
            </div>
          </body>
          </html>
        `);
      }
    }
  }
}));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n🌐 Proxy escuchando en puerto ${PORT}`);
  console.log(`📚 Biblioteca → ${TARGET}\n`);
});
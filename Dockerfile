FROM debian:bookworm-slim

# Instalar Node.js 20 + herramientas necesarias
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    iptables \
    iproute2 \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Instalar Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

RUN chmod +x start.sh

EXPOSE 8080

CMD ["./start.sh"]

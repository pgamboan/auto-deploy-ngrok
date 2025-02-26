#!/bin/bash

echo "Apagando servicios..."
sudo systemctl stop nginx
pkill ngrok

REPO_DIR="/home/devopspablo/ngrok-test"
REPO_URL="https://github.com/PixelRocket-Shop/personal-portfolio-html-tailwind.git"

if [ ! -d "$REPO_DIR" ]; then
    echo "Clonando el repositorio..."
    git clone $REPO_URL $REPO_DIR
else
    echo "Actualizando el repositorio..."
    cd $REPO_DIR
    git pull origin main
fi

cd $REPO_DIR

echo "Instalando dependencias..."
npm install

echo "Ejecutando el servidor de desarrollo..."
npm run dev &  # Servidor de desarrollo en segundo plano

echo "Encendiendo Nginx..."
sudo systemctl start nginx

echo "Iniciando NGROK..."
nohup ngrok http 80 > /dev/null 2>&1 &

echo "Esperando para que NGROK genere la URL..."
sleep 10

URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

echo "Accede a la página en: $URL"

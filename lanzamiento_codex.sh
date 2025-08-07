#!/bin/bash
set -e

echo "🚀 Iniciando NOVAIA GRID ULTRA en entorno Codex..."

# Verifica estructura esperada
if [ ! -d "./bot" ] || [ ! -d "./web" ]; then
  echo "❌ Error: faltan las carpetas 'bot' o 'web'."
  exit 1
fi

# BACKEND (Flask)
echo "📦 Preparando entorno para el BOT (backend)..."
cd bot
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt || { echo "❌ Fallo al instalar requirements.txt"; exit 1; }
playwright install --with-deps || true

# Lanza el backend
echo "🧠 Ejecutando API del BOT..."
nohup uvicorn main:app --host 0.0.0.0 --port 3001 --reload > ../log_backend.txt 2>&1 &

# FRONTEND (React/Next.js)
echo "🌐 Preparando interfaz WEB..."
cd ../web
if command -v pnpm &> /dev/null; then
  pnpm install || pnpm install --force
  pnpm run dev &
else
  npm install --force
  npm run dev &
fi

echo "✅ Sistema NOVAIA GRID ULTRA en ejecución."
echo "📍 Backend: http://localhost:3001"
echo "📍 Frontend: http://localhost:5000"

# Fin limpio
wait

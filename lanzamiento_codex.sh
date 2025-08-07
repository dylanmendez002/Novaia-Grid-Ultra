#!/bin/bash
set -e

echo "🚀 Iniciando NOVAIA GRID ULTRA..."

# 🔹 Validar estructura
if [ ! -d "./bot" ]; then echo "❌ Falta carpeta 'bot'"; exit 1; fi
if [ ! -d "./web" ]; then echo "❌ Falta carpeta 'web'"; exit 1; fi

# ========================
# ⚙️ 1. BACKEND - FASTAPI
# ========================
echo "📦 Backend: Instalando entorno virtual..."

cd bot
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt || { echo "❌ Error instalando dependencias"; exit 1; }

echo "🔥 Backend: Ejecutando API en segundo plano..."
nohup uvicorn main:app --host 0.0.0.0 --port 3001 > ../log_backend.txt 2>&1 &

cd ..

# ========================
# 🌐 2. FRONTEND - REACT
# ========================
echo "📦 Frontend: Preparando interfaz..."

cd web
if command -v pnpm &> /dev/null; then
  pnpm install || pnpm install --force
  pnpm run dev -- --port 5000 > ../log_frontend.txt 2>&1 &
else
  npm install --force
  npm run dev -- --port 5000 > ../log_frontend.txt 2>&1 &
fi

cd ..

# ========================
# ✅ FIN DEL PROCESO
# ========================
echo "✅ NOVAIA GRID ULTRA EN EJECUCIÓN"
echo "📍 API Backend: http://localhost:3001"
echo "📍 Interfaz Web: http://localhost:5000"
echo "📜 Logs: log_backend.txt / log_frontend.txt"

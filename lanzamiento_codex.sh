#!/bin/bash
set -e

echo "🔧 Iniciando entorno para NOVAIA GRID ULTRA..."

cd bot || { echo "❌ Carpeta 'bot' no encontrada"; exit 1; }

echo "📦 Instalando dependencias del bot..."
pip install -r requirements.txt
playwright install --with-deps || echo "⚠️ Playwright no requerido o falló, continuando..."

echo "🚀 Levantando backend..."
uvicorn main:app --host 0.0.0.0 --port 3001 &

cd ../web || { echo "❌ Carpeta 'web' no encontrada"; exit 1; }

echo "📦 Instalando dependencias del frontend..."
npm install --force

echo "🚀 Levantando frontend en Next.js..."
npm run dev -- --port 5000

echo "✅ NOVAIA GRID ULTRA está corriendo en:"
echo "   🌐 Frontend: http://localhost:5000"
echo "   🧠 Backend (API): http://localhost:3001"

#!/bin/bash
set -e
set -x

# Ir al backend
cd bot || exit 1

# Crear y activar entorno virtual
python3 -m venv .venv
source .venv/bin/activate

# Instalar dependencias
pip install --upgrade pip
pip install -r requirements.txt || exit 1
playwright install --with-deps || exit 1

# Lanzar backend en segundo plano
nohup uvicorn main:app --host 0.0.0.0 --port 3001 &

# Ir al frontend
cd ../web || exit 1

# Instalar y lanzar frontend
if command -v pnpm &> /dev/null; then
    pnpm install --force
    pnpm run dev -- --port 5000
else
    npm install --force
    npm run dev -- --port 5000
fi

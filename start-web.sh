#!/bin/bash

echo "🌐 INICIANDO PAINEL WEB SATISFACTORY"
echo "===================================="

# Verificar se Flask está instalado
if ! python3 -c "import flask" 2>/dev/null; then
    echo "❌ Flask não instalado! Instalando..."
    sudo pip3 install flask
fi

# Verificar se os scripts de controle existem
if [ ! -f "/home/satisfactory/abrir-server.sh" ]; then
    echo "❌ Scripts de controle não encontrados!"
    exit 1
fi

# Obter IP do servidor
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "✅ Iniciando painel web..."
echo "🌐 Acesse em: http://$SERVER_IP:5000"
echo "🎮 Controle do mundo 'Ai meu Deus'"
echo ""
echo "Para parar: Ctrl+C"
echo "===================================="

# Iniciar Flask
cd /home/satisfactory/
python3 web-control.py

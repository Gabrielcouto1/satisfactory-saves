#!/bin/bash

echo "🛑 PARANDO PAINEL WEB SATISFACTORY"
echo "================================="

# Parar serviço se existir
if systemctl list-units --full -all | grep -Fq "satisfactory-web.service"; then
    echo "🔄 Parando serviço satisfactory-web..."
    sudo systemctl stop satisfactory-web.service
fi

# Parar processo manual
if pgrep -f "web-control.py" > /dev/null; then
    echo "🔄 Parando processo web-control.py..."
    pkill -f "web-control.py"
    sleep 2
fi

# Verificar se parou
if pgrep -f "web-control.py" > /dev/null; then
    echo "❌ Processo ainda rodando, forçando..."
    pkill -9 -f "web-control.py"
else
    echo "✅ Painel web parado com sucesso!"
fi

echo "🎯 Painel web OFFLINE"

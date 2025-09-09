#!/bin/bash

echo "🔴 PARANDO SERVIDOR SATISFACTORY - Mundo: Ai meu Deus"
echo "=================================================="

# Fazer backup antes de parar
echo "📁 Fazendo backup de segurança antes de parar..."
sudo -u satisfactory /home/satisfactory/backup-script.sh

echo ""
echo "🛑 Parando o servidor..."
sudo systemctl stop satisfactory.service

# Aguardar um momento
sleep 3

# Verificar se parou
if systemctl is-active --quiet satisfactory.service; then
    echo "❌ ERRO: Servidor ainda está rodando!"
    sudo systemctl status satisfactory.service
    exit 1
else
    echo "✅ Servidor parado com sucesso!"
    echo "📊 Status final:"
    sudo systemctl status satisfactory.service --no-pager -l
fi

echo ""
echo "🎯 Servidor Satisfactory OFFLINE"
echo "   Para iniciar novamente: ./abrir-server.sh"

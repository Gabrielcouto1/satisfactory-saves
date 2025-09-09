#!/bin/bash

echo "🟢 INICIANDO SERVIDOR SATISFACTORY - Mundo: Ai meu Deus"
echo "======================================================"

# Verificar se já está rodando
if systemctl is-active --quiet satisfactory.service; then
    echo "⚠️  Servidor já está rodando!"
    echo "📊 Status atual:"
    sudo systemctl status satisfactory.service --no-pager -l
    exit 1
fi

echo "🚀 Iniciando o servidor..."
sudo systemctl start satisfactory.service

# Aguardar inicialização
echo "⏳ Aguardando inicialização (30 segundos)..."
sleep 30

# Verificar se iniciou
if systemctl is-active --quiet satisfactory.service; then
    echo "✅ Servidor iniciado com sucesso!"
    echo ""
    echo "🎮 INFORMAÇÕES DO SERVIDOR:"
    echo "   Mundo: Ai meu Deus"
    echo "   IP: $(hostname -I | awk '{print $1}'):7777"
    echo "   Query Port: 15777"
    echo "   Beacon Port: 15000"
    echo ""
    echo "📊 Status do serviço:"
    sudo systemctl status satisfactory.service --no-pager -l
    echo ""
    echo "📝 Últimos logs:"
    sudo journalctl -u satisfactory.service -n 10 --no-pager
else
    echo "❌ ERRO: Falha ao iniciar o servidor!"
    echo "📝 Logs de erro:"
    sudo journalctl -u satisfactory.service -n 20 --no-pager
    exit 1
fi

echo ""
echo "🎯 Servidor Satisfactory ONLINE!"
echo "   Conecte-se em: $(hostname -I | awk '{print $1}'):7777"

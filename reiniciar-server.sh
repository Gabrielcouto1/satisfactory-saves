#!/bin/bash

echo "🔄 REINICIANDO SERVIDOR SATISFACTORY - Mundo: Ai meu Deus"
echo "========================================================="

# Verificar status atual
echo "📊 Status atual do servidor:"
if systemctl is-active --quiet satisfactory.service; then
    echo "   Status: 🟢 ONLINE"
else
    echo "   Status: 🔴 OFFLINE"
fi

# Fazer backup antes do restart
echo ""
echo "📁 Fazendo backup de segurança antes do restart..."
sudo -u satisfactory /home/satisfactory/backup-script.sh

echo ""
echo "🔄 Reiniciando servidor..."
sudo systemctl restart satisfactory.service

# Aguardar reinicialização
echo "⏳ Aguardando reinicialização (45 segundos)..."
sleep 45

# Verificar se reiniciou corretamente
if systemctl is-active --quiet satisfactory.service; then
    echo "✅ Servidor reiniciado com sucesso!"
    echo ""
    echo "🎮 INFORMAÇÕES DO SERVIDOR:"
    echo "   Mundo: Ai meu Deus"
    echo "   IP: $(hostname -I | awk '{print $1}'):7777"
    echo "   Uptime: $(systemctl show -p ActiveEnterTimestamp satisfactory.service --value)"
    echo ""
    echo "📊 Status do serviço:"
    sudo systemctl status satisfactory.service --no-pager -l
    echo ""
    echo "📝 Logs recentes:"
    sudo journalctl -u satisfactory.service -n 5 --no-pager
else
    echo "❌ ERRO: Falha ao reiniciar o servidor!"
    echo "📝 Logs de erro:"
    sudo journalctl -u satisfactory.service -n 20 --no-pager
    exit 1
fi

echo ""
echo "🎯 Restart concluído! Servidor ONLINE"
echo "   Mundo 'Ai meu Deus' disponível em: $(hostname -I | awk '{print $1}'):7777"

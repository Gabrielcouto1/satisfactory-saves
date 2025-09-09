#!/bin/bash

echo "📊 STATUS DO SERVIDOR SATISFACTORY"
echo "=================================="

# Status do serviço
if systemctl is-active --quiet satisfactory.service; then
    STATUS="🟢 ONLINE"
    COLOR="\033[32m"
else
    STATUS="🔴 OFFLINE"
    COLOR="\033[31m"
fi

echo -e "Status: $COLOR$STATUS\033[0m"

# Informações detalhadas
echo ""
echo "🎮 INFORMAÇÕES DO SERVIDOR:"
echo "   Mundo: Ai meu Deus"
echo "   IP: $(hostname -I | awk '{print $1}'):7777"
echo "   Query Port: 15777"
echo "   Uptime: $(systemctl show -p ActiveEnterTimestamp satisfactory.service --value | cut -d' ' -f2-)"

# Contar saves
SAVE_COUNT=$(find /opt/satisfactory/.config/Epic/FactoryGame/Saved -name "*.sav" -type f 2>/dev/null | wc -l)
echo "   Total de Saves: $SAVE_COUNT"

# Status detalhado do sistema
echo ""
echo "📋 STATUS DETALHADO:"
sudo systemctl status satisfactory.service --no-pager -l

# Últimos logs
echo ""
echo "📝 ÚLTIMOS LOGS (5 linhas):"
sudo journalctl -u satisfactory.service -n 5 --no-pager

# Uso de recursos
echo ""
echo "💾 RECURSOS DO SISTEMA:"
echo "   RAM: $(free -h | awk 'NR==2{printf "%.1f%% (%s/%s)", $3*100/$2, $3, $2}')"
echo "   Disco: $(df -h /opt/satisfactory | awk 'NR==2{printf "%s usado de %s (%s)", $3, $2, $5}')"

# Última atividade de save
echo ""
echo "💾 ÚLTIMA ATIVIDADE DE SAVE:"
sudo journalctl -u satisfactory.service | grep "World Serialization" | tail -1

echo ""
echo "=================================="

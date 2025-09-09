#!/bin/bash

# Configurações
BACKUP_DIR="/home/satisfactory/backups"
SAVES_DIR="/opt/satisfactory/.config/Epic/FactoryGame/Saved"
REPO_URL="https://github.com/Gabrielcouto1/satisfactory-saves.git"
DATE=$(date '+%Y%m%d_%H%M%S')

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"

# Inicializar Git se necessário
if [ ! -d ".git" ]; then
    git init
    git remote add origin "$REPO_URL"
    git config user.name "Satisfactory Server"
    git config user.email "server@localhost"
    echo "# Satisfactory Server Backups - Mundo: Ai meu Deus" > README.md
    echo "Backups automáticos do servidor Satisfactory" >> README.md
    git add README.md
    git commit -m "Initial commit"
fi

echo "=== Backup iniciado em $(date) ==="

# Verificar se o diretório de saves existe
if [ -d "$SAVES_DIR" ]; then
    echo "📁 Fazendo backup de: $SAVES_DIR"
    rsync -av --delete "$SAVES_DIR/" ./Saved/

    # Contar arquivos de save
    SAVE_COUNT=$(find ./Saved -name "*.sav" -type f | wc -l)
    echo "📊 Arquivos .sav encontrados: $SAVE_COUNT"

    # Mostrar saves individuais
    echo "🎮 Mundos encontrados:"
    find ./Saved -name "*.sav" -type f -exec basename {} \; | sort
else
    echo "❌ ERRO: Diretório de saves não encontrado: $SAVES_DIR"
    exit 1
fi

# Backup da configuração do servidor
cp /etc/systemd/system/satisfactory.service ./satisfactory.service 2>/dev/null || true

# Informações detalhadas do backup
{
    echo "=== Satisfactory Server Backup ==="
    echo "Data: $(date)"
    echo "Servidor: $(hostname)"
    echo "Status do serviço: $(systemctl is-active satisfactory.service)"
    echo "Mundo principal: Ai meu Deus"
    echo ""
    echo "=== Estatísticas dos Saves ==="
    echo "Total de arquivos .sav: $SAVE_COUNT"
    echo "Tamanho total: $(du -sh ./Saved 2>/dev/null | cut -f1)"
    echo ""
    echo "=== Lista de Saves ==="
    find ./Saved -name "*.sav" -type f -printf "%f - %s bytes - %TY-%Tm-%Td %TH:%TM\n" | sort
    echo ""
    echo "=== Status do Sistema ==="
    echo "Uptime: $(uptime -p)"
    echo "Uso de disco:"
    df -h /opt/satisfactory | tail -1
    echo ""
    echo "=== Últimos Logs de Save ==="
    journalctl -u satisfactory.service -n 5 --no-pager | grep "World Serialization" | tail -3
} > backup-info.txt

# Commit se houver mudanças
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Backup: Mundo 'Ai meu Deus' - $DATE ($SAVE_COUNT saves)"

    # Tentar push para GitHub
    git push

    echo "🎯 Status: $SAVE_COUNT arquivos backupeados (Mundo: Ai meu Deus)"
else
    echo "ℹ️  Nenhuma mudança detectada no mundo 'Ai meu Deus'"
fi

echo "=== Backup concluído em $(date) ==="

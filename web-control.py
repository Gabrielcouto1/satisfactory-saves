from flask import Flask, render_template_string, redirect, url_for, flash, jsonify
import subprocess
import os
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'satisfactory-ai-meu-deus-2025'

# Template HTML com CSS responsivo
TEMPLATE = """
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🎮 Satisfactory Server Control - Ai meu Deus</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .controls {
            padding: 40px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .btn {
            padding: 15px 25px;
            font-size: 18px;
            font-weight: bold;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-start {
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white;
        }
        
        .btn-stop {
            background: linear-gradient(45deg, #f44336, #d32f2f);
            color: white;
        }
        
        .btn-restart {
            background: linear-gradient(45deg, #ff9800, #f57c00);
            color: white;
        }
        
        .btn-status {
            background: linear-gradient(45deg, #2196F3, #1976d2);
            color: white;
        }
        
        .output {
            margin: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-left: 4px solid #007bff;
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            white-space: pre-wrap;
            max-height: 400px;
            overflow-y: auto;
            font-size: 14px;
            line-height: 1.4;
        }
        
        .info-panel {
            background: #e3f2fd;
            padding: 20px;
            margin: 20px;
            border-radius: 10px;
            border-left: 5px solid #2196F3;
        }
        
        .timestamp {
            color: #666;
            font-size: 12px;
            text-align: right;
            margin-top: 10px;
        }
        
        @media (max-width: 600px) {
            .controls {
                grid-template-columns: 1fr;
            }
            .header h1 { font-size: 2em; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎮 Satisfactory Server</h1>
            <p>Mundo: "Ai meu Deus" | Controle Total</p>
        </div>
        
        <div class="info-panel">
            <strong>🌐 Informações de Conexão:</strong><br>
            IP: <code>{{ server_ip }}:7777</code><br>
            Query Port: <code>15777</code> | Beacon Port: <code>15000</code>
        </div>
        
        <div class="controls">
            <form method="post" action="/start">
                <button type="submit" class="btn btn-start">
                    🚀 Iniciar Servidor
                </button>
            </form>
            
            <form method="post" action="/stop">
                <button type="submit" class="btn btn-stop">
                    🛑 Parar Servidor
                </button>
            </form>
            
            <form method="post" action="/restart">
                <button type="submit" class="btn btn-restart">
                    🔄 Reiniciar Servidor
                </button>
            </form>
            
            <form method="post" action="/status">
                <button type="submit" class="btn btn-status">
                    📊 Ver Status
                </button>
            </form>
        </div>
        
        {% with messages = get_flashed_messages() %}
        {% if messages %}
        <div class="output">
            {% for message in messages %}
                {{ message }}
            {% endfor %}
            <div class="timestamp">Executado em: {{ timestamp }}</div>
        </div>
        {% endif %}
        {% endwith %}
    </div>
</body>
</html>
"""

def get_server_ip():
    try:
        result = subprocess.run(['hostname', '-I'], capture_output=True, text=True)
        return result.stdout.strip().split()[0]
    except:
        return "localhost"

def run_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, timeout=120)
        output = result.stdout
        if result.stderr:
            output += "\n--- ERROS ---\n" + result.stderr
        return output
    except subprocess.TimeoutExpired:
        return "❌ ERRO: Comando demorou muito para executar (timeout 120s)"
    except Exception as e:
        return f"❌ ERRO: {str(e)}"

@app.route('/')
def home():
    server_ip = get_server_ip()
    timestamp = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
    return render_template_string(TEMPLATE, server_ip=server_ip, timestamp=timestamp)

@app.route('/start', methods=['POST'])
def start_server():
    output = run_command('sudo /home/satisfactory/abrir-server.sh')
    flash(f"🚀 INICIAR SERVIDOR\n{'='*50}\n{output}")
    return redirect(url_for('home'))

@app.route('/stop', methods=['POST'])
def stop_server():
    output = run_command('sudo /home/satisfactory/fechar-server.sh')
    flash(f"🛑 PARAR SERVIDOR\n{'='*50}\n{output}")
    return redirect(url_for('home'))

@app.route('/restart', methods=['POST'])
def restart_server():
    output = run_command('sudo /home/satisfactory/reiniciar-server.sh')
    flash(f"🔄 REINICIAR SERVIDOR\n{'='*50}\n{output}")
    return redirect(url_for('home'))

@app.route('/status', methods=['POST'])
def status_server():
    output = run_command('sudo /home/satisfactory/status-server.sh')
    flash(f"📊 STATUS DO SERVIDOR\n{'='*50}\n{output}")
    return redirect(url_for('home'))

# API endpoints para integração futura
@app.route('/api/status')
def api_status():
    try:
        result = subprocess.run(['systemctl', 'is-active', 'satisfactory.service'], 
                               capture_output=True, text=True)
        status = "online" if result.stdout.strip() == "active" else "offline"
        
        # Contar saves
        save_count = len([f for f in os.listdir('/opt/satisfactory/.config/Epic/FactoryGame/Saved/SaveGames/server/') 
                         if f.endswith('.sav')])
        
        return jsonify({
            "status": status,
            "server_ip": get_server_ip(),
            "save_count": save_count,
            "timestamp": datetime.now().isoformat()
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)

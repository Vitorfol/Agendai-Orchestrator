#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Função para verificar se o Git está instalado
check_git() {
    if ! command -v git &> /dev/null; then
        print_message "$RED" "❌ Git não está instalado. Por favor, instale o Git."
        exit 1
    fi
}

# Função para verificar se o Docker está instalado
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_message "$RED" "❌ Docker não está instalado. Por favor, instale o Docker."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_message "$RED" "❌ Docker Compose não está instalado. Por favor, instale o Docker Compose."
        exit 1
    fi
}

# Função para inicializar submodules
init_submodules() {
    print_message "$BLUE" "📦 Verificando submodules..."
    
    # Verifica se os submodules existem e não estão vazios
    if [ ! -d "backend/.git" ] || [ ! -d "frontend/.git" ]; then
        if [ ! -f ".gitmodules" ]; then
            print_message "$RED" "❌ Arquivo .gitmodules não encontrado!"
            print_message "$YELLOW" "Execute: git submodule add <url> para adicionar os submodules"
            exit 1
        fi
        
        print_message "$BLUE" "⬇️  Clonando submodules..."
        git submodule init
        git submodule update --init --recursive
        
        if [ ! -d "backend/.git" ] || [ ! -d "frontend/.git" ]; then
            print_message "$RED" "❌ Erro ao clonar submodules!"
            print_message "$YELLOW" "Certifique-se de ter as permissões necessárias nos repositórios:"
            print_message "$YELLOW" "  - https://github.com/Vitorfol/Agendai-APS"
            print_message "$YELLOW" "  - https://github.com/VictorManoel-Timbo/Agendai"
            exit 1
        fi
        
        print_message "$GREEN" "✅ Submodules inicializados com sucesso!"
    else
        print_message "$GREEN" "✅ Submodules já inicializados."
    fi
}

# Função para atualizar submodules
update_submodules() {
    print_message "$BLUE" "🔄 Atualizando submodules..."
    git submodule update --remote --recursive
    print_message "$GREEN" "✅ Submodules atualizados com sucesso!"
}

# Função para iniciar os serviços
start_services() {
    print_message "$BLUE" "🚀 Iniciando serviços..."
    
    # Configura e inicia o backend usando o script setup.sh (inclui banco de dados)
    if [ -f "backend/src/scripts/setup.sh" ]; then
        print_message "$BLUE" "🔧 Configurando backend e banco de dados..."
        cd backend/src/scripts
        chmod +x setup.sh
        ./setup.sh --down --init
        cd ../../..
        print_message "$GREEN" "✅ Backend e banco de dados configurados!"
    else
        print_message "$YELLOW" "⚠️  Script setup.sh do backend não encontrado, usando docker-compose..."
        # Fallback: inicia banco e backend via docker-compose
        if command -v docker-compose &> /dev/null; then
            docker-compose up -d db backend
        else
            docker compose up -d db backend
        fi
    fi
    
    # Inicia o frontend
    print_message "$BLUE" "🎨 Iniciando frontend..."
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d frontend
    else
        docker compose up -d frontend
    fi
    
    if [ $? -eq 0 ]; then
        print_message "$GREEN" "✅ Serviços iniciados com sucesso!"
        print_message "$BLUE" "📊 Status dos serviços:"
        if command -v docker-compose &> /dev/null; then
            docker-compose ps
        else
            docker compose ps
        fi
        print_message "$GREEN" "\n🌐 Serviços disponíveis:"
        print_message "$GREEN" "   Frontend: http://localhost:3000"
        print_message "$GREEN" "   Backend:  http://localhost:8000"
        print_message "$GREEN" "   Database: localhost:5432"
    else
        print_message "$RED" "❌ Erro ao iniciar serviços."
        exit 1
    fi
}

# Função para parar os serviços
stop_services() {
    print_message "$YELLOW" "🛑 Parando serviços..."
    
    if command -v docker-compose &> /dev/null; then
        docker-compose down
    else
        docker compose down
    fi
    
    print_message "$GREEN" "✅ Serviços parados com sucesso!"
}

# Função para reiniciar os serviços
restart_services() {
    stop_services
    start_services
}

# Função para mostrar logs
show_logs() {
    service=$1
    
    if [ -z "$service" ]; then
        print_message "$BLUE" "📋 Mostrando logs de todos os serviços..."
        if command -v docker-compose &> /dev/null; then
            docker-compose logs -f
        else
            docker compose logs -f
        fi
    else
        print_message "$BLUE" "📋 Mostrando logs do serviço: $service"
        if command -v docker-compose &> /dev/null; then
            docker-compose logs -f "$service"
        else
            docker compose logs -f "$service"
        fi
    fi
}

# Função para limpar tudo
clean_all() {
    print_message "$YELLOW" "🧹 Limpando containers, volumes e imagens..."
    
    if command -v docker-compose &> /dev/null; then
        docker-compose down -v --remove-orphans
    else
        docker compose down -v --remove-orphans
    fi
    
    print_message "$GREEN" "✅ Limpeza concluída!"
}

# Função para rebuild
rebuild_services() {
    print_message "$BLUE" "🔨 Reconstruindo serviços..."
    
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d --build
    else
        docker compose up -d --build
    fi
    
    print_message "$GREEN" "✅ Serviços reconstruídos com sucesso!"
}

# Função para mostrar status
show_status() {
    print_message "$BLUE" "📊 Status dos serviços:"
    
    if command -v docker-compose &> /dev/null; then
        docker-compose ps
    else
        docker compose ps
    fi
}

# Função de ajuda
show_help() {
    echo "
╔═══════════════════════════════════════════════════════════╗
║            🚀 Agendai Orchestrator - Ajuda               ║
╚═══════════════════════════════════════════════════════════╝

Uso: ./start.sh [comando]

Comandos disponíveis:

  start         Inicializa submodules e inicia todos os serviços
  stop          Para todos os serviços
  restart       Reinicia todos os serviços
  rebuild       Reconstrói e inicia os serviços
  status        Mostra o status dos serviços
  logs [serviço] Mostra logs (todos ou de um serviço específico)
                Serviços: backend, frontend, db
  update        Atualiza os submodules para a versão mais recente
  clean         Remove todos os containers, volumes e orphans
  help          Mostra esta mensagem de ajuda

Exemplos:

  ./start.sh start           # Inicia todo o ambiente
  ./start.sh logs backend    # Mostra logs do backend
  ./start.sh logs            # Mostra logs de todos os serviços
  ./start.sh rebuild         # Reconstrói as imagens

"
}

# Main script
main() {
    print_message "$BLUE" "
╔═══════════════════════════════════════════════════════════╗
║            🚀 Agendai Orchestrator                       ║
╚═══════════════════════════════════════════════════════════╝
"
    
    # Verifica dependências
    check_git
    check_docker
    
    # Processa comando
    case "${1:-start}" in
        start)
            init_submodules
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        rebuild)
            rebuild_services
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs "$2"
            ;;
        update)
            update_submodules
            ;;
        clean)
            clean_all
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_message "$RED" "❌ Comando desconhecido: $1"
            show_help
            exit 1
            ;;
    esac
}

# Executa o script
main "$@"

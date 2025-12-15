.PHONY: help init start stop restart rebuild status logs logs-backend logs-frontend logs-db update clean

# Cores
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

help: ## Mostra esta ajuda
	@echo "$(BLUE)╔═══════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║            🚀 Agendai Orchestrator - Makefile            ║$(NC)"
	@echo "$(BLUE)╚═══════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Comandos disponíveis:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

init: ## Inicializa os submodules
	@./start.sh start

start: ## Inicia todos os serviços
	@./start.sh start

stop: ## Para todos os serviços
	@./start.sh stop

restart: ## Reinicia todos os serviços
	@./start.sh restart

rebuild: ## Reconstrói e inicia os serviços
	@./start.sh rebuild

status: ## Mostra o status dos serviços
	@./start.sh status

logs: ## Mostra logs de todos os serviços
	@./start.sh logs

logs-backend: ## Mostra logs do backend
	@./start.sh logs backend

logs-frontend: ## Mostra logs do frontend
	@./start.sh logs frontend

logs-db: ## Mostra logs do banco de dados
	@./start.sh logs db

update: ## Atualiza os submodules
	@./start.sh update

clean: ## Remove containers, volumes e orphans
	@./start.sh clean

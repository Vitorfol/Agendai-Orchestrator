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
	@./services.sh start

start: ## Inicia todos os serviços
	@./services.sh start

stop: ## Para todos os serviços
	@./services.sh stop

restart: ## Reinicia todos os serviços
	@./services.sh restart

rebuild: ## Reconstrói e inicia os serviços
	@./services.sh rebuild

status: ## Mostra o status dos serviços
	@./services.sh status

logs: ## Mostra logs de todos os serviços
	@./services.sh logs

logs-backend: ## Mostra logs do backend
	@./services.sh logs backend

logs-frontend: ## Mostra logs do frontend
	@./services.sh logs frontend

logs-db: ## Mostra logs do banco de dados
	@./services.sh logs db

update: ## Atualiza os submodules
	@./services.sh update

clean: ## Remove containers, volumes e orphans
	@./services.sh clean

# 🔧 Troubleshooting - Agendai Orchestrator

## Problemas Comuns e Soluções

### 1. Submodules Vazios

**Problema:** As pastas `backend/` e `frontend/` estão vazias após clonar o repositório.

**Solução:**
```bash
git submodule update --init --recursive
```

Ou use o script:
```bash
./start.sh start
```

### 2. Script setup.sh do Backend Não Encontrado

**Problema:** Erro indicando que `backend/src/scripts/setup.sh` não foi encontrado.

**Causas possíveis:**
- Submodules não foram inicializados
- Estrutura do backend mudou

**Solução:**
```bash
# Verifique se o submodule foi clonado
ls -la backend/

# Se estiver vazio, inicialize
git submodule update --init --recursive

# Verifique a estrutura do backend
ls -la backend/src/scripts/
```

### 3. Portas em Uso

**Problema:** Erro ao iniciar containers - porta já está em uso.

**Portas utilizadas:**
- 3000 (Frontend)
- 8000 (Backend)
- 5432 (PostgreSQL)

**Solução:**
```bash
# Verificar o que está usando as portas
sudo lsof -i :3000
sudo lsof -i :8000
sudo lsof -i :5432

# Parar processo específico
kill -9 <PID>

# Ou modificar as portas no docker-compose.yml
```

### 4. Permissão Negada ao Executar start.sh

**Problema:** `bash: ./start.sh: Permission denied`

**Solução:**
```bash
chmod +x start.sh
./start.sh start
```

### 5. Docker Compose Não Encontrado

**Problema:** Erro indicando que docker-compose não está instalado.

**Solução:**
```bash
# Verificar instalação
docker --version
docker-compose --version

# Ou usar a versão plugin
docker compose version

# Instalar docker-compose (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install docker-compose-plugin
```

### 6. Banco de Dados Não Conecta

**Problema:** Backend não consegue conectar ao banco de dados.

**Solução:**
```bash
# Verificar se o container do banco está rodando
docker ps | grep agendai-db

# Ver logs do banco
./start.sh logs db

# Reiniciar apenas o banco
docker-compose restart db

# Verificar se o healthcheck está passando
docker inspect agendai-db | grep -A 5 Health
```

### 7. Erro ao Construir Imagens Docker

**Problema:** Erro durante o build das imagens Docker.

**Solução:**
```bash
# Limpar cache do Docker
docker system prune -a

# Rebuild forçado
./start.sh clean
./start.sh rebuild
```

### 8. Submodule com Problemas de Autenticação

**Problema:** Erro de permissão ao clonar submodules.

**Solução:**
```bash
# Se usar HTTPS, configure suas credenciais
git config --global credential.helper store

# Ou use SSH
# Edite .gitmodules e troque:
# url = https://github.com/user/repo.git
# por:
# url = git@github.com:user/repo.git

# Depois:
git submodule sync
git submodule update --init --recursive
```

### 9. Frontend Não Carrega

**Problema:** Acesso a http://localhost:3000 não funciona.

**Solução:**
```bash
# Verificar logs do frontend
./start.sh logs frontend

# Verificar se o container está rodando
docker ps | grep agendai-frontend

# Reiniciar o frontend
docker-compose restart frontend

# Verificar se há erros de build
docker-compose logs frontend | grep -i error
```

### 10. Backend Retorna Erro 500

**Problema:** API do backend retorna erro 500.

**Solução:**
```bash
# Ver logs detalhados do backend
./start.sh logs backend

# Verificar conexão com banco
docker exec -it agendai-backend bash
# Dentro do container:
python -c "from sqlalchemy import create_engine; engine = create_engine('postgresql://postgres:postgres@db:5432/agendai'); engine.connect()"

# Verificar migrações
docker exec -it agendai-backend bash
cd /app
# Execute comando de migração do seu projeto
```

### 11. Mudanças no Código Não Refletem

**Problema:** Alterações no código não aparecem nos containers.

**Solução:**
```bash
# Para backend e frontend com volumes, deve funcionar automaticamente
# Se não funcionar, rebuild:
./start.sh rebuild

# Ou para um serviço específico:
docker-compose up -d --build backend
docker-compose up -d --build frontend
```

### 12. Limpar Tudo e Recomeçar

**Problema:** Quando nada mais funciona.

**Solução:**
```bash
# Parar e remover tudo
./start.sh clean

# Remover volumes órfãos
docker volume prune

# Remover todas as redes não utilizadas
docker network prune

# Recomeçar do zero
./start.sh start
```

## 🐛 Debug Avançado

### Entrar em um Container

```bash
# Backend
docker exec -it agendai-backend bash

# Frontend
docker exec -it agendai-frontend sh

# Banco de dados
docker exec -it agendai-db psql -U postgres -d agendai
```

### Verificar Logs em Tempo Real

```bash
# Todos os serviços
docker-compose logs -f

# Serviço específico
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### Verificar Recursos do Docker

```bash
# Ver uso de espaço
docker system df

# Ver containers em execução
docker ps

# Ver todos os containers (incluindo parados)
docker ps -a

# Ver volumes
docker volume ls

# Ver redes
docker network ls
```

### Verificar Variáveis de Ambiente

```bash
# Dentro de um container
docker exec agendai-backend env

# Verificar se o .env está sendo carregado
docker-compose config
```

## 📞 Precisa de Mais Ajuda?

Se nenhuma dessas soluções resolver seu problema:

1. Verifique os logs detalhados: `./start.sh logs`
2. Abra uma issue no repositório com:
   - Sistema operacional
   - Versão do Docker
   - Logs relevantes
   - Passos para reproduzir o problema

## 🔗 Links Úteis

- [Documentação Docker](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

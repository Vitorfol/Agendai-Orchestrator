# 🚀 Agendai Orchestrator

Orquestrador completo para o sistema Agendai, gerenciando backend, frontend e banco de dados em containers Docker através de submodules Git.

---

## 📋 Índice

- [Pré-requisitos](#-pré-requisitos)
- [Configuração Inicial](#-configuração-inicial)
- [Comandos Disponíveis](#-comandos-disponíveis)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Portas e Serviços](#-portas-e-serviços)
- [Trabalhando com Submodules](#-trabalhando-com-submodules)
- [Workflows Comuns](#-workflows-comuns)
- [Troubleshooting](#-troubleshooting)

---

## 🛠️ Pré-requisitos

- Git
- Docker
- Docker Compose

---

## 🚀 Configuração Inicial

### 1️⃣ Primeira Vez - Clone com Submodules

Existem duas formas de obter o projeto completo:

#### Opção A: Clonar tudo de uma vez (Recomendado)

```bash
git clone --recurse-submodules <URL_DESTE_REPOSITORIO>
cd Agendai-Orchestrator
```

#### Opção B: Clonar e depois inicializar submodules

```bash
# Clone o repositório principal
git clone <URL_DESTE_REPOSITORIO>
cd Agendai-Orchestrator

# Inicialize os submodules
git submodule update --init --recursive
```

### Quickstart (clone do zero -> rodando)

Se você está clonando este repositório do zero e quer deixá‑lo rodando rapidamente, siga estes passos:

```bash
# 1. Clone com submodules (recomendado)
git clone --recurse-submodules <URL_DESTE_REPOSITORIO>
cd Agendai-Orchestrator

# 2. Garantir que .gitmodules seja aplicado (atualiza submodules conforme branches configuradas)
./services.sh update

# 3. Iniciar os serviços
./services.sh start
```

Notas:
- `./services.sh update` executa `git submodule update --remote --recursive` e faz os submodules seguirem as branches configuradas em `.gitmodules`.
- Os arquivos `.env` ficam dentro dos submodules (`backend/.env`, `frontend/.env`); o arquivo de exemplo do orquestrador foi removido.
- Após `./services.sh update`, commit no repo orquestrador para registrar as novas referências dos submodules:

```bash
git add backend frontend
git commit -m "Update submodules to match .gitmodules"
git push
```


### 2️⃣ Verificar Estrutura

Após o clone, você deve ter:

```
Agendai-Orchestrator/
├── backend/           # Submodule: Agendai-APS (branch: main)
├── frontend/          # Submodule: Agendai (branch: feature/front-docker)
├── services.sh        # Script principal de gerenciamento
├── Makefile          # Comandos alternativos
└── README.md         # Esta documentação
```

Para verificar se os submodules foram clonados:

```bash
ls backend/
ls frontend/
```

Se as pastas estiverem vazias:

```bash
git submodule update --init --recursive
```

### 3️⃣ Iniciar o Sistema

```bash
./services.sh start
```

Ou usando o Makefile:

```bash
make start
```

---

## 🎮 Comandos Disponíveis

### Usando `./services.sh`

```bash
./services.sh start       # Inicia todos os serviços
./services.sh stop        # Para todos os serviços
./services.sh restart     # Reinicia todos os serviços
./services.sh status      # Mostra status dos containers
./services.sh submodules  # Ver branches dos submodules
./services.sh logs        # Logs de todos os serviços
./services.sh logs backend # Logs do backend
./services.sh logs frontend # Logs do frontend
./services.sh update      # Atualiza submodules
./services.sh rebuild     # Reconstrói imagens
./services.sh clean       # Remove containers e volumes
./services.sh help        # Mostra ajuda completa
```

### Usando `make`

```bash
make start            # Inicia todos os serviços
make stop             # Para todos os serviços
make restart          # Reinicia
make status           # Status dos containers
make logs             # Logs de todos
make logs-backend     # Logs do backend
make logs-frontend    # Logs do frontend
make update           # Atualiza submodules
make clean            # Limpa tudo
```

---

## 📁 Estrutura do Projeto

### Submodules Configurados

| Submodule | Repositório | Branch | Descrição |
|-----------|-------------|--------|-----------|
| **backend** | [Agendai-APS](https://github.com/Vitorfol/Agendai-APS) | `main` | API Backend + Banco de Dados |
| **frontend** | [Agendai](https://github.com/VictorManoel-Timbo/Agendai) | `feature/front-docker` | Interface Web |

### Como Funciona

- **Backend**: Gerenciado pelo script `backend/backend/scripts/setup.sh`
  - Inclui banco de dados MySQL
  - Configuração automática com `--down --init`
  
- **Frontend**: Possui seu próprio `docker-compose.yml`
  - Build com Dockerfile próprio
  - Nginx para servir arquivos estáticos

---

## 🌐 Portas e Serviços

| Serviço | Porta | URL | Descrição |
|---------|-------|-----|-----------|
| **Frontend** | 80 | http://localhost | Interface web (Nginx) |
| **Backend** | 8000 | http://localhost:8000 | API REST |
| **Database** | 3307 | localhost:3307 | MySQL |

### Acessar os Serviços

```bash
# Frontend
curl http://localhost

# Backend Health Check
curl http://localhost:8000/health

# Conectar ao banco
mysql -h 127.0.0.1 -P 3307 -u root -p
```

---

## 🔄 Trabalhando com Submodules

### Ver Status dos Submodules

```bash
./services.sh submodules
```

Ou manualmente:

```bash
git submodule status
```

### Atualizar Submodules

```bash
# Puxar últimas mudanças dos repos originais
./services.sh update

# Ou manualmente
git submodule update --remote --recursive
```

### Trocar de Branch em um Submodule

```bash
# Entre no submodule
cd backend  # ou frontend

# Ver branches disponíveis
git branch -a

# Trocar de branch
git checkout nome-da-branch
git pull origin nome-da-branch

# Volte ao repo principal
cd ..

# Reinicie os serviços
./services.sh restart
```

### Trabalhar em Mudanças

```bash
# 1. Entre no submodule
cd backend  # ou frontend

# 2. Crie uma branch
git checkout -b minha-feature

# 3. Faça suas alterações
# ... edite arquivos ...

# 4. Commit e push
git add .
git commit -m "feat: nova funcionalidade"
git push origin minha-feature

# 5. Volte ao repo principal
cd ..

# 6. (Opcional) Atualize referência no orquestrador
git add backend  # ou frontend
git commit -m "Update backend submodule"
git push
```

---

## 🔁 Workflows Comuns

### Workflow 1: Iniciar Desenvolvimento

```bash
# 1. Clone o projeto
git clone --recurse-submodules <URL>
cd Agendai-Orchestrator

# 2. Inicie os serviços
./services.sh start

# 3. Acesse:
# - Frontend: http://localhost
# - Backend: http://localhost:8000
```

### Workflow 2: Pegar Atualizações

```bash
# 1. Pull do repositório principal
git pull --recurse-submodules

# 2. Reinicie os serviços
./services.sh restart
```

### Workflow 3: Desenvolver uma Feature

```bash
# 1. Atualize tudo
git pull --recurse-submodules
./services.sh update

# 2. Entre no submodule
cd backend  # ou frontend
git checkout -b feature/minha-feature

# 3. Desenvolva e teste
# ... código ...

# 4. Teste localmente
cd ..
./services.sh restart

# 5. Commit no submodule
cd backend
git add .
git commit -m "feat: minha feature"
git push origin feature/minha-feature
cd ..

# 6. Atualize referência (opcional)
git add backend
git commit -m "Update backend submodule"
git push
```

### Workflow 4: Trocar de Ambiente/Branch

```bash
# Backend em outra branch
cd backend
git checkout develop
git pull origin develop
cd ..

# Frontend em outra branch
cd frontend
git checkout main
git pull origin main
cd ..

# Reiniciar com novas branches
./services.sh restart
```

### Workflow 5: Trabalhar no Repo Original

Se você já tem os repos clonados separadamente:

```bash
# 1. Trabalhe no repo original
cd ~/meus-projetos/Agendai-APS
git checkout -b feature-x
# ... desenvolva ...
git push origin feature-x

# 2. No orquestrador, atualize o submodule
cd ~/Agendai-Orchestrator
./services.sh update

# 3. Use a nova branch
cd backend
git checkout feature-x
cd ..
./services.sh restart
```

---

## 🐛 Troubleshooting

### Submodules Vazios

```bash
git submodule update --init --recursive
```

### Container com Nome em Conflito

```bash
# Remover container específico
docker rm -f agendai-frontend
docker rm -f agendai-backend

# Ou limpar tudo
./services.sh clean
./services.sh start
```

### Portas em Uso

```bash
# Verificar o que está usando a porta
sudo lsof -i :80
sudo lsof -i :8000
sudo lsof -i :3307

# Parar processo
kill -9 <PID>
```

### Erro ao Trocar de Branch

```bash
cd backend  # ou frontend

# Salvar mudanças temporariamente
git stash

# Trocar de branch
git checkout outra-branch

# Recuperar mudanças (se necessário)
git stash pop
```

### Submodule em "Detached HEAD"

```bash
cd backend  # ou frontend
git checkout main  # ou a branch desejada
cd ..
```

### Resetar Tudo

```bash
# Parar serviços
./services.sh stop

# Limpar containers e volumes
./services.sh clean

# Resetar submodules
git submodule deinit -f .
git submodule update --init --recursive

# Reiniciar
./services.sh start
```

### Ver Logs de Erro

```bash
# Todos os serviços
./services.sh logs

# Serviço específico
./services.sh logs backend
./services.sh logs frontend

# Logs do Docker
docker logs agendai-backend
docker logs agendai-frontend
```

### Verificar Configuração

```bash
# Ver status dos submodules
./services.sh submodules

# Ver branches
cd backend && git branch --show-current && cd ..
cd frontend && git branch --show-current && cd ..

# Ver containers rodando
docker ps

# Ver configuração do .gitmodules
cat .gitmodules
```

---

## 📚 Referências Úteis

### Comandos Git Submodules

```bash
# Ver status
git submodule status

# Atualizar todos
git submodule update --remote --recursive

# Sincronizar configuração
git submodule sync

# Executar comando em todos
git submodule foreach 'git status'
git submodule foreach 'git pull'

# Ver diferenças
git diff --submodule

# Clonar com submodules
git clone --recurse-submodules <url>

# Pull com submodules
git pull --recurse-submodules
```

### Comandos Docker Úteis

```bash
# Ver containers
docker ps
docker ps -a

# Ver logs
docker logs -f agendai-backend
docker logs -f agendai-frontend

# Entrar em um container
docker exec -it agendai-backend bash
docker exec -it agendai-frontend sh

# Ver recursos
docker system df

# Limpar recursos não usados
docker system prune
docker volume prune
docker network prune
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📝 Notas Importantes

- ✅ Submodules são clones completos dos repositórios originais
- ✅ Mudanças nos repos originais podem ser puxadas com `./services.sh update`
- ✅ Cada submodule pode estar em uma branch diferente
- ✅ O arquivo `.gitmodules` define os repositórios e branches padrão
- ✅ Sempre commite no submodule antes do repo principal
- ⚠️ Não trabalhe diretamente na `main` dos submodules
- ⚠️ Use branches descritivas para suas features

---

## 📄 Licença

Este projeto está sob a licença MIT.

---

## 🆘 Precisa de Ajuda?

```bash
# Ver ajuda completa do script
./services.sh help

# Ver comandos do Makefile
make help
```

Para problemas específicos, abra uma issue no repositório com:
- Sistema operacional
- Versão do Docker (`docker --version`)
- Logs relevantes (`./services.sh logs`)
- Passos para reproduzir o problema

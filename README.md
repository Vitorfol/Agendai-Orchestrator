# 🚀 Agendai Orchestrator

Orquestrador para o sistema Agendai, gerenciando o backend e frontend em containers Docker.

## 📋 Pré-requisitos

- Git
- Docker
- Docker Compose

## 🔧 Configuração Inicial

### 1. Clonar o Repositório com Submodules

```bash
# Clone o repositório principal
git clone --recurse-submodules https://github.com/seu-usuario/Agendai-Orchestrator.git

# OU se já clonou sem os submodules
git clone https://github.com/seu-usuario/Agendai-Orchestrator.git
cd Agendai-Orchestrator
git submodule update --init --recursive
```

### 2. Estrutura do Projeto

Após clonar, você terá a seguinte estrutura:

```
Agendai-Orchestrator/
├── backend/           # Submodule: Agendai-APS
├── frontend/          # Submodule: Agendai
├── docker-compose.yml
├── start.sh
└── README.md
```

## 🚀 Como Usar

### Iniciar o Sistema

```bash
./start.sh start
```

Este comando irá:
- Verificar e inicializar os submodules (se necessário)
- Configurar o backend usando o script setup.sh
- Iniciar o frontend
- Iniciar o banco de dados PostgreSQL
- Disponibilizar os serviços

### Outros Comandos Disponíveis

```bash
# Parar todos os serviços
./start.sh stop

# Reiniciar os serviços
./start.sh restart

# Reconstruir as imagens e iniciar
./start.sh rebuild

# Ver status dos serviços
./start.sh status

# Ver logs de todos os serviços
./start.sh logs

# Ver logs de um serviço específico
./start.sh logs backend   # ou frontend, db

# Atualizar submodules para última versão
./start.sh update

# Limpar containers, volumes e imagens
./start.sh clean

# Ajuda
./start.sh help
```

## 🌐 Endpoints

Após iniciar o sistema:

- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:8000
- **Database**: localhost:5432
  - User: `postgres`
  - Password: `postgres`
  - Database: `agendai`

## 📦 Submodules

- **Backend**: [Agendai-APS](https://github.com/Vitorfol/Agendai-APS)
- **Frontend**: [Agendai](https://github.com/VictorManoel-Timbo/Agendai)

## 🔄 Atualizando os Submodules

Para atualizar os submodules para as versões mais recentes:

```bash
./start.sh update
```

Ou manualmente:

```bash
git submodule update --remote --recursive
```

## 🐛 Troubleshooting

### Submodules vazios

Se as pastas backend/frontend estiverem vazias:

```bash
git submodule update --init --recursive
```

### Portas em uso

Se as portas 3000, 8000 ou 5432 estiverem em uso, você pode:
1. Parar os serviços que estão usando essas portas
2. Modificar as portas no arquivo `docker-compose.yml`

### Limpar tudo e recomeçar

```bash
./start.sh clean
./start.sh start
```

## 📝 Notas

- O backend usa um script personalizado (`setup.sh`) para inicialização
- Os volumes Docker persistem os dados do banco de dados
- Modificações nos arquivos são refletidas em tempo real (hot reload)

## 🤝 Contribuindo

1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

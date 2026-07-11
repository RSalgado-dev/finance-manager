# Finance Manager

Aplicação multi-tenant de gestão financeira operacional. O projeto está na fase de scaffold; a aplicação Rails ainda não foi gerada.

## Desenvolvimento local

O Dev Container é o ambiente canônico. Não instale Ruby, Bundler, Rails ou PostgreSQL no host. O host precisa somente de Git, Docker e Docker Compose; VS Code e a extensão Dev Containers são opcionais.

Versões fixadas:

| Componente | Versão |
|---|---|
| Ruby | 3.4.10 |
| Rails CLI | 8.1.3 |
| Bundler | 2.7.2 |
| PostgreSQL | 17.10 (`postgres:17.10-bookworm`) |
| PostgreSQL client | 15.x do Debian 12 (15.18 validado) |
| Sistema base do app | Debian 12 Bookworm (`ruby:3.4.10-bookworm`) |

Copie as variáveis fictícias de desenvolvimento e ajuste apenas UID/GID se o host não utilizar `1000:1000`:

```bash
cp .env.example .env
```

Construa e inicie o ambiente:

```bash
docker compose -f .devcontainer/compose.yaml build
docker compose -f .devcontainer/compose.yaml up -d
docker compose -f .devcontainer/compose.yaml ps
```

Execute comandos no container ativo:

```bash
docker compose -f .devcontainer/compose.yaml exec app ruby --version
docker compose -f .devcontainer/compose.yaml exec app bundle --version
docker compose -f .devcontainer/compose.yaml exec app rails --version
docker compose -f .devcontainer/compose.yaml exec app psql --version
```

Ou execute um comando descartável:

```bash
docker compose -f .devcontainer/compose.yaml run --rm app ruby --version
```

Pare os serviços preservando volumes:

```bash
docker compose -f .devcontainer/compose.yaml down
```

Reconstrua depois de alterar Dockerfile ou versões:

```bash
docker compose -f .devcontainer/compose.yaml build --no-cache app
docker compose -f .devcontainer/compose.yaml up -d
```

Para apagar somente containers, rede e volumes deste ambiente de desenvolvimento — incluindo banco e cache de gems — use conscientemente:

```bash
docker compose -f .devcontainer/compose.yaml down --volumes
```

## VS Code Dev Container

Abra a raiz no VS Code e execute “Dev Containers: Reopen in Container”. O editor usa o serviço `app`, inicia `db` e roda o script pós-criação idempotente. Esse script valida ferramentas e só executa `bundle install` quando um `Gemfile` existir; ele nunca executa `rails new`.

Consulte [docs/development-container.md](docs/development-container.md) para arquitetura, PostgreSQL e diagnóstico.

## Especificações e planejamento

- `AGENTS.md`: protocolo permanente de trabalho.
- `specs/`: baseline normativa.
- `planning/CURRENT.md`: estado e próxima ação.
- `planning/tasks/`: tarefas executáveis.

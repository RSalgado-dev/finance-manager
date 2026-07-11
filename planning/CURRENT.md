# Estado atual

Atualizado em: `2026-07-11 20:23 America/Sao_Paulo`

## Estado do repositório

- Milestone ativo: `M0`
- Tarefa ativa: nenhuma; `M0-T02A` concluída, `M0-T02B` ainda `NOT_STARTED`
- Estado global: `DEV_CONTAINER_READY`
- Branch: `main`
- Working tree inicial: limpa; atual: alterações de `M0-T02A` não commitadas
- Último commit relevante: `d9d96a0` (`feat: Revise domain specifications and introduce new requirements`)

## O que já existe

- Baseline normativa revisada, com 496 requisitos identificados.
- Decisões aceitas de tenancy, contexto por path, integridade composta e auditoria transacional.
- Máquinas de estado, matriz de autorização, cobertura de origem, roadmap e protocolo entre sessões.
- Aplicação ainda não inicializada.

## Último trabalho realizado

`M0-T02A` concluída com 18/18 critérios. A imagem multi-stage foi construída, `app` e `db` estão ativos, PostgreSQL está healthy, ferramentas/usuário/permissões/volumes/pós-criação foram validados e a documentação está atualizada. Nenhuma aplicação Rails foi inicializada.

## Próxima ação exata

1. Em nova sessão, executar o protocolo inicial e confirmar `M0-T02A` como `DONE`.
2. Detalhar `M0-T02B` pelo template, incluindo opções exatas de `rails new`.
3. Executar o scaffold somente por `docker compose ... exec/run app`, nunca no host.
4. Manter `M0-T03` e M1 fora do escopo até concluir `M0-T02B`.

## Arquivos prioritários

- `AGENTS.md`
- `planning/tasks/M0-specification-and-scaffold.md`
- `.devcontainer/Dockerfile`
- `.devcontainer/compose.yaml`
- `.devcontainer/devcontainer.json`
- `.devcontainer/scripts/post-create.sh`
- `README.md`
- `docs/development-container.md`
- `scripts/check_spec_requirements.sh`

## Verificações conhecidas

- `git status --short`: sucesso; working tree inicial limpa.
- `git branch --show-current`: `main`.
- `git log -1 --oneline`: `d9d96a0 feat: Revise domain specifications and introduce new requirements`.
- `docker --version`: 29.1.2.
- `docker compose version`: 2.40.3-desktop.1.
- aplicação Rails ausente: `Gemfile`, `app/`, `config/` e `db/` não existem.
- `bash scripts/check_spec_requirements.sh`: sucesso no baseline, 496 IDs.
- `bash -n .devcontainer/scripts/post-create.sh scripts/check_spec_requirements.sh`: sucesso.
- `docker compose -f .devcontainer/compose.yaml config`: sucesso; serviços `app` e `db`, dois volumes e nenhuma porta publicada.
- `git diff --check`: sucesso após criar a configuração.
- `docker compose -f .devcontainer/compose.yaml build`: sucesso; imagem `finance-manager-dev-app` construída.
- `docker compose ... up -d`: sucesso; `app` ativo e `db` healthy.
- ferramentas: Ruby 3.4.10, Bundler 2.7.2, Rails 8.1.3, psql 15.18, Chromium/ChromeDriver 150 e libvips 8.14.1 validados no `app`.
- usuário/permissões: `vscode` UID/GID `1000:1000`, arquivo temporário no bind mount criado com ownership `1000:1000`.
- pós-criação executado duas vezes sem gerar aplicação ou exigir `Gemfile`.
- PostgreSQL: hostname `db`, autenticação, `SELECT 1`, healthcheck e persistência após restart validados; tabela temporária removida.
- cache de gems: escrita `1000:1000` e persistência após restart validadas; marcador removido.
- `docker compose ... config --quiet`, build multi-stage final, `up -d`, `ps` e comandos canônicos: sucesso.
- `python3 -m json.tool .devcontainer/devcontainer.json`: sucesso.
- `scripts/check_spec_requirements.sh`: sucesso, 496 IDs, zero falhas.
- `git diff --check`: sucesso final.
- aplicação Rails ausente após todas as validações.

## Bloqueios

Nenhum bloqueio para planejar `M0-T02B`. A CLI `devcontainer` não está instalada; validação por essa CLI não foi executada, mas Compose e runtime foram validados integralmente.

## Decisões pendentes

Questões futuras não bloqueantes: `Q-002` (turnos), `Q-003` (retenção), `Q-004` (limites de upload) e `Q-015` (cardinalidade/descarte de comprovantes).

## Versões e arquitetura do ambiente

- app: Ruby 3.4.10 / Debian 12 Bookworm, Bundler 2.7.2, Rails CLI 8.1.3;
- db: PostgreSQL 17.10 Bookworm; cliente psql 15.18 compatível no `app`;
- usuário: `vscode` não root, UID/GID 1000 por padrão ajustável no build;
- volumes: `postgres_data` e `bundle_cache` persistentes; código por bind mount;
- ferramentas auxiliares: build-essential, Git, curl, libpq, libvips, Chromium e ChromeDriver;
- ausentes intencionalmente: Node.js, Redis, Sidekiq, Docker socket e modo privilegiado.

## Estado operacional

- containers `finance-manager-dev-app-1` e `finance-manager-dev-db-1` permanecem ativos;
- banco está healthy e não publica porta no host;
- `.env` não foi criado nem versionado; defaults fictícios seguros foram usados.

## Alterações não commitadas

- `planning/CURRENT.md`
- `planning/ROADMAP.md`
- `planning/SESSION_LOG.md`
- `planning/TRACEABILITY.md`
- `planning/tasks/M0-specification-and-scaffold.md`
- `planning/tasks/M1-foundation.md`
- `.devcontainer/Dockerfile`
- `.devcontainer/compose.yaml`
- `.devcontainer/devcontainer.json`
- `.devcontainer/scripts/post-create.sh`
- `.dockerignore`
- `.gitignore`
- `.env.example`
- `README.md`
- `docs/development-container.md`

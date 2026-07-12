# Estado atual

Atualizado em: `2026-07-11 21:00 America/Sao_Paulo`

## Estado do repositório

- Milestone: `M0` — `IN_PROGRESS` até concluir o CI inicial.
- Última tarefa trabalhada: `M0-T02B` — `DONE`.
- Tarefa agregadora `M0-T02`: `DONE` (`M0-T02A` e `M0-T02B` concluídas).
- Próxima tarefa: `M0-T03` — `NOT_STARTED`.
- Estado operacional: `RAILS_SCAFFOLD_VERIFIED`.
- Branch: `main`.
- Último commit: `9e7de69 feat: Implementar Dev Container e atualizar planejamento para M0 e M1`.
- Working tree inicial: limpa; atual: scaffold e documentação de `M0-T02B` não commitados.

## Resultado

A aplicação Rails 8.1.3 foi incorporada à raiz como `CompanyFinance`, sem sobrescrever o repositório spec-driven. O ambiente continua canônico via Dev Container; nenhuma ferramenta Ruby foi instalada ou executada diretamente no host. Não há funcionalidade de domínio, CI ou deploy.

O scaffold foi gerado primeiro em `/tmp/company_finance`, inventariado e depois incorporado pela CLI Rails com `--skip`. O diretório temporário foi removido somente após a validação.

## Versões e arquitetura

- Ruby 3.4.10, Bundler 2.7.2 e Rails 8.1.3 no serviço `app`.
- PostgreSQL server 17.10 no serviço `db`; psql 15.18 no `app`.
- PostgreSQL por hostname `db`, usuário fictício local `app`, bancos separados `company_finance_development` e `company_finance_test`.
- Views server-side, importmap, Turbo, Stimulus e Tailwind sem Node.js.
- Active Storage carregável, sem migrations/tabelas de comprovantes.
- Solid Queue/Cache/Cable disponíveis sobre PostgreSQL, sem Redis e sem jobs de negócio.
- UUID como padrão dos generators; locale `pt-BR`; timezone `America/Sao_Paulo`; BRL e formatos brasileiros; semana fixa iniciando na segunda-feira.
- RSpec, FactoryBot, Capybara, Selenium e Chromium headless; RuboCop Rails Omakase, Brakeman e Bundler Audit.

## Verificações executadas

- protocolo inicial: status, branch, log, Compose `ps/config`, documentos obrigatórios e versões no container;
- Rails generator help e geração temporária com todos os flags previstos;
- Compose `config`, reconstrução de `app`, `up -d` e `ps`: sucesso; `db` healthy;
- `bundle install` e `bundle check`: sucesso;
- `db:create`, `db:prepare` e test prepare: sucesso;
- prova de banco vazio: zero tabelas de domínio; development/test removidos, recriados e preparados via Rails;
- RSpec: 2 exemplos, 0 falhas, incluindo Chromium headless;
- RuboCop: 28 arquivos, 0 offenses;
- Brakeman 8.0.5: zero warnings;
- Bundler Audit: advisory database atualizado, zero vulnerabilidades;
- routes, Zeitwerk, Tailwind build e assets precompile: sucesso;
- runner: `CompanyFinance::Application`, timezone, locale, segunda-feira, UUID, Active Storage e Solid Queue confirmados;
- `bin/setup --skip-server`: sucesso idempotente;
- `bin/dev`: Puma e watcher Tailwind iniciaram; requisição real a `/up` retornou 200;
- `bash -n`: sucesso nos scripts shell alterados;
- verificador de specs: 496 IDs, zero duplicidades, referências ausentes, linhas normativas sem ID ou links quebrados;
- `git diff --check`: sucesso.

## Falhas conhecidas e limitações

- duas falhas de `bin/dev` foram encontradas e corrigidas: permissão executável e watcher Tailwind não persistente sem TTY;
- CLI `devcontainer` continua ausente no host; Compose, build e runtime foram validados e isso não bloqueia a tarefa;
- a porta 3000 não é publicada pelo Compose; o VS Code encaminha a porta e a requisição real foi validada dentro de `app`;
- CI ainda não existe por limite explícito desta sessão;
- alterações permanecem não commitadas; nenhum commit foi autorizado.

## Arquivos principais criados ou alterados

- aplicação: `Gemfile`, `Gemfile.lock`, `app/`, `bin/`, `config/`, `db/`, `spec/`, `Procfile.dev`, `Rakefile`;
- ambiente: `.devcontainer/compose.yaml`, `.env.example`, `.gitignore`, `.dockerignore`;
- documentação: `README.md`, `docs/development-container.md`;
- planejamento: `planning/tasks/M0-specification-and-scaffold.md`, `planning/ROADMAP.md`, `planning/TRACEABILITY.md`, `planning/SESSION_LOG.md`, `planning/CURRENT.md`.

## Próxima ação exata

Em nova sessão, executar o protocolo inicial do `AGENTS.md`, detalhar `M0-T03 — Configurar CI inicial` com o template e implementar o pipeline usando os mesmos comandos containerizados já validados. Não iniciar M1 nem qualquer domínio antes de concluir M0-T03.

# Histórico de sessões

Acrescente novas sessões no topo. Não reescreva entradas antigas, salvo correção factual explícita.

## 2026-07-11 21:00 — M0-T02B

### Objetivo

Inicializar e validar o scaffold Rails `CompanyFinance` exclusivamente no Dev Container, sem implementar domínio ou CI.

### Estado inicial

Branch `main`, working tree limpa, commit `9e7de69`. `M0-T01` e `M0-T02A` estavam `DONE`; `M0-T02B` estava `NOT_STARTED`; `app` e `db` operacionais e nenhuma estrutura Rails existia.

### Trabalho realizado

- tarefa detalhada e marcada `IN_PROGRESS` antes da geração;
- flags do Rails 8.1.3 confirmados e scaffold gerado primeiro em `/tmp/company_finance`;
- scaffold incorporado com `--skip`, preservando documentação, Dev Container, specs e planning;
- Rails/PostgreSQL/importmap/Hotwire/Tailwind, UUID, `pt-BR`, BRL, timezone e semana fixa configurados;
- RSpec, FactoryBot, Capybara/Selenium, RuboCop Omakase, Brakeman e Bundler Audit configurados;
- request e system specs reais de `/up` adicionados;
- Active Storage mantido sem tabelas de comprovantes; Solid Queue mantido com PostgreSQL e sem Redis;
- README e guia do container atualizados, sem instruções de Ruby no host;
- bancos development/test recriados do zero; imagem reconstruída; scaffold temporário removido;
- `M0-T02B` e agregadora `M0-T02` concluídas. `M0-T03` não foi iniciada.

### Verificações

| Comando | Resultado |
|---|---|
| Compose `config`, `build`, `up -d`, `ps` | sucesso; app ativo e db healthy |
| versões no `app` | Ruby 3.4.10, Bundler 2.7.2, Rails 8.1.3, psql 15.18 |
| `bundle install` / `bundle check` | sucesso; lockfile resolvido no container |
| `db:drop db:create db:prepare` e test prepare | sucesso; bancos recriados sem estado residual |
| `bundle exec rspec` | 2 exemplos, 0 falhas |
| `bundle exec rubocop` | 28 arquivos, 0 offenses |
| `bundle exec brakeman` | 0 warnings |
| `bundle exec bundler-audit check --update` | advisory database atualizado, 0 vulnerabilidades |
| routes / Zeitwerk / Tailwind / assets | sucesso |
| runners de módulo, regionalização, UUID, Active Storage e Solid Queue | valores esperados confirmados |
| `bin/setup --skip-server` | sucesso idempotente |
| `bin/dev` + requisição `/up` | Puma e Tailwind ativos; HTTP 200 |
| `scripts/check_spec_requirements.sh` | 496 IDs, zero falhas |
| `bash -n` / `git diff --check` | sucesso |

### Falhas corrigidas

A primeira validação de `bin/dev` detectou o bit executável ausente; a segunda detectou que o watcher Tailwind encerrava sem TTY. O script passou a usar Foreman pelo Bundler e `tailwindcss:watch[always]`; a validação seguinte passou.

### Handoff

Próxima ação exata: em nova sessão, executar o protocolo inicial e detalhar `M0-T03 — Configurar CI inicial`; não iniciar M1 ou domínios antes do CI.

## 2026-07-11 20:23 — M0-T02A

### Objetivo

Construir e validar o Dev Container canônico sem instalar stack Ruby no host e sem inicializar Rails.

### Estado inicial

Branch `main`, working tree limpa, commit `d9d96a0`. `M0-T01` estava `DONE`; Docker 29.1.2 e Compose 2.40.3 disponíveis; aplicação Rails ausente.

### Trabalho realizado

- `M0-T02` subdividida em `M0-T02A` e `M0-T02B` sem renumerar tarefas;
- Dev Container multi-stage criado com `app` não root e `db` PostgreSQL;
- versões fixadas e Rails CLI instalada somente na imagem;
- volumes de banco e gems, healthcheck, bind mount e pós-criação idempotente configurados;
- README, guia operacional, ignores e ambiente fictício adicionados;
- imagem construída e serviços iniciados;
- ferramentas, PATH, permissões, hostname, autenticação e persistência validados;
- nenhuma aplicação Rails, gem de projeto, migration ou código de domínio criado;
- `M0-T02A` concluída com 18/18 critérios; `M0-T02B` permanece `NOT_STARTED`.

### Arquivos principais

- `.devcontainer/Dockerfile`
- `.devcontainer/compose.yaml`
- `.devcontainer/devcontainer.json`
- `.devcontainer/scripts/post-create.sh`
- `.env.example`
- `.dockerignore`
- `.gitignore`
- `README.md`
- `docs/development-container.md`
- `planning/tasks/M0-specification-and-scaffold.md`
- `planning/CURRENT.md`

### Verificações

| Comando | Resultado |
|---|---|
| `docker compose -f .devcontainer/compose.yaml config` | sucesso |
| `docker compose -f .devcontainer/compose.yaml build` | sucesso; imagem multi-stage construída |
| `docker compose -f .devcontainer/compose.yaml up -d` / `ps` | sucesso; app ativo, db healthy |
| comandos Ruby/Bundler/Rails/psql no app | 3.4.10 / 2.7.2 / 8.1.3 / 15.18 |
| pós-criação executado duas vezes | sucesso; idempotente, sem Gemfile e sem geração |
| teste de UID/GID e bind mount | sucesso; usuário não root e ownership 1000:1000 |
| `SELECT 1` via hostname `db` | sucesso, usuário `app` e banco de desenvolvimento |
| persistência após restart de db/app | sucesso para banco e cache de gems; marcadores removidos |
| `bash -n` e JSON | sucesso |
| `scripts/check_spec_requirements.sh` | sucesso; 496 IDs, zero falhas |
| `git diff --check` | sucesso |
| ausência de estrutura Rails | confirmada |

### Decisões

Ruby 3.4.10, Rails 8.1.3, Bundler 2.7.2, PostgreSQL 17.10 e Debian 12 Bookworm. Dev Container é o único ambiente local canônico; nenhuma stack Ruby deve ser instalada no host.

### Pendências e riscos

- CLI `devcontainer` ausente, portanto não validada; não bloqueia por Compose/runtime completos;
- psql 15.18 do Debian conecta ao servidor 17.10; registrar eventual alinhamento de major somente se surgir requisito;
- worker será integrado ao mesmo Compose em M1, sem configuração concorrente;
- alterações não commitadas; nenhum commit autorizado.

### Handoff

Próxima ação exata: em nova sessão, detalhar `M0-T02B` e executar `rails new` exclusivamente dentro do `app` validado. Não iniciar M0-T03 ou M1 antes disso.

## 2026-07-11 17:43 — M0-T01

### Objetivo

Resolver as questões e propostas da revisão inicial, alinhar integralmente a baseline normativa e concluir `M0-T01` sem iniciar Rails.

### Estado inicial

Branch `main`, commit-base `3b8c3c750bb7a2c7d38c85c5fc4cd0fb1844a205`, com as alterações documentais não commitadas da sessão anterior preservadas. `M0-T01` estava `IN_PROGRESS` com 4/7 critérios.

### Trabalho realizado

- decisões explícitas aplicadas a semana, fechamentos, despesas, regimes, autorização, integridade tenant, convites, auditoria e divergências;
- `ADR-0003` e `ADR-0004` aceitos;
- matriz normativa de autorização criada;
- 496 requisitos normativos identificados e checados;
- brief histórico não normativo e matriz de cobertura criados;
- `Q-001`, `Q-005`, `Q-006`–`Q-014` e `Q-016` resolvidas; `Q-002`–`Q-004` e `Q-015` mantidas abertas;
- `P-001` rejeitada; `P-002`–`P-007` aceitas;
- roadmap e tarefas realinhados sem iniciar implementação;
- rastreabilidade e riscos atualizados;
- todas as specs relidas após as alterações;
- `M0-T01` marcada `DONE` com 7/7 critérios.

### Arquivos principais

- `specs/10-architecture/authorization-matrix.md`
- `specs/10-architecture/data-model.md`
- `specs/20-domains/cash-management.md`
- `specs/20-domains/expenses.md`
- `specs/20-domains/dashboard-and-reporting.md`
- `specs/20-domains/platform-and-audit.md`
- `specs/00-product/source-brief.md`
- `planning/SOURCE_COVERAGE.md`
- `planning/ROADMAP.md`
- `planning/tasks/M0-specification-and-scaffold.md`
- `scripts/check_spec_requirements.sh`

### Verificações

| Comando | Resultado |
|---|---|
| `git status --short --branch` | sucesso; estado anterior preservado na branch `main` |
| leitura integral por `sed` antes e após alterações | sucesso; documentos obrigatórios e todas as specs revisados |
| `bash -n scripts/check_spec_requirements.sh` | sucesso |
| `bash scripts/check_spec_requirements.sh` | sucesso; 15 specs, 496 IDs, zero duplicidades, referências inexistentes, linhas normativas sem ID ou referências documentais quebradas |
| `git diff --check` | sucesso |
| teste de ausência de `Gemfile`, `app/`, `config/` e `db/` | sucesso; Rails não inicializado |

Testes Rails, lint e análise de segurança não são aplicáveis porque não existe aplicação e a tarefa é documental.

### Decisões

As especificações corrigidas são a baseline normativa inicial. ADR-0003/0004 estão aceitos. Questões futuras abertas não contradizem a baseline e possuem milestone de resolução registrado.

### Pendências e riscos

- `Q-002`, `Q-003` e `Q-004` permanecem abertas com defaults iniciais;
- `Q-015` deve ser resolvida antes de detalhar/iniciar M5-T05;
- riscos R-008 e R-012 permanecem até implementação e testes das defesas especificadas;
- alterações das duas sessões continuam não commitadas por falta de autorização para commit.

### Handoff

Próxima ação exata: em nova sessão, executar o protocolo inicial, detalhar `M0-T02` pelo template e somente então iniciar o scaffold Rails. `M0-T02` não foi iniciada nesta sessão.

## 2026-07-11 17:27 — M0-T01

### Objetivo

Executar a primeira revisão de consistência do scaffold de especificações, sem inicializar Rails nem avançar para `M0-T02`.

### Estado inicial

Branch `main` acompanhando `origin/main`, working tree limpa no commit `3b8c3c750bb7a2c7d38c85c5fc4cd0fb1844a205`. Repositório com 42 arquivos versionados e sem aplicação Rails.

### Trabalho realizado

- protocolo inicial e inventário do repositório executados;
- documentos obrigatórios, todas as specs e todas as tarefas do roadmap lidos integralmente;
- consistência revisada entre produto, arquitetura, dados, segurança, domínios, qualidade, operação e planejamento;
- `Q-001` ampliada e `Q-006` a `Q-016` registradas;
- `P-001` a `P-007`, `R-008` a `R-012` e os ADRs propostos 0003/0004 registrados;
- critérios e evidência de `M0-T01` atualizados: 4/7 satisfeitos;
- duas referências inequívocas corrigidas sem mudança semântica;
- nenhuma aplicação, migration, dependência ou teste de código criado.

### Arquivos principais

- `planning/tasks/M0-specification-and-scaffold.md`
- `planning/OPEN_QUESTIONS.md`
- `planning/PROPOSALS.md`
- `planning/RISKS.md`
- `planning/decisions/ADR-0003-composite-tenant-foreign-keys.md`
- `planning/decisions/ADR-0004-transactional-critical-audit.md`
- `planning/CURRENT.md`

### Verificações

| Comando | Resultado |
|---|---|
| `git status --short --branch` | sucesso; branch `main`, working tree inicial limpa |
| `git ls-files \| wc -l` | sucesso; 42 arquivos versionados |
| inventário por `rg --files` e `find` | sucesso; Rails ausente |
| leitura integral por `sed` | sucesso; documentos obrigatórios, specs e tarefas revisados |
| extração de IDs por `rg`, `sort` e `uniq` | sucesso; 262 IDs únicos, nenhuma duplicidade |
| testes de presença dos documentos | sucesso |
| teste de ausência de `Gemfile`, `app/`, `config/` e `db/` | sucesso; aplicação Rails ausente |
| `git diff --check` | sucesso; sem erros de whitespace |

Não há suíte, lint ou análise de segurança aplicáveis porque a aplicação não foi inicializada e a tarefa é exclusivamente documental.

### Decisões

Nenhuma mudança de produto ou arquitetura foi aceita. `ADR-0003` e `ADR-0004` permanecem `PROPOSED`; os defaults em questões abertas são recomendações, não decisões.

### Pendências e riscos

- falta a fonte do prompt original ou matriz aprovada de cobertura (`Q-014`);
- declarações normativas sem ID precisam ser tratadas (`P-005`);
- conflitos de período, estados, relatórios, auditoria e roadmap seguem abertos;
- risco crítico de integridade cross-tenant (`R-008`) e de transação sem auditoria (`R-012`).

### Handoff

Próxima ação exata: responsável do produto revisar `Q-001` e `Q-006` a `Q-016`, aprovar/rejeitar `P-001` a `P-007` e os ADRs propostos 0003/0004, e fornecer o prompt original ou aprovar uma matriz substituta. Depois, aplicar somente decisões aprovadas e repetir a revisão. Não iniciar `M0-T02`.

---

## YYYY-MM-DD HH:MM — <TASK-ID>

### Objetivo

### Estado inicial

### Trabalho realizado

### Arquivos principais

### Verificações

| Comando | Resultado |
|---|---|
| `comando` | sucesso/falha e resumo |

### Decisões

### Pendências e riscos

### Handoff

Próxima ação exata:

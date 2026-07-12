# M0 — Especificação e scaffold

## M0-T01 — Validar estrutura de especificações

Status: `DONE`

### Objetivo

Revisar os documentos iniciais, identificar decisões ainda ambíguas e garantir que o Codex consiga localizar requisitos e progresso entre sessões.

### Dependências

Nenhuma.

### Critérios de aceite

- [x] `AGENTS.md` é conciso e operacional.
- [x] Todas as áreas do prompt original estão representadas em `specs/`.
- [x] Requisitos possuem identificadores estáveis.
- [x] Protocolo de sessão está documentado.
- [x] Roadmap e tarefas iniciais existem.
- [x] Decisões de tenancy estão registradas.
- [x] Não há contradições materiais conhecidas.

### Método de verificação dos critérios

- `AGENTS.md`: leitura integral e confirmação de ações explícitas para início, checkpoints, segurança, multi-tenancy, verificação e encerramento.
- Cobertura do prompt: brief histórico reconstruído e baseline normativa aprovada, mapeados em `planning/SOURCE_COVERAGE.md` (`Q-014` resolvida).
- Identificadores: script automatizado verifica definições, duplicidades, referências inexistentes, linhas normativas sem ID e referências documentais.
- Protocolo: presença e coerência de `AGENTS.md`, `planning/CURRENT.md`, `planning/SESSION_LOG.md` e prompts operacionais.
- Roadmap/tarefas: presença dos milestones e tarefas; coerência de dependências avaliada separadamente em `P-003`.
- Tenancy: decisões aceitas em `ADR-0001` e `ADR-0002`; lacuna adicional proposta em `ADR-0003`.
- Consistência material: duas revisões integrais cruzadas de produto, arquitetura, dados, segurança, domínios, qualidade, operação e roadmap após as decisões aprovadas.

### Evidência

Revisão executada em 2026-07-11:

- baseline: branch `main`, acompanhando `origin/main`, working tree inicialmente limpa, commit `3b8c3c750bb7a2c7d38c85c5fc4cd0fb1844a205`;
- inventário: 42 arquivos versionados, somente scaffold documental; `Gemfile`, `app/`, `config/` e `db/` ausentes, portanto não há aplicação Rails;
- leitura: `AGENTS.md`, índice, estado atual, roadmap, tarefa ativa, questões, dois ADRs aceitos, todos os arquivos de `specs/`, tarefas M1–M10 e arquivos de governança lidos integralmente;
- requisitos: 262 identificadores normativos ou de escopo extraídos, todos com ocorrência única; listas normativas sem ID ainda existem, incluindo cards/relatórios mínimos, eventos auditáveis e infraestrutura local;
- cobertura interna: produto, identidade/tenancy, caixa, despesas/anexos, dashboard/relatórios, plataforma/auditoria, segurança, qualidade, CI e deploy possuem documentos próprios; comparação externa com o prompt original é impossível sem a fonte (`Q-014`);
- conflitos materiais: início semanal configurável versus fixo (`Q-006`), escopo de relatórios de divergência (`Q-013`), imutabilidade/atomicidade de auditoria (`Q-012`) e ordem do roadmap (`P-003`);
- ambiguidades de negócio: aprovação de despesas (`Q-001`), transições de fechamento (`Q-007`), despesas por competência (`Q-008`), matriz de autorização (`Q-009`), convites (`Q-011`), comprovantes (`Q-015`) e invariantes de pagamento (`Q-016`);
- integridade e tenancy: risco de foreign keys cross-tenant (`Q-010`, `ADR-0003`, `R-008`) e ausência de contrato completo de checks de estado/valores (`P-002`, `P-004`);
- roadmap: auditoria financeira posterior aos fluxos auditáveis, e-mail posterior ao fluxo de convite, export assíncrono sem dependência de M6 e sobreposição de fundação/CI/Compose entre milestones (`P-003`);
- correções não semânticas: referências completas para `ADR-0002` e para as specs citadas pela tarefa M2;
- rastreabilidade: nenhum requisito foi adicionado, alterado ou removido; `planning/TRACEABILITY.md` não precisou de mudança nesta sessão;
- código/testes: não aplicáveis nesta tarefa documental e antes do scaffold Rails.

Comandos e resultados:

| Comando | Resultado |
|---|---|
| `git status --short --branch` | sucesso; `main...origin/main`, working tree inicial limpa |
| `git ls-files \| wc -l` | sucesso; 42 arquivos versionados |
| `rg --files -uu -g '!/.git' \| sort` | sucesso; inventário documental obtido |
| `find . -maxdepth 3 -type d \| sort` | sucesso; nenhuma estrutura Rails encontrada |
| `git log -1 --date=iso-strict --format=...` | sucesso; baseline identificado |
| `sed -n '1,9999p' <documentos>` | sucesso; leitura integral dos documentos revisados |
| extração de IDs com `rg`, `sort` e `uniq -c` | sucesso; 262 IDs, nenhuma duplicidade |
| `git diff --check` | sucesso no baseline e após as alterações documentais |

Pendências identificadas na primeira revisão foram tratadas na segunda revisão de 2026-07-11: `Q-001`, `Q-005` e `Q-006` a `Q-014`/`Q-016` foram resolvidas; propostas foram avaliadas; ADR-0003/0004 foram aceitos; IDs e cobertura foram verificados. `Q-002`, `Q-003`, `Q-004` e `Q-015` permanecem abertas, sem contradição material e com ponto de decisão futuro registrado.

### Evidência de conclusão

- decisões de semana fixa, máquinas de estado, campos editáveis, regimes, matriz de autorização, convites, integridade tenant-scoped, auditoria e divergências incorporadas às specs;
- `ADR-0003` e `ADR-0004` com status `ACCEPTED` e consequências alinhadas;
- `P-001` rejeitada por conflitar com semana fixa; `P-002` a `P-007` aceitas e aplicadas;
- brief histórico não normativo e matriz de cobertura criados; specs corrigidas são a baseline normativa inicial;
- roadmap/tarefas corrigidos sem iniciar implementação: CI em M0, Docker local em M1, identidade/e-mails em M2, auditoria mínima em M3, eventos nos domínios, CSV/impressão em M6, async condicional em M7 e produção em M9;
- `planning/TRACEABILITY.md` atualizado para novos namespaces e tarefas;
- todas as specs normativas relidas integralmente após as alterações;
- `bash scripts/check_spec_requirements.sh`: sucesso, 15 specs normativas, 496 IDs, zero duplicidades, referências inexistentes, linhas normativas sem ID ou referências documentais quebradas;
- `bash -n scripts/check_spec_requirements.sh`: sucesso;
- `git diff --check`: sucesso;
- ausência de `Gemfile`, `app/`, `config/` e `db/` confirmada; Rails não foi inicializado;
- nenhuma gem, migration ou código de aplicação foi adicionado.

### Próximo passo

Em nova sessão, executar o protocolo inicial, detalhar `M0-T02` com o template e somente então iniciar o scaffold Rails. Não iniciar `M0-T02` nesta sessão.

---

## M0-T02 — Inicializar aplicação Rails

Status: `DONE`

### Objetivo

Criar a aplicação Rails no repositório com PostgreSQL e escolhas técnicas aprovadas.

### Dependências

M0-T01; agregadora de M0-T02A e M0-T02B.

### Subtarefas

- `M0-T02A` — Construir e validar o Dev Container.
- `M0-T02B` — Inicializar a aplicação Rails dentro do Dev Container.

`M0-T02B` depende de `M0-T02A` concluída. Nenhum comando da stack Ruby pode ser executado diretamente no host.

### Critérios de aceite

- [x] Aplicação inicia.
- [x] Banco PostgreSQL conecta.
- [x] Test framework funciona.
- [x] UUID padrão definido.
- [x] Locale e timezone base configurados.
- [x] README contém setup inicial.
- [x] `.env.example` existe.
- [x] Baseline de testes, lint e segurança registrado.

### Requisitos

`ARCH-001` a `ARCH-027`, `OPS-CI-001`.

---

## M0-T02A — Construir e validar o Dev Container

Status: `DONE`

### Objetivo

Entregar o ambiente local canônico, reproduzível e não root para executar toda a stack Ruby/Rails e PostgreSQL client exclusivamente em containers, sem inicializar a aplicação.

### Requisitos relacionados

- `ARCH-001`, `ARCH-002`, `ARCH-003`, `ARCH-004`, `ARCH-006`, `ARCH-007`, `ARCH-009`
- `OPS-LOCAL-001` a `OPS-LOCAL-008`
- `NFR-REL-003`, `NFR-MNT-001`

### Dependências

- `M0-T01`

### Dentro do escopo

- `.devcontainer/` com Dockerfile, Compose, configuração VS Code e pós-criação idempotente;
- serviço `app` não root e serviço `db` isolado;
- Ruby 3.4.10, Bundler 2.7.2, Rails CLI 8.1.3, PostgreSQL 17.10 e Debian 12 Bookworm;
- PostgreSQL client, compilação de gems nativas, libvips, Chromium/ChromeDriver e ferramentas básicas;
- volumes persistentes de gems e banco;
- variáveis fictícias de desenvolvimento, documentação e validação real.

### Fora do escopo

- `rails new`, `Gemfile` da aplicação, migrations ou diretórios Rails;
- gems de teste, lint, segurança e domínio no projeto;
- CI, autenticação, multi-tenancy e código financeiro;
- Redis, Sidekiq, Node.js, Docker socket ou modo privilegiado;
- instalação de Ruby, Rails, Bundler ou PostgreSQL no host.

### Critérios de aceite

- [x] Estrutura `.devcontainer/` existe.
- [x] Imagem `app` constrói com sucesso.
- [x] Ruby funciona dentro do container.
- [x] Bundler funciona dentro do container.
- [x] Rails CLI funciona dentro do container.
- [x] PostgreSQL client funciona dentro do container.
- [x] PostgreSQL inicia e passa no healthcheck.
- [x] `app` acessa PostgreSQL pelo hostname `db`.
- [x] Ambiente utiliza usuário não root.
- [x] Arquivos criados no workspace possuem permissões adequadas.
- [x] Volumes persistentes estão configurados e validados.
- [x] Script pós-criação é idempotente.
- [x] Ruby no host não é necessário.
- [x] Nenhuma aplicação Rails foi inicializada.
- [x] Documentos existentes foram preservados.
- [x] README documenta o fluxo containerizado.
- [x] Verificações das especificações continuam passando.
- [x] `git diff --check` passa.

### Plano técnico

1. Criar imagem baseada em Ruby/Debian fixados e usuário não root.
2. Orquestrar `app` e PostgreSQL por Compose com healthcheck e volumes.
3. Configurar Dev Container e pós-criação idempotente.
4. Documentar comandos e diagnóstico sem instalação local da stack.
5. Construir imagem, iniciar serviços e validar ferramentas, banco, persistência e permissões.
6. Executar verificações documentais e registrar evidência real.

### Riscos e casos de borda

- volume de gems perder ownership ao ser montado;
- UID/GID do host divergir do usuário do container;
- download de imagens/gems falhar por rede;
- Chromium aumentar significativamente a imagem;
- CLI `devcontainer` não estar instalada no host, sem bloquear validação por Compose;
- credenciais de desenvolvimento serem confundidas com secrets de produção.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml config
docker compose -f .devcontainer/compose.yaml build
docker compose -f .devcontainer/compose.yaml up -d
docker compose -f .devcontainer/compose.yaml ps
docker compose -f .devcontainer/compose.yaml exec app ruby --version
docker compose -f .devcontainer/compose.yaml exec app bundle --version
docker compose -f .devcontainer/compose.yaml exec app rails --version
docker compose -f .devcontainer/compose.yaml exec app psql --version
docker compose -f .devcontainer/compose.yaml exec app sh -lc 'pg_isready -h db && psql -h db -U "$DATABASE_USERNAME" -d "$POSTGRES_DB" -c "SELECT 1"'
bash -n .devcontainer/scripts/post-create.sh scripts/check_spec_requirements.sh
bash scripts/check_spec_requirements.sh
git diff --check
git status --short
```

### Evidência de conclusão

Concluída em 2026-07-11:

- planejamento subdividido e dependências atualizadas;
- `.devcontainer/`, Compose, variáveis fictícias, ignores e documentação criados;
- Ruby 3.4.10, Bundler 2.7.2, Rails CLI 8.1.3, PostgreSQL 17.10 e Debian 12 Bookworm fixados;
- `bash -n` dos scripts: sucesso;
- `docker compose ... config`: sucesso, sem portas publicadas, modo privilegiado ou Docker socket;
- `docker compose ... build`: sucesso; imagem `finance-manager-dev-app` construída com as versões fixadas;
- `docker compose ... up -d` e `ps`: sucesso; `app` ativo e PostgreSQL healthy;
- Ruby 3.4.10, Bundler 2.7.2, Rails CLI 8.1.3, psql 15.18, Chromium/ChromeDriver 150 e libvips 8.14.1 executados no `app`;
- usuário `vscode` não root e ownership `1000:1000` no bind mount validados;
- pós-criação executado duas vezes consecutivas, ignorando corretamente `bundle install` sem `Gemfile`;
- consulta `SELECT 1` e autenticação por hostname `db`: sucesso;
- registro temporário persistiu após restart do `db`; tabela removida ao final;
- marcador do cache de gems persistiu após restart do `app` e foi removido ao final;
- comando descartável `docker compose ... run --rm app ruby --version`: sucesso;
- shell de login encontra Ruby, Bundler e Rails pelo PATH configurado;
- `bash -n` e JSON do Dev Container: sucesso;
- `scripts/check_spec_requirements.sh`: sucesso, 496 IDs e zero falhas;
- `git diff --check`: sucesso;
- `Gemfile`, `app/`, `config/` e `db/` continuam ausentes;
- primeira tentativa de build no sandbox falhou ao gravar no cache Buildx do host; repetição autorizada fora do sandbox concluiu com sucesso;
- CLI `devcontainer` ausente no host; Compose validou a configuração e isso não bloqueia o aceite.

### Próximo passo

Em nova sessão, detalhar e iniciar `M0-T02B`, executando `rails new` exclusivamente dentro do Dev Container validado.

---

## M0-T02B — Inicializar a aplicação Rails dentro do Dev Container

Status: `DONE`

### Objetivo

Gerar, incorporar e validar na raiz uma aplicação Rails monolítica `CompanyFinance`, exclusivamente dentro do Dev Container, preservando o repositório spec-driven.

### Requisitos relacionados

- `ARCH-001` a `ARCH-009`, `ARCH-020` a `ARCH-027`
- `ARCH-DATA-001`, `ARCH-DATA-002`, `ARCH-DATA-013`
- `TEST-000` a `TEST-007`, `TEST-EVID-001`
- `OPS-LOCAL-001` a `OPS-LOCAL-008`, `OPS-DEV-010`, `OPS-CI-001`, `OPS-CI-003`, `OPS-CI-004`
- `NFR-REL-003`, `NFR-MNT-001`, `NFR-MNT-002`

### Dependências

M0-T02A concluída.

### Dentro do escopo

- scaffold Rails 8.1.3 com PostgreSQL, importmap, Hotwire e Tailwind;
- módulo `CompanyFinance` e UUID padrão para generators;
- banco development/test por variáveis de ambiente e produção por `DATABASE_URL`;
- locale `pt-BR`, timezone `America/Sao_Paulo` e formatos brasileiros;
- RSpec, FactoryBot, Capybara/Selenium headless;
- RuboCop Rails Omakase, Brakeman e Bundler Audit;
- endpoint institucional mínimo ou `/up` coberto por teste real;
- Active Storage carregável sem instalar suas tabelas de comprovantes;
- Solid Queue disponível com PostgreSQL e sem Redis;
- scripts canônicos, assets e README containerizado.

### Fora do escopo

- qualquer model, migration, controller ou tela de domínio;
- autenticação, autorização, tenancy, auditoria funcional e relatórios;
- Active Storage install e tabelas de comprovantes;
- jobs de negócio, worker de produção, CI ou deploy;
- Devise, Pundit, Pagy, Rack::Attack, multi-tenancy ou state machine;
- instalação da stack Ruby no host.

### Critérios de aceite

- [x] Aplicação Rails incorporada à raiz e módulo `CompanyFinance` confirmado.
- [x] Documentos e Dev Container anteriores preservados e operacionais.
- [x] Rails 8.1.3 e PostgreSQL configurados para development/test separados.
- [x] Bancos vazios podem ser criados e preparados do zero.
- [x] UUID é padrão explícito para futuras migrations.
- [x] Locale `pt-BR`, timezone `America/Sao_Paulo` e semana fixa preservados.
- [x] Importmap, Turbo, Stimulus e Tailwind estão disponíveis e compiláveis.
- [x] Active Storage está carregável sem antecipar comprovantes.
- [x] Solid Queue está disponível sem Redis.
- [x] RSpec, FactoryBot, Capybara e system specs headless estão configurados.
- [x] Há pelo menos um request spec real passando e Minitest foi removido.
- [x] RuboCop passa.
- [x] Brakeman passa sem achado crítico não justificado.
- [x] Bundler Audit passa ou possui limitação externa real registrada.
- [x] Zeitwerk, routes, assets e boot da aplicação passam.
- [x] README contém somente o fluxo containerizado validado.
- [x] Nenhuma funcionalidade de domínio foi antecipada.
- [x] Verificador de specs e `git diff --check` passam.
- [x] Ruby no host não é necessário.

### Plano técnico

1. Inspecionar `rails new --help` e gerar `CompanyFinance` em `/tmp` sem Git, Docker, CI, Kamal ou Minitest.
2. Inventariar o scaffold e conflitos; incorporar seletivamente, mesclando arquivos existentes.
3. Fixar Gemfile/lockfile e instalar dependências apenas no `app`.
4. Configurar banco, UUID, regionalização, Active Storage e Solid Queue.
5. Configurar RSpec, FactoryBot, Capybara/Chromium e teste mínimo real.
6. Ajustar scripts, Tailwind/assets, qualidade, segurança e README.
7. validar banco vazio, suíte e todos os comandos obrigatórios.

### Riscos e casos de borda

- generator sobrescrever documentação, ignores ou Dev Container;
- flags mudarem no Rails 8.1.3;
- gems geradas terem versões incompatíveis ou vulneráveis;
- Tailwind exigir ajuste sem Node;
- scripts Rails assumirem execução no host;
- bancos existentes conterem estado residual;
- rede impedir `bundle install` ou atualização do advisory database.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bundle install
docker compose -f .devcontainer/compose.yaml exec app bin/rails db:create db:prepare
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test bin/rails db:prepare
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
docker compose -f .devcontainer/compose.yaml exec app bundle exec rubocop
docker compose -f .devcontainer/compose.yaml exec app bundle exec brakeman
docker compose -f .devcontainer/compose.yaml exec app bundle exec bundler-audit check --update
docker compose -f .devcontainer/compose.yaml exec app bin/rails routes
docker compose -f .devcontainer/compose.yaml exec app bin/rails zeitwerk:check
docker compose -f .devcontainer/compose.yaml exec app bin/rails assets:precompile
docker compose -f .devcontainer/compose.yaml exec app bin/rails runner 'puts Rails.application.class.name'
docker compose -f .devcontainer/compose.yaml exec app bin/rails runner 'puts Rails.application.config.time_zone'
docker compose -f .devcontainer/compose.yaml exec app bin/rails runner 'puts I18n.default_locale'
bash scripts/check_spec_requirements.sh
git diff --check
```

### Evidência de conclusão

Concluída em 2026-07-11:

- `rails new --help` foi executado dentro de `app`; Rails 8.1.3 oferece `--database`, `--javascript`, `--css`, `--skip-test`, `--skip-git`, `--skip-docker`, `--skip-ci`, `--skip-kamal` e `--skip-devcontainer`.
- O scaffold temporário `/tmp/company_finance` foi gerado dentro de `app` com módulo `CompanyFinance`, PostgreSQL, importmap e Tailwind, sem Git, Docker, Dev Container, CI, Kamal ou Minitest.
- A geração temporária executou Bundler e os installers de importmap, Turbo, Stimulus e Tailwind com sucesso; nenhum arquivo da raiz foi substituído.
- Após inventário dos conflitos, a incorporação foi executada pela própria CLI Rails com `--skip`; `README.md`, `.devcontainer/`, `specs/`, `planning/`, `prompts/` e `scripts/` permaneceram preservados.
- `bundle install`, `db:create` e `db:prepare` passaram dentro de `app`; os bancos `company_finance_development` e `company_finance_test` estão separados e usam o hostname `db`.
- Runner confirmou `CompanyFinance::Application`, `America/Sao_Paulo`, `pt-BR`, segunda-feira como início da semana e `uuid` como chave primária dos generators.
- Dev Container reconstruído com sucesso após a incorporação; `app` permaneceu ativo e `db` healthy.
- Ruby 3.4.10, Bundler 2.7.2, Rails 8.1.3 e psql 15.18 foram executados dentro de `app`; `bundle check` confirmou o lockfile.
- Antes da prova de banco vazio, consulta ao schema confirmou zero tabelas de domínio. `db:drop`, `db:create` e `db:prepare` recriaram development e test; a suíte passou novamente.
- RSpec: 2 exemplos e zero falhas, incluindo request spec de `/up` e system spec real com Chromium headless.
- RuboCop: 28 arquivos, zero offenses. Brakeman 8.0.5: zero warnings. Bundler Audit: advisory database atualizado e nenhuma vulnerabilidade.
- `routes`, `zeitwerk:check`, `tailwindcss:build` e `assets:precompile`: sucesso.
- Active Storage carregou como engine e nenhuma tabela `active_storage_*` foi criada. Solid Queue carregou e seus schemas de infraestrutura permanecem sem Redis ou jobs de negócio.
- `bin/setup --skip-server` passou idempotentemente. `bin/dev` iniciou Puma e o watcher persistente do Tailwind; requisição real a `/up` retornou 200.
- A primeira execução de `bin/dev` revelou perda do bit executável e a segunda revelou o watcher não persistente; ambas foram corrigidas e a terceira validação passou.
- `bash -n`: sucesso nos scripts shell alterados. `scripts/check_spec_requirements.sh`: 496 IDs e zero falhas. `git diff --check`: sucesso.
- Scaffold temporário removido após incorporação e validação. Nenhuma funcionalidade de domínio, CI ou deploy foi criada.

### Próximo passo

Iniciar `M0-T03` em nova sessão, detalhando a configuração inicial de CI antes de qualquer implementação de domínio.

### Restrição

Não iniciar `M0-T03` nesta sessão.

---

## M0-T03 — Configurar CI inicial

Status: `IN_PROGRESS`

### Objetivo

Entregar CI containerizado reprodutível, validado localmente e posteriormente comprovado no GitHub Actions.

### Dependências

M0-T02 concluída.

### Subtarefas

- `M0-T03A` — Implementar e validar localmente o workflow de CI.
- `M0-T03B` — Verificar execução real no GitHub Actions.

`M0-T03B` depende de `M0-T03A` concluída e de autorização explícita para commit e push.

### Critérios de aceite agregados

- [x] Workflow localmente validado em ambiente Compose isolado.
- [ ] Execução real verde no GitHub Actions registrada com link ou identificador.
- [x] Testes, lint, segurança, specs, autoload, assets e boot falham o pipeline quando falham.
- [x] Aplicação e banco usam exclusivamente a topologia do Dev Container.

---

## M0-T03A — Implementar e validar localmente o workflow de CI

Status: `DONE`

### Objetivo

Criar um workflow GitHub Actions fino e um comando `bin/ci` canônico, executados exclusivamente pelos serviços `app` e `db` do Compose, e comprová-los localmente com projeto e volumes efêmeros.

### Requisitos relacionados

- `OPS-CI-001` a `OPS-CI-004`
- `TEST-000`, `TEST-EVID-001`
- `NFR-MNT-001`, `NFR-MNT-002`

### Dependências

- `M0-T02`

### Dentro do escopo

- `.github/workflows/ci.yml` em `ubuntu-24.04`, permissões mínimas, concorrência e timeout;
- somente `actions/checkout` estável, fixada por SHA completo;
- build e execução pelos serviços do `.devcontainer/compose.yaml`;
- `bin/ci` com specs, dependências, banco test, RSpec, RuboCop, Brakeman, Bundler Audit, Zeitwerk, Tailwind, assets e boot;
- parametrização UID/GID e dependência de sistema mínima para escrita e verificações no container;
- cleanup incondicional no workflow;
- simulação local isolada por project name e volumes novos;
- documentação e evidência real.

### Fora do escopo

- execução remota, commit, push ou alteração de branch protection;
- cache remoto, registry, publicação de imagem, deploy ou secrets de produção;
- Dependabot, cobertura, serviços pagos ou actions adicionais;
- funcionalidade de domínio ou início de M1.

### Critérios de aceite

- [x] `.github/workflows/ci.yml` existe e seu YAML é válido.
- [x] Push para `main`, pull request e `workflow_dispatch` estão configurados; `pull_request_target` não é usado.
- [x] Permissões são `contents: read`; concorrência e timeout estão configurados.
- [x] Runner é `ubuntu-24.04` e actions usam SHA completo de release estável.
- [x] Runner hospeda somente Docker; Ruby e PostgreSQL não são instalados ou duplicados fora do Compose.
- [x] Comandos da aplicação usam `app`; banco usa `db` e hostname interno.
- [x] `bin/ci` existe, é executável, não interativo e interrompe na primeira falha.
- [x] Banco de teste novo é preparado sem tocar no banco development.
- [x] Verificador de specs, RSpec, RuboCop, Brakeman e Bundler Audit passam.
- [x] Zeitwerk, Tailwind, assets e runner de boot passam.
- [x] Cleanup do workflow executa mesmo após falha.
- [x] Simulação completa usa project name/volumes isolados e retorna zero.
- [x] Ambiente local original continua operacional após a simulação.
- [x] README documenta workflow, `bin/ci`, isolamento e limite da validação local.
- [x] `bash -n`, validação estrutural do workflow e `git diff --check` passam.
- [x] Nenhuma funcionalidade de domínio é adicionada.

### Plano técnico

1. Corrigir apenas as dependências sistêmicas necessárias ao CI containerizado e criar `bin/ci`.
2. Validar `bin/ci` no ambiente local existente.
3. Criar workflow fino com action oficial fixada por SHA e cleanup incondicional.
4. Validar sintaxe e invariantes do YAML sem instalar ferramenta global no host.
5. Simular runner limpo com project name, UID/GID e volumes isolados.
6. Confirmar preservação do Compose local e registrar evidências.

### Riscos e casos de borda

- `scripts/check_spec_requirements.sh` requer `rg`, inicialmente ausente na imagem;
- UID/GID do GitHub runner divergirem dos defaults locais;
- bind mount ou bundle volume impedir escrita pelo usuário não root;
- isolamento incompleto reutilizar volumes locais e mascarar banco/gems ausentes;
- YAML válido não equivaler a execução remota verde;
- atualização do advisory database depender de rede;
- build limpo ser demorado sem cache remoto.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bash scripts/check_spec_requirements.sh
docker compose -f .devcontainer/compose.yaml exec app bin/ci
docker compose --project-name company_finance_ci_validation -f .devcontainer/compose.yaml build app
docker compose --project-name company_finance_ci_validation -f .devcontainer/compose.yaml up -d --wait db
docker compose --project-name company_finance_ci_validation -f .devcontainer/compose.yaml run --rm app bin/ci
docker compose --project-name company_finance_ci_validation -f .devcontainer/compose.yaml down --volumes --remove-orphans
bash -n bin/ci .devcontainer/scripts/post-create.sh
bash scripts/check_spec_requirements.sh
git diff --check
```

### Evidência de conclusão

- Baseline: branch `main`, working tree limpa, commit `3230b5a`; `app` ativo e `db` healthy.
- Boot inicial: `CompanyFinance::Application` confirmado dentro de `app`.
- Falha inicial reproduzida: verificador de specs retornou `rg: command not found` dentro de `app`; `ripgrep` deve integrar a imagem para o mesmo comando funcionar no CI.
- `actions/checkout` consultada na API oficial: release `v7.0.0`, publicada, não draft e não prerelease; SHA `9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0`.
- `ripgrep` adicionado à imagem e `bin/ci` criado com shell estrito, etapas legíveis e todas as verificações obrigatórias.
- Build local após adicionar `ripgrep`: sucesso em aproximadamente 74 segundos; `rg 13.0.0` confirmado no container.
- `docker compose ... exec app bin/ci`: sucesso no ambiente existente; 496 requisitos válidos, 2 specs verdes, RuboCop sem offenses, Brakeman sem warnings, Bundler Audit sem vulnerabilidades, Zeitwerk/Tailwind/assets/boot verdes.
- Workflow criado com runner `ubuntu-24.04`, `contents: read`, concorrência, timeout de 30 minutos, checkout v7.0.0 por SHA, UID/GID dinâmicos, serviços Compose e cleanup `always()`.
- `actionlint` não estava disponível; parser YAML executado dentro de `app` confirmou triggers, permissões, concorrência, runner, timeout, SHA de 40 caracteres e cleanup. Busca negativa confirmou ausência de permissões extras, `pull_request_target`, setup Ruby e PostgreSQL duplicado.
- Simulação `company_finance_ci_validation`: build sem cache em aproximadamente 85 segundos; `db` iniciou healthy em volume novo; banco `company_finance_test` inicialmente ausente; usuário `vscode` 1000:1000 escreveu no bind mount.
- `bin/ci` isolado instalou 126 gems no volume novo, criou apenas o banco test e passou todos os checks em aproximadamente 70 segundos.
- Cleanup removeu containers, rede e dois volumes isolados. `finance-manager-dev-app-1` permaneceu ativo e `finance-manager-dev-db-1` permaneceu healthy.
- Teste negativo controlado com `DATABASE_HOST=ci-intentional-invalid-host`: `bin/ci` parou em `db:prepare` e propagou exit code 1.
- Rodada final normal de `bin/ci`: sucesso integral; 2 specs, zero offenses, zero warnings e zero vulnerabilidades.
- Nenhuma instalação de Ruby, Rails, Bundler, gems ou PostgreSQL ocorreu diretamente no host; o workflow também não contém essas instalações.

### Próximo passo

Manter `M0-T03B` como `NOT_STARTED`. Após autorização explícita, fazer commit/push, disparar ou observar o workflow e registrar URL/ID, logs verdes, banco novo e cleanup.

---

## M0-T03B — Verificar execução real no GitHub Actions

Status: `NOT_STARTED`

### Objetivo

Comprovar uma execução remota verde do workflow já validado localmente e registrar evidência verificável.

### Requisitos relacionados

- `OPS-CI-001` a `OPS-CI-004`
- `TEST-EVID-001`

### Dependências

- `M0-T03A`
- commit e push explicitamente autorizados

### Dentro do escopo

- disparar por push, pull request ou `workflow_dispatch`;
- verificar steps, containers, banco novo, cleanup e permissões;
- registrar link ou identificador do run.

### Fora do escopo

- alterar o workflow sem retornar a M0-T03A;
- deploy, publicação de imagem, secrets ou branch protection.

### Critérios de aceite

- [ ] Workflow está presente no repositório remoto.
- [ ] Run real termina verde e possui link ou identificador registrado.
- [ ] Logs confirmam uso de `app`, `db` vazio e cleanup.
- [ ] Nenhuma permissão ou secret adicional foi concedido.

### Plano técnico

1. Obter autorização para commit e push.
2. Publicar o workflow e disparar uma execução.
3. Inspecionar todos os steps e registrar evidência remota.

### Riscos e casos de borda

- permissões para commit/push não estão concedidas nesta sessão;
- diferenças reais do GitHub-hosted runner só aparecem remotamente.

### Verificação obrigatória

```bash
# Inspecionar no GitHub Actions o run disparado e registrar URL/ID e conclusão.
```

### Evidência de conclusão

Não iniciada: workflow ainda não foi commitado nem enviado ao GitHub.

### Próximo passo

Após M0-T03A, solicitar autorização para commit/push e então verificar um run real; não inferir sucesso remoto da simulação local.

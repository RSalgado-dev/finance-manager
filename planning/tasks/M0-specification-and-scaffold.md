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

Status: `IN_PROGRESS`

### Objetivo

Criar a aplicação Rails no repositório com PostgreSQL e escolhas técnicas aprovadas.

### Dependências

M0-T01; agregadora de M0-T02A e M0-T02B.

### Subtarefas

- `M0-T02A` — Construir e validar o Dev Container.
- `M0-T02B` — Inicializar a aplicação Rails dentro do Dev Container.

`M0-T02B` depende de `M0-T02A` concluída. Nenhum comando da stack Ruby pode ser executado diretamente no host.

### Critérios de aceite

- [ ] Aplicação inicia.
- [ ] Banco PostgreSQL conecta.
- [ ] Test framework funciona.
- [ ] UUID padrão definido.
- [ ] Locale e timezone base configurados.
- [ ] README contém setup inicial.
- [ ] `.env.example` existe.
- [ ] Baseline de testes, lint e segurança registrado.

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

Status: `NOT_STARTED`

### Objetivo

Gerar e configurar o scaffold Rails exclusivamente dentro do Dev Container validado.

### Dependências

M0-T02A concluída.

### Restrição

Não iniciar nesta sessão.

---

## M0-T03 — Configurar CI inicial

Status: `NOT_STARTED`

### Dependências

M0-T02B.

### Critérios de aceite

- [ ] GitHub Actions executa testes.
- [ ] RuboCop executa.
- [ ] Brakeman executa.
- [ ] Bundler Audit executa.
- [ ] Pipeline falha corretamente.

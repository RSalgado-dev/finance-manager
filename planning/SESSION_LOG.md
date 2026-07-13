# Histórico de sessões

Acrescente novas sessões no topo. Não reescreva entradas antigas, salvo correção factual explícita.

## 2026-07-12 22:11 — Reconciliação de M1-T05

### Objetivo

Determinar se M1-T05 ainda possuía trabalho válido ou duplicava a infraestrutura de desenvolvimento entregue por M0-T02A, sem alterar Docker ou iniciar M2.

### Estado inicial

Branch `main`, commit base `8657cdd`, com alterações não commitadas acumuladas de M1 preservadas. M0 `VERIFIED`; M1 `IN_PROGRESS`; M1-T01..T04 `DONE`; M1-T05 `NOT_STARTED`. Compose normal com `app` ativo e `db` healthy.

### Análise e decisão

- a definição residual de M1-T05 era adaptar comandos/serviços do Dev Container de M0-T02A à aplicação inicializada;
- M0-T02A já entregou Dockerfile, Compose, runtime não root, PostgreSQL, volumes, healthcheck e pós-criação;
- M0-T02B já integrou o scaffold ao mesmo ambiente e reconstruiu/validou a imagem;
- a revisão independente de M0 revalidou Compose isolado, build, runtime, banco, CI e cleanup antes de promover M0;
- portanto M1-T05 foi encerrada como `DONE / SUPERSEDED_BY_M0-T02A`, sem nova implementação;
- o worker citado por `OPS-LOCAL-002` permanece `SPECIFIED` para uma tarefa futura ligada a workload assíncrono concreto; não foi transformado em novo escopo de M1-T05;
- revisão documental preliminar confirmou M1-T01..T04 como `DONE`, sem substituir revisão técnica independente.

### Arquivos alterados

- `planning/tasks/M1-foundation.md`;
- `planning/ROADMAP.md`;
- `planning/TRACEABILITY.md`;
- `planning/SESSION_LOG.md`;
- `planning/CURRENT.md`.

Nenhum arquivo da aplicação, Gemfile/lock, migration, especificação normativa, Dockerfile, Compose, Dev Container, workflow ou tarefa de M2 foi alterado.

### Verificações

| Verificação | Resultado |
|---|---|
| protocolo Git | branch `main`, commit base `8657cdd`, working tree anterior preservado |
| Compose `ps` | `app` ativo; `db` healthy |
| inventário Docker | somente `.devcontainer/Dockerfile` e `.devcontainer/compose.yaml` até profundidade 3 |
| evidência M0-T02A/M0 | implementação, integração e revisão independente localizadas e cruzadas |
| cobertura M1 | T01..T04 documentalmente `DONE`; T05 superseded |
| M2 | nenhum status `IN_PROGRESS`/`DONE`; milestone permanece `NOT_STARTED` |
| verificador normativo | 15 specs/496 requisitos; zero duplicidades, referências ausentes, linhas sem ID ou links quebrados |
| Compose `config` | válido; serviços canônicos `app`/`db`, volumes e healthcheck preservados |
| Compose `ps` final | `app` ativo; `db` healthy |
| hashes protegidos | Dockerfile, Compose, devcontainer.json, post-create, Gemfile e lockfile inalterados durante a sessão |
| migrations | nenhum arquivo novo |
| `git diff --check` | aprovado |

### Estado final

M0 permanece `VERIFIED`. M1 está `DONE` e `READY_FOR_REVIEW`, ainda não `VERIFIED`. M1-T05 não representa nova implementação. M2 permanece `NOT_STARTED`.

### Handoff

Próxima ação exata: executar uma revisão independente do milestone M1 antes de iniciar M2.

## 2026-07-12 22:00 — M1-T04

### Objetivo

Detalhar e entregar infraestrutura mínima de paginação server-side e filtros `GET`, sem antecipar models, migrations ou filtros financeiros.

### Estado inicial

Branch `main`, commit base `8657cdd`, com alterações não commitadas de M1-T02/M1-T03 preservadas. M0 `VERIFIED`, M1 `IN_PROGRESS`, M1-T01..T03 `DONE` e M1-T04 `NOT_STARTED`. Pagy/concorrentes, models/migrations de domínio e filtros reais estavam ausentes.

### Trabalho realizado

- M1-T04 detalhada e marcada `IN_PROGRESS` antes do Gemfile;
- Pagy `~> 43.6` instalado como 43.6.0 e documentação/código empacotados inspecionados;
- `Pagy::Method` integrado explicitamente, com `Pagy::OPTIONS`, limite fixo 25 e Rails I18n pt-BR;
- links recebem apenas parâmetros permitidos; `limit` do cliente fica desabilitado e não há cópia indiscriminada da request;
- partial acessível/responsivo e `filter_form_with` GET criados, sem JavaScript ou conhecimento de domínio;
- rota/controller/coleção estática existem somente em teste;
- specs helper/view/request/system cobrem páginas, metadados, inválidos, allowlist, filtros aninhados, teclado/foco, Turbo e 360 px;
- `docs/pagination-and-filters.md` e referência curta no README criados;
- nenhum model, migration, query/filter real, tenant, policy, autenticação ou tarefa posterior foi implementado.

### Decisões

- offset é o padrão inicial; keyset/countish/countless/cursor/infinite scroll permanecem adiados;
- `limit` do cliente não foi habilitado porque `max_limit` da versão não normaliza negativos antes da validação; limite permanece fixo em 25 e eventual teto será 100;
- página malformada/não positiva usa a normalização oficial para 1; página acima da última retorna vazio controlado;
- query string é preservada somente a partir de `ActionController::Parameters` permitidos por controller;
- ordem futura: tenant → autorização → filtros → ordenação estável → paginação → apresentação.

### Verificações

| Verificação | Resultado |
|---|---|
| Pagy | 43.6.0; API/arquivos empacotados inspecionados |
| RSpec | 50 exemplos, 0 falhas |
| system spec após assets | Chromium 4 exemplos, 0 falhas |
| RuboCop | 44 arquivos, 0 offenses |
| Brakeman 8.0.5 | 0 erros, 0 security warnings |
| Bundler Audit | 1.200 advisories, 0 vulnerabilidades |
| Zeitwerk | aprovado |
| Tailwind/assets | Tailwind 4.3.2 e precompile aprovados |
| `bin/ci` | sucesso integral |
| rotas de produção | zero rotas `__test__` |
| APIs/gems inseguras | nenhuma API Pagy legada, concorrente, `params.to_unsafe_h`, `unscoped` ou interpolação SQL |
| migrations/models de domínio | nenhum arquivo criado |
| specs normativas | 15 specs, 496 requisitos, zero falhas estruturais |
| `git diff --check` | aprovado |

### Estado final

M1 permanece `IN_PROGRESS`; M1-T04 está `DONE`; M1-T05 permanece `NOT_STARTED`. Alterações anteriores foram preservadas. Nenhum commit, push, merge ou operação destrutiva foi realizado.

### Handoff

Próxima ação exata: em nova sessão, detalhar M1-T05 pelo template antes de qualquer implementação.

## 2026-07-12 09:42 — M1-T03

### Objetivo

Definir convenções mínimas de services, queries e policies sem implementar domínio ou abstrações genéricas.

### Estado inicial

Branch `main`, commit base `8657cdd`, com alterações não commitadas de M1-T02 preservadas. M0 `VERIFIED`, M1 `IN_PROGRESS`, M1-T01/M1-T02 `DONE`, M1-T03/M1-T04 `NOT_STARTED`. Pundit, services, queries, policies, models e migrations de domínio ausentes; baseline 32 specs/0 falhas.

### Trabalho realizado

- M1-T03 detalhada e marcada `IN_PROGRESS` antes de qualquer estrutura;
- seis diretórios canônicos criados somente com `.keep`;
- runner confirmou autoload automático de `app/services`, `app/queries` e `app/policies`;
- `docs/code-organization.md` criado com responsabilidades, contratos, nomes, transações, tenant, auditoria, jobs, erros, testes, anti-patterns e decisões adiadas;
- `AGENTS.md` recebeu quatro regras permanentes concisas;
- README passou a referenciar o documento;
- nenhuma classe Ruby, gem, policy, service/query de domínio, model, migration ou funcionalidade de M1-T04 foi criada.

### Decisões

- services futuros são classes simples com dependências explícitas; não há base genérica ou Result object;
- queries recebem relation autorizada e tenant-scoped; não começam por `.all` nem por `Current.company`;
- policies futuras dependem da instalação de Pundit no milestone de autorização;
- policy autoriza, service valida/coordena e constraints garantem integridade;
- erros específicos serão criados próximos aos casos concretos, sem `ApplicationError` vazio;
- transação pertence à operação e inclui auditoria crítica quando exigida.

### Verificações

| Verificação | Resultado |
|---|---|
| autoload dirs | services/queries/policies reconhecidos automaticamente |
| Zeitwerk | aprovado |
| RSpec | 32 exemplos, 0 falhas |
| RuboCop | 39 arquivos, 0 offenses |
| Brakeman 8.0.5 | 0 erros, 0 security warnings |
| Bundler Audit | 1.200 advisories, 0 vulnerabilidades |
| Tailwind/assets | Tailwind 4.3.2 e precompile aprovados |
| `bin/ci` | sucesso integral |
| busca de abstrações | nenhuma ocorrência em `*.rb` |
| gems/migrations | nenhum diff de dependências; nenhuma migration |
| specs normativas | 15 specs, 496 requisitos, zero falhas estruturais |
| `git diff --check` | aprovado |

### Estado final

M1 permanece `IN_PROGRESS`; M1-T03 está `DONE`; M1-T04/M1-T05 permanecem `NOT_STARTED`. Alterações de M1-T02 foram preservadas. Nenhum commit ou push foi realizado.

### Handoff

Próxima ação exata: em nova sessão, detalhar M1-T04 pelo template antes de qualquer implementação.

## 2026-07-12 09:28 — M1-T02

### Objetivo

Detalhar e executar `CurrentAttributes` e o contexto mínimo de request sem implementar autenticação, tenant ou models de domínio.

### Estado inicial

Branch `main`, commit `8657cdd`, working tree limpa; M0 `VERIFIED`, M1 `IN_PROGRESS`, M1-T01 `DONE` e M1-T02/M1-T03 `NOT_STARTED`. Compose com `app` ativo e `db` healthy; 4 request specs/0 falhas no baseline.

### Trabalho realizado

- M1-T02 detalhada e marcada `IN_PROGRESS` antes do código;
- `Current < ActiveSupport::CurrentAttributes` criado com `user`, `company`, `membership`, `request_id`, `ip_address` e `user_agent`;
- `RequestContext` criado com `around_action`, `Current.set`, `request.remote_ip` e reset explícito antes/depois via `ensure`;
- `ApplicationController` integrado sem autenticação ou tenant resolution;
- controller e rotas auxiliares limitados a teste, sem retornar metadados;
- specs unitárias/request cobrem reset, bloco, exceção, threads, requests sequenciais e cleanup;
- ciclo de vida, privacidade, proxies, logging e contratos futuros documentados;
- nenhuma gem, migration, model de domínio, job ou endpoint produtivo adicionado.

### Verificações

| Verificação | Resultado |
|---|---|
| RSpec | 32 exemplos, 0 falhas |
| RuboCop | 39 arquivos, 0 offenses |
| Brakeman 8.0.5 | 0 erros, 0 security warnings |
| Bundler Audit | 1.200 advisories, 0 vulnerabilidades |
| Zeitwerk | aprovado |
| Tailwind/assets | Tailwind 4.3.2 e precompile aprovados |
| runners | herança de `Current` e log tag `:request_id` aprovadas |
| `bin/ci` | sucesso integral |
| rotas de produção | `__test__/request_context` ausente |
| gems/migrations | nenhum diff no Gemfile/lock; `db/migrate` vazio |
| specs normativas | 15 specs, 496 requisitos, zero falhas estruturais |
| `git diff --check` | aprovado |

### Falha corrigida

A primeira expectativa assumia que `Current.attributes` listaria atributos nulos; Rails 8 retorna `{}` antes de atribuição. A spec passou a testar os seis leitores diretamente e terminou verde.

### Estado final

M1 permanece `IN_PROGRESS`; M1-T02 está `DONE`; M1-T03 a M1-T05 permanecem `NOT_STARTED`. Nenhum commit ou push foi realizado.

### Handoff

Próxima ação exata: em nova sessão, detalhar M1-T03 pelo template antes de qualquer implementação.

## 2026-07-12 09:15 — M1-T01

### Objetivo

Detalhar e executar a fundação visual mínima, sem iniciar M1-T02 ou implementar autenticação, tenancy ou domínio.

### Estado inicial

Branch `main`, M0 `VERIFIED`, M1 `NOT_STARTED`, M1-T01 ainda apenas como título e cinco arquivos documentais modificados pela revisão de M0. Compose normal com `app` ativo e `db` healthy; baseline com 2 specs/0 falhas e Tailwind aprovado.

### Trabalho realizado

- M1-T01 detalhada pelo template e marcada `IN_PROGRESS` antes do código; M1 marcado `IN_PROGRESS`;
- layouts compostos `application`, `public`, `platform`, `tenant` e `print` criados sem autenticação ou contexto de empresa;
- rota e página institucional `/` criadas em português, mantendo `/up` e sem links futuros;
- navegação mínima, flash, cabeçalho, botões, cards, badges, estado vazio, tabela responsiva e erros de formulário implementados com ERB/helpers/Tailwind;
- foco, contraste, redução de movimento, responsividade e mídia de impressão tratados;
- documentação criada em `docs/ui-foundation.md`;
- specs request, helper, view e system adicionadas; Chromium validou 360, 768 e 1280 px;
- nenhuma gem, model, migration, rota `/platform`/tenant ou funcionalidade de M1-T02+ adicionada.

### Verificações

| Verificação | Resultado |
|---|---|
| RSpec | 23 exemplos, 0 falhas |
| RuboCop | 34 arquivos, 0 offenses |
| Brakeman 8.0.5 | 0 erros, 0 security warnings |
| Bundler Audit | 1.200 advisories, 0 vulnerabilidades |
| Zeitwerk | aprovado |
| Tailwind/assets | Tailwind 4.3.2 e precompile aprovados |
| `bin/ci` | sucesso integral após a última alteração de código |
| HTTP real | `/` e `/up` retornaram 200 dentro do container |
| specs normativas | 15 specs, 496 requisitos, zero falhas estruturais |
| `git diff --check` | aprovado |

### Falhas corrigidas

- primeira rodada dos componentes: quatro falhas de expectativa, helper e tradução; todas corrigidas e conjunto focado terminou 13/0;
- system spec detectou overflow aparente em 360 px porque o ambiente de teste servia o CSS precompilado anterior; após o `assets:precompile` obrigatório, layouts/system terminaram 8/0 nas três larguras.

### Estado final

M1 permanece `IN_PROGRESS`; M1-T01 está `DONE`; M1-T02 a M1-T05 permanecem `NOT_STARTED`. Alterações anteriores de M0 foram preservadas. Nenhum commit ou push foi realizado.

### Handoff

Próxima ação exata: em nova sessão, detalhar M1-T02 com o template antes de qualquer implementação.

## 2026-07-12 07:54 — Verificação independente de M0

### Objetivo

Revisar M0 de forma independente e decidir sua promoção, sem implementar M1 ou funcionalidades de domínio.

### Estado inicial

Branch `main`, `HEAD` e `origin/main` locais em `a1cb0e7`; cinco arquivos de planejamento já modificados pela sessão de M0-T03B. M0 estava `IN_PROGRESS`; M0-T01, M0-T02A, M0-T02B, M0-T02, M0-T03A, M0-T03B e M0-T03 estavam `DONE`; M1 não iniciado.

### Trabalho realizado

- documentos obrigatórios, specs normativas, cobertura histórica, riscos, questões, propostas e quatro ADRs aceitos relidos e cruzados;
- scaffold, gems, Rails, RSpec, frontend mínimo, Solid Queue, Dev Container, workflow e `bin/ci` inspecionados sem confiar somente na evidência anterior;
- projeto Compose `company_finance_m0_review` criado com volumes novos, validado e removido ao final;
- banco development/test recriado duas vezes, incluindo prova explícita de zero bancos Rails antes da segunda criação;
- evidência remota consultada novamente pela API pública do GitHub;
- M0 promovido a `VERIFIED`; nenhuma tarefa reaberta e nenhuma funcionalidade de M1 iniciada.

### Verificações

| Verificação | Resultado |
|---|---|
| `scripts/check_spec_requirements.sh` | 15 specs, 496 requisitos, zero duplicidades, referências inexistentes, linhas normativas sem ID ou links quebrados |
| Compose isolado `config`/`build`/`up --wait` | sucesso; `db` healthy, sem portas publicadas, privilégio ou Docker socket |
| runtime e conexão | Ruby 3.4.10, Bundler 2.7.2, Rails 8.1.3 após instalação, psql 15.18; `vscode` 1000:1000; `SELECT` por `db` aprovado |
| pós-criação | duas execuções consecutivas aprovadas |
| banco vazio e boot | development/test ausentes e recriados; módulo, locale, timezone, UUID, semana, routes e Zeitwerk aprovados |
| RSpec | 2 exemplos, 0 falhas |
| RuboCop | 28 arquivos, 0 offenses |
| Brakeman 8.0.5 | 0 erros, 0 warnings |
| Bundler Audit | advisory DB com 1.200 advisories; 0 vulnerabilidades |
| importmap/Tailwind/assets | válidos; Tailwind 4.3.2 e precompile aprovados |
| `/up` | requisição HTTP real retornou 200 |
| `bin/ci` isolado | sucesso integral |
| workflow | YAML válido; triggers, permissões, concorrência, timeout, SHA, Compose e cleanup aprovados |
| GitHub API | run `29173802602` e job `86599229166` `success`; runner `ubuntu-24.04`; todos os steps `success` |
| logs remotos compactados | HTTP 403 sem autenticação; resultados internos detalhados atribuídos à evidência versionada do responsável |
| cleanup | recursos isolados removidos; ambiente normal permaneceu com `app` ativo e `db` healthy |
| shells / diff | todos os scripts passaram em `bash -n`; `git diff --check` aprovado |

### Falha intermediária analisada

No volume de gems recém-criado, `rails --version` antes de `bundle install` falhou porque o CLI detectou a aplicação e tentou materializar o bundle ausente. O fluxo documentado de ambiente novo instalou 126 gems; o mesmo comando passou depois, o pós-criação foi idempotente e o `bin/ci` instalaria gems quando ausentes. Não houve dependência de estado residual nem critério final não atendido.

### Estado final

M0 `VERIFIED`. Nenhum código, Gemfile, migration, requisito, Dev Container, workflow ou script de CI foi alterado; somente os registros obrigatórios de planejamento foram atualizados.

### Handoff

Próxima ação exata: em nova sessão, detalhar M1-T01 com o template e somente então iniciar M1.

## 2026-07-11 21:32 — M0-T03B

### Objetivo

Verificar documentalmente a execução real do CI no GitHub Actions e concluir M0-T03 sem alterar código ou workflow.

### Estado inicial

Branch `main`, working tree limpa, `HEAD` e `origin/main` em `a1cb0e7`. M0-T03A estava `DONE`, M0-T03B `NOT_STARTED` e M0-T03 `IN_PROGRESS`.

### Evidência remota

- workflow e commit foram publicados manualmente pelo responsável; o Codex não fez commit, push ou merge;
- run `29173802602`: https://github.com/RSalgado-dev/finance-manager/actions/runs/29173802602;
- SHA `a1cb0e7554c69ce3ee6dbe03c7bb4f17e6de4950`, evento `push`, branch `main`, runner `ubuntu-24.04`;
- execução de `2026-07-12T00:29:56Z` a `2026-07-12T00:32:01Z`, conclusão `success`;
- job `86599229166` e todas as etapas concluíram com sucesso;
- banco test criado do zero; RSpec 2/0; RuboCop 28/0; Brakeman 8.0.5 sem erros ou warnings; Bundler Audit sem vulnerabilidades; Zeitwerk, Tailwind, assets e boot aprovados;
- `CI local concluído com sucesso.` foi interpretada corretamente como saída padronizada do `bin/ci` executado remotamente;
- cleanup `down --volumes --remove-orphans`, protegido por `if: always()`, foi confirmado como `success` pela API de jobs.

### Estado final

M0-T03B e M0-T03 marcadas `DONE`. O milestone M0 permanece `IN_PROGRESS`, pronto para revisão independente e ainda não `VERIFIED`.

### Verificações documentais

- histórico local e identidade SHA/branch comparados com o run remoto;
- GitHub Actions runs/jobs consultados pela API oficial;
- `bash scripts/check_spec_requirements.sh`, `git diff --check` e inspeção do working tree executados ao final;
- nenhuma alteração em aplicação, Gemfile, migrations, Dev Container, workflow ou scripts de CI.

### Handoff

Próxima ação exata: executar uma sessão independente de revisão do milestone M0 antes de iniciar M1.

## 2026-07-11 21:27 — M0-T03A

### Objetivo

Implementar e validar localmente o CI inicial usando exclusivamente o Dev Container e um Compose isolado.

### Estado inicial

Branch `main`, working tree limpa, commit `3230b5a`. M0-T02 estava `DONE`; M0-T03 estava `NOT_STARTED`; `app` ativo, `db` healthy, sem `.github/` e sem `bin/ci`.

### Trabalho realizado

- M0-T03 subdividida em M0-T03A e M0-T03B; somente M0-T03A foi executada;
- `ripgrep` adicionado à imagem após falha real do verificador normativo no container;
- `bin/ci` criado com shell estrito e sequência canônica completa;
- workflow criado para `ubuntu-24.04`, usando somente checkout oficial e Compose;
- checkout v7.0.0 fixado pelo SHA `9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0`;
- UID/GID do runner parametrizados, mantendo `app` não root;
- workflow documentado sem cache, deploy, registry, secrets ou publicação de imagem;
- M0-T03A marcada `DONE`; M0-T03B e agregadora M0-T03 permanecem pendentes de execução remota.

### Verificações

| Verificação | Resultado |
|---|---|
| build local com `ripgrep` | sucesso; aproximadamente 74 s |
| `docker compose ... exec app bin/ci` | sucesso integral |
| parser YAML e invariantes | sucesso; `actionlint` indisponível |
| build isolado `--no-cache` | sucesso; aproximadamente 85 s |
| banco isolado antes do CI | healthy; `company_finance_test` ausente |
| usuário/permissões | `vscode` 1000:1000, workspace gravável |
| `bin/ci` isolado | instalou 126 gems, criou test DB, passou em aproximadamente 70 s |
| RSpec | 2 exemplos, 0 falhas |
| RuboCop | 28 arquivos, 0 offenses |
| Brakeman | 0 warnings |
| Bundler Audit | advisory database atualizado, 0 vulnerabilidades |
| specs/ Zeitwerk / Tailwind / assets / boot | sucesso |
| teste negativo | host de banco inválido; exit code 1 propagado |
| cleanup isolado | containers, rede e volumes removidos |
| ambiente local após cleanup | app ativo; db healthy |

### Limitações e handoff

Não houve execução real no GitHub Actions, commit ou push. Próxima ação exata: obter autorização explícita, publicar o workflow, disparar/observar um run, inspecionar logs e registrar URL ou ID como evidência de M0-T03B. Não iniciar M1 antes disso.

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

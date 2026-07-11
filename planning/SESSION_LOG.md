# Histórico de sessões

Acrescente novas sessões no topo. Não reescreva entradas antigas, salvo correção factual explícita.

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

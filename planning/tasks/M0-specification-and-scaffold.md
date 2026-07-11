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

Status: `NOT_STARTED`

### Objetivo

Criar a aplicação Rails no repositório com PostgreSQL e escolhas técnicas aprovadas.

### Dependências

M0-T01.

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

## M0-T03 — Configurar CI inicial

Status: `NOT_STARTED`

### Dependências

M0-T02.

### Critérios de aceite

- [ ] GitHub Actions executa testes.
- [ ] RuboCop executa.
- [ ] Brakeman executa.
- [ ] Bundler Audit executa.
- [ ] Pipeline falha corretamente.

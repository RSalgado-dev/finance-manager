# Estado atual

Atualizado em: `2026-07-11 17:43 America/Sao_Paulo`

## Estado do repositório

- Milestone ativo: `M0`
- Tarefa ativa: nenhuma; `M0-T01` concluída, `M0-T02` ainda `NOT_STARTED`
- Estado global: `M0_T01_DONE`
- Branch: `main` (acompanhando `origin/main`)
- Working tree inicial: limpa
- Último commit relevante: `3b8c3c750bb7a2c7d38c85c5fc4cd0fb1844a205` (`feat: add initial specifications and planning documents for cash management, expenses, reporting, audit, security, deployment, and quality assurance`)

## O que já existe

- Baseline normativa revisada, com 496 requisitos identificados.
- Decisões aceitas de tenancy, contexto por path, integridade composta e auditoria transacional.
- Máquinas de estado, matriz de autorização, cobertura de origem, roadmap e protocolo entre sessões.
- Aplicação ainda não inicializada.

## Último trabalho realizado

`M0-T01` concluída com 7/7 critérios satisfeitos. Decisões de estados, regimes, autorização, tenancy, convites, auditoria, divergências, IDs, roadmap e origem foram aplicadas. ADR-0003 e ADR-0004 estão aceitos. A revisão pós-alteração e a checagem automatizada não encontraram contradição material ou defeito documental conhecido.

## Próxima ação exata

1. Em nova sessão, executar o protocolo de início e confirmar o working tree documental ainda não commitado.
2. Detalhar `M0-T02` com `planning/templates/TASK_TEMPLATE.md`, incluindo versões e comandos de baseline.
3. Somente após esse detalhamento, mudar `M0-T02` para `IN_PROGRESS` e iniciar o scaffold Rails.
4. Não iniciar outro milestone antes de concluir M0.

## Arquivos prioritários

- `AGENTS.md`
- `specs/README.md`
- `planning/tasks/M0-specification-and-scaffold.md`
- `planning/OPEN_QUESTIONS.md`
- `planning/decisions/ADR-0001-shared-database-tenancy.md`
- `planning/decisions/ADR-0002-path-based-company-context.md`
- `planning/decisions/ADR-0003-composite-tenant-foreign-keys.md`
- `planning/decisions/ADR-0004-transactional-critical-audit.md`
- `planning/PROPOSALS.md`
- `planning/SOURCE_COVERAGE.md`
- `specs/00-product/source-brief.md`
- `specs/10-architecture/authorization-matrix.md`
- `scripts/check_spec_requirements.sh`

## Verificações conhecidas

- `git status --short --branch`: branch `main`, working tree inicial limpa.
- Inventário com `rg --files -uu` e `find`: somente documentação e metadados; aplicação Rails ausente.
- Leitura integral dos documentos obrigatórios, de todos os arquivos em `specs/` e das tarefas do roadmap.
- `bash scripts/check_spec_requirements.sh`: 15 specs, 496 IDs, zero duplicidades, referências inexistentes, linhas normativas sem ID e referências documentais quebradas.
- `bash -n scripts/check_spec_requirements.sh`: sucesso.
- Leitura integral pós-alteração de todas as specs concluída.
- `git diff --check`: sucesso no baseline e após as alterações documentais.
- Estrutura Rails continua ausente.
- Nenhuma verificação de código é aplicável porque o projeto ainda não foi inicializado.

## Bloqueios

Nenhum bloqueio para iniciar o planejamento de `M0-T02` em nova sessão. `Q-002`, `Q-003`, `Q-004` e `Q-015` são não bloqueantes para o scaffold; `Q-015` bloqueia apenas o detalhamento/início de `M5-T05`.

## Decisões pendentes

Questões futuras não bloqueantes: `Q-002` (turnos), `Q-003` (retenção), `Q-004` (limites de upload) e `Q-015` (cardinalidade/descarte de comprovantes).

## Alterações não commitadas

- planejamento: `CURRENT`, questões, propostas, riscos, roadmap, log, rastreabilidade, cobertura e tarefas M0–M9 afetadas;
- decisões: ADR-0003 e ADR-0004 novos e aceitos;
- specs: produto, arquitetura, autorização, domínios, testes, operação e índice;
- novos documentos: source brief histórico e matriz normativa de autorização;
- verificação: `scripts/check_spec_requirements.sh`.

Consultar `git status --short` para a lista exata. Nenhum commit foi criado.

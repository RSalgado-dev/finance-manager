# Cobertura do brief de origem

Baseline aprovada em: 2026-07-11.

O brief histórico reconstruído em `specs/00-product/source-brief.md` não é fonte normativa. A coluna de requisitos aponta para a baseline normativa vigente.

| Área principal | Arquivo normativo | Requisitos | Cobertura | Lacunas conhecidas |
|---|---|---|---|---|
| Visão, atores e escopo | `specs/00-product/product-spec.md` | `PRD-001`–`PRD-008`, `PRD-ACTOR-*`, `PRD-SCOPE-*`, `PRD-101`–`PRD-112` | COVERED | nenhuma material |
| Arquitetura e stack | `specs/10-architecture/system-architecture.md` | `ARCH-001`–`ARCH-043`, `ARCH-DESIGN-*` | COVERED | versões exatas serão escolhidas em M0-T02/M1 |
| Identidade, empresas e convites | `specs/20-domains/companies-and-users.md` | `USR-*`, `INV-*` | COVERED | retenção de tokens segue política operacional futura |
| Tenancy e integridade | arquitetura, modelo de dados e ADR-0001/0002/0003 | `TEN-*`, `ARCH-DATA-*`, `DATA-*`, `TEST-TEN-*` | COVERED | implementação e testes aguardam milestones de código |
| Autenticação e autorização | segurança e matriz de autorização | `AUTH-*`, `AUTHZ-*`, `SEC-*` | COVERED | nenhuma material conhecida |
| Caixas, fechamentos e movimentos | `specs/20-domains/cash-management.md` | `CASH-*`, `CASH-FORMULA-*`, `CASH-STATE-*`, `CASH-EDIT-*` | COVERED | cadastro de turnos permanece aberto em `Q-002` |
| Despesas, categorias e fornecedores | `specs/20-domains/expenses.md` | `EXP-*`, `EXP-STATE-*`, `EXP-EDIT-*` | COVERED | nenhuma material conhecida |
| Comprovantes privados | despesas, segurança e modelo de dados | `EXP-040`–`EXP-045`, `SEC-009`–`SEC-011`, `DATA-STORAGE-*` | PARTIAL | cardinalidade/ciclo de descarte em `Q-015`; MIME/tamanho em `Q-004` |
| Dashboard e relatórios | `specs/20-domains/dashboard-and-reporting.md` | `REP-*`, `REP-DASH-*`, `REP-REPORT-*` | COVERED | nenhuma material conhecida |
| Plataforma e auditoria | plataforma/auditoria, matriz e ADR-0004 | `PLAT-*`, `AUD-*`, `AUTHZ-063`–`AUTHZ-066` | COVERED | retenção em `Q-003` |
| Qualidade e testes | requisitos não funcionais e estratégia de testes | `NFR-*`, `TEST-*` | COVERED | execução depende da aplicação futura |
| Desenvolvimento e CI | `specs/40-operations/development-and-ci.md` | `OPS-LOCAL-*`, `OPS-DEV-*`, `OPS-CI-*` | COVERED | implementação futura |
| Deploy e operação | `specs/40-operations/deployment.md` | `OPS-DEP-*` | COVERED | provedor final pode ser Render ou equivalente |

## Regra de manutenção

Toda nova área normativa deve atualizar esta matriz, a tarefa responsável e `planning/TRACEABILITY.md`. Uma lacuna `PARTIAL` não invalida a baseline quando está registrada como questão não bloqueante e não produz contradição material nas regras já aprovadas.

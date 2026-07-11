# Índice das especificações

## Objetivo

Este diretório contém a especificação durável do sistema. O Codex deve consultá-lo por referência, não carregar todos os arquivos indiscriminadamente.

O `AGENTS.md` define como trabalhar. `planning/` define o que fazer agora. `specs/` define o que o produto deve ser.

## Ordem recomendada de leitura

1. `00-product/product-spec.md`
2. `00-product/glossary.md`
3. `10-architecture/system-architecture.md`
4. `10-architecture/data-model.md`
5. `10-architecture/security-and-authorization.md`
6. `10-architecture/authorization-matrix.md`
7. arquivo do domínio relacionado à tarefa
8. requisitos de qualidade e operação relacionados

## Mapa de arquivos

### Produto

- `00-product/source-brief.md`: reconstrução histórica e não normativa da intenção original.
- `00-product/product-spec.md`: visão, atores, escopo e exclusões.
- `00-product/glossary.md`: vocabulário canônico.

### Arquitetura

- `10-architecture/system-architecture.md`: stack, monólito, tenancy e padrões.
- `10-architecture/data-model.md`: entidades e restrições principais.
- `10-architecture/security-and-authorization.md`: autenticação, papéis e controles.
- `10-architecture/authorization-matrix.md`: permissões normativas por recurso, ação, estado e ator.

### Domínios

- `20-domains/companies-and-users.md`
- `20-domains/cash-management.md`
- `20-domains/expenses.md`
- `20-domains/dashboard-and-reporting.md`
- `20-domains/platform-and-audit.md`

### Qualidade

- `30-quality/non-functional-requirements.md`
- `30-quality/test-strategy.md`

### Operação

- `40-operations/development-and-ci.md`
- `40-operations/deployment.md`

## Identificadores

- `PRD-*`: produto.
- `ARCH-*`: arquitetura.
- `SEC-*`: segurança.
- `AUTH-*`: autenticação e autorização.
- `AUTHZ-*`: matriz normativa de autorização.
- `INV-*`: convites de empresa.
- `DATA-*`: contratos lógicos de entidades e constraints.
- `TEN-*`: multi-tenancy.
- `USR-*`: usuários e empresas.
- `CASH-*`: caixas e fechamentos.
- `EXP-*`: despesas.
- `REP-*`: dashboards e relatórios.
- `PLAT-*`: painel da plataforma.
- `AUD-*`: auditoria.
- `NFR-*`: requisitos não funcionais.
- `TEST-*`: testes.
- `OPS-*`: operação e deploy.
- `PRD-ACTOR-*`, `PRD-SCOPE-*`, `PRD-SUCCESS-*`: atores, escopo e aceite do produto.
- `CASH-FORMULA-*`, `CASH-STATE-*`, `CASH-EDIT-*`: fórmulas, transições e edição de fechamento.
- `EXP-STATE-*`, `EXP-EDIT-*`: transições e edição de despesas.
- `REP-DASH-*`, `REP-REPORT-*`: dashboard e contratos de relatórios.
- `REP-FORMULA-*`: fórmulas financeiras de relatórios.
- `TEST-SYS-*`, `TEST-EVID-*`, `TEST-AUD-*`, `TEST-REQ-*`: cenários e evidências de teste.
- `OPS-LOCAL-*`: ambiente local.

Os identificadores não devem ser renumerados após uso. Requisitos removidos devem ser marcados como `DEPRECATED`, com referência à decisão correspondente.

## Controle de mudança

Mudanças semânticas devem:

1. informar quais requisitos foram adicionados, alterados ou removidos;
2. registrar uma proposta ou ADR;
3. atualizar tarefas e rastreabilidade;
4. incluir data e justificativa no histórico Git.

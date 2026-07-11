# Arquitetura do sistema

## Estilo arquitetural

- `ARCH-001 MUST` Usar monólito modular Ruby on Rails.
- `ARCH-002 MUST` Usar PostgreSQL.
- `ARCH-003 MUST` Usar renderização server-side com Hotwire, Turbo e Stimulus.
- `ARCH-004 MUST` Usar Tailwind CSS.
- `ARCH-005 MUST` Evitar frontend e backend separados.
- `ARCH-006 MUST` Usar Active Storage para anexos.
- `ARCH-007 MUST` Usar Solid Queue para tarefas assíncronas.
- `ARCH-008 SHOULD` Manter controllers pequenos e lógica de domínio explícita.

Versões exatas devem ser escolhidas no milestone de fundação, verificadas por compatibilidade e registradas no README e lockfiles.

## Multi-tenancy

Decisões detalhadas: `planning/decisions/ADR-0001-shared-database-tenancy.md` e `ADR-0002-path-based-company-context.md`.

- `TEN-001 MUST` Usar banco compartilhado e schema compartilhado.
- `TEN-002 MUST` Toda entidade tenant-scoped possuir `company_id`.
- `TEN-003 MUST` Resolver o tenant no servidor a partir da rota e membership autenticada.
- `TEN-004 MUST` Usar rotas `/c/:company_slug/...`.
- `TEN-005 MUST` Usar `/platform/...` para administração global.
- `TEN-006 MUST NOT` Usar slug, UUID ou obscuridade como controle de acesso.
- `TEN-007 MUST NOT` Usar `default_scope`.
- `TEN-008 MUST` Centralizar contexto em `Current.user`, `Current.company` e `Current.membership`.
- `TEN-009 MUST` Tornar jobs tenant-aware por `company_id` explícito.
- `TEN-010 MUST` Testar isolamento com pelo menos duas empresas.
- `TEN-011 SHOULD` Manter possibilidade de subdomínio futuro sem alterar o modelo de dados.
- `TEN-012 MUST NOT` Implementar PostgreSQL RLS na primeira versão.
- `TEN-013 MUST` Documentar RLS como possível defesa adicional futura.

## Rotas canônicas

```text
/c/:company_slug/dashboard
/c/:company_slug/cash_registers
/c/:company_slug/cash_closings
/c/:company_slug/expenses
/c/:company_slug/reports
/c/:company_slug/settings

/platform
/platform/companies
/platform/users
/platform/audit_logs
```

## Identidade e dados

- `ARCH-020 MUST` Usar UUID como chave primária das entidades da aplicação.
- `ARCH-021 MUST` Não usar IDs sequenciais em URLs públicas.
- `ARCH-022 MUST` Armazenar dinheiro em `bigint` de centavos.
- `ARCH-023 MUST` Configurar locale `pt-BR`.
- `ARCH-024 MUST` Usar moeda padrão `BRL`.
- `ARCH-025 MUST` Usar timezone padrão `America/Sao_Paulo`.
- `ARCH-026 MUST` Considerar segunda-feira como início padrão da semana.
- `ARCH-027 MUST` Formatar datas e dinheiro no padrão brasileiro na interface.

## Organização do domínio

Usar:

- policies para autorização;
- service/command objects para transições com efeitos;
- query objects para relatórios e filtros complexos;
- transações para operações multi-registro;
- concerns apenas para comportamento realmente compartilhado;
- presenters/helpers para formatação de interface.

Evitar:

- callbacks com efeitos colaterais não evidentes;
- cálculos financeiros em views;
- duplicação de fórmulas;
- models sem limites de responsabilidade;
- repository pattern sobre Active Record sem necessidade;
- metaprogramação difícil de auditar.

## Consistência de relatórios

- `ARCH-040 MUST` Dashboard, HTML de relatório e CSV devem usar a mesma camada de consulta.
- `ARCH-041 MUST` Cálculos derivados possuir uma única implementação canônica.
- `ARCH-042 MUST` Consultas agregadas evitar carregar todos os registros em memória.
- `ARCH-043 MUST` Períodos respeitar timezone e fronteiras locais da empresa.

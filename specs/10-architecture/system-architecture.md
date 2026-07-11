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

- `ARCH-009 MUST` Escolher versões exatas no milestone de fundação, verificar compatibilidade e registrá-las no README e lockfiles.

## Multi-tenancy

Decisões detalhadas: `planning/decisions/ADR-0001-shared-database-tenancy.md`, `planning/decisions/ADR-0002-path-based-company-context.md` e `planning/decisions/ADR-0003-composite-tenant-foreign-keys.md`.

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
- `TEN-014 MUST` Criar índices únicos em `[company_id, id]` quando necessários para suportar referências compostas.
- `TEN-015 MUST` Usar foreign key composta sempre que uma entidade tenant-scoped referenciar outra entidade tenant-scoped.
- `TEN-016 MUST` Manter validações Rails de coerência de tenant como defesa complementar, nunca como substitutas das constraints aplicáveis.
- `TEN-017 MUST` Testar tentativa de referência cross-tenant diretamente no banco.
- `TEN-018 MUST` Documentar e testar a estratégia equivalente para associações polimórficas ou relações em que PostgreSQL não permita foreign key composta direta.

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
- `ARCH-026 MUST` Usar semana fixa de segunda-feira a domingo.
- `ARCH-027 MUST` Formatar datas e dinheiro no padrão brasileiro na interface.

## Organização do domínio

- `ARCH-DESIGN-001 MUST` Usar policies para autorização.
- `ARCH-DESIGN-002 MUST` Usar service/command objects para transições com efeitos.
- `ARCH-DESIGN-003 MUST` Usar query objects para relatórios e filtros complexos.
- `ARCH-DESIGN-004 MUST` Usar transações para operações multi-registro.
- `ARCH-DESIGN-005 MUST` Usar concerns apenas para comportamento realmente compartilhado.
- `ARCH-DESIGN-006 MUST` Usar presenters/helpers para formatação de interface.
- `ARCH-DESIGN-007 MUST NOT` Usar callbacks com efeitos colaterais não evidentes.
- `ARCH-DESIGN-008 MUST NOT` Executar cálculos financeiros em views.
- `ARCH-DESIGN-009 MUST NOT` Duplicar fórmulas.
- `ARCH-DESIGN-010 MUST` Manter limites explícitos de responsabilidade nos models.
- `ARCH-DESIGN-011 MUST NOT` Adicionar repository pattern sobre Active Record sem necessidade comprovada.
- `ARCH-DESIGN-012 MUST NOT` Usar metaprogramação difícil de auditar.

## Consistência de relatórios

- `ARCH-040 MUST` Dashboard, HTML de relatório e CSV devem usar a mesma camada de consulta.
- `ARCH-041 MUST` Cálculos derivados possuir uma única implementação canônica.
- `ARCH-042 MUST` Consultas agregadas evitar carregar todos os registros em memória.
- `ARCH-043 MUST` Períodos respeitar timezone e fronteiras locais da empresa.

# M4 — Gestão de caixa

Dependência do milestone: M3 concluído, inclusive auditoria mínima transacional.

## M4-T01 — CashRegister
## M4-T02 — CashClosing e constraints
## M4-T03 — CashMovement e fórmulas
## M4-T04 — Criar e editar rascunho
## M4-T05 — Enviar fechamento
## M4-T06 — Aprovar fechamento
## M4-T07 — Reabrir e cancelar
## M4-T08 — Filtros e listagens
## M4-T09 — System specs e isolamento

Eventos críticos de criação, edição e transição são implementados nas próprias tarefas M4-T04 a M4-T07. `M4-T02`/`M4-T03` incluem constraints compostas e testes diretos de tentativa cross-tenant.

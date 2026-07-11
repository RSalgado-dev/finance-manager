# M5 — Despesas

Dependência do milestone: M3 concluído, inclusive auditoria mínima transacional.

## M5-T01 — ExpenseCategory
## M5-T02 — Supplier
## M5-T03 — Expense e constraints
## M5-T04 — Fluxo de pagamento e cancelamento
## M5-T05 — Comprovantes privados
## M5-T06 — Filtros e listagens
## M5-T07 — System specs e isolamento

Eventos críticos de criação, pagamento e cancelamento são implementados em M5-T03/M5-T04. Constraints compostas e testes diretos cross-tenant pertencem às tarefas de modelo. Cardinalidade final de comprovantes depende de `Q-015` antes de M5-T05.

# Modelo de dados

Este documento define o modelo lógico mínimo. Detalhes de tipos e constraints podem ser refinados sem mudar a semântica.

## Company

Campos mínimos:

- `id: uuid`;
- `name`;
- `legal_name`, opcional;
- `slug`, único globalmente;
- `document`, opcional;
- `timezone`, padrão `America/Sao_Paulo`;
- `currency`, padrão `BRL`;
- `week_starts_on`, padrão segunda-feira;
- `cash_difference_tolerance_cents`, padrão zero;
- `active`;
- `suspended_at`;
- timestamps.

## User

- `id: uuid`;
- `name`;
- `email`, único e normalizado;
- credenciais seguras;
- `active`;
- `system_role`;
- `last_sign_in_at`;
- timestamps.

`system_role`: `user` ou `platform_admin`.

## CompanyMembership

- `id: uuid`;
- `company_id`;
- `user_id`;
- `role`;
- `active`;
- timestamps.

Papéis: `company_admin`, `manager`, `operator`, `viewer`.

Constraint única: `[company_id, user_id]`.

## CashRegister

- `id: uuid`;
- `company_id`;
- `name`;
- `description`, opcional;
- `active`;
- timestamps.

## CashClosing

- `id: uuid`;
- `company_id`;
- `cash_register_id`;
- `reference_date`;
- `shift_name`, opcional;
- `opening_balance_cents`;
- `cash_sales_cents`;
- `pix_sales_cents`;
- `debit_card_sales_cents`;
- `credit_card_sales_cents`;
- `other_sales_cents`;
- `actual_cash_cents`;
- `notes`;
- `status`;
- `difference_justification`, opcional;
- `created_by_id`;
- `submitted_by_id`;
- `submitted_at`;
- `approved_by_id`;
- `approved_at`;
- `reopened_by_id`;
- `reopened_at`;
- `reopening_reason`, opcional;
- `canceled_by_id`;
- `canceled_at`;
- `cancellation_reason`, opcional;
- `lock_version`;
- timestamps.

Status: `draft`, `submitted`, `approved`, `canceled`.

A unicidade por caixa/data/turno deve tratar turno ausente como fechamento único do dia. A implementação deve criar constraint efetiva no banco, não apenas validação Rails.

## CashMovement

- `id: uuid`;
- `company_id`;
- `cash_closing_id`;
- `movement_type`;
- `amount_cents`;
- `description`;
- `occurred_at`;
- `created_by_id`;
- timestamps.

Tipos: `inflow`, `withdrawal`.

## ExpenseCategory

- `id: uuid`;
- `company_id`;
- `name`;
- `description`, opcional;
- `active`;
- timestamps.

Nome único por empresa, case-insensitive.

## Supplier

- `id: uuid`;
- `company_id`;
- `name`;
- `document`, opcional;
- `email`, opcional;
- `phone`, opcional;
- `active`;
- timestamps.

## Expense

- `id: uuid`;
- `company_id`;
- `expense_category_id`;
- `supplier_id`, opcional;
- `description`;
- `amount_cents`;
- `competence_date`;
- `due_date`, opcional;
- `paid_at`, opcional;
- `payment_method`;
- `status`;
- `notes`;
- `created_by_id`;
- `approved_by_id`;
- `approved_at`;
- `canceled_by_id`;
- `canceled_at`;
- `cancellation_reason`;
- `lock_version`;
- timestamps.

Status: `draft`, `pending`, `paid`, `canceled`.

Formas internas: `cash`, `pix`, `debit_card`, `credit_card`, `bank_transfer`, `bank_slip`, `other`.

## AuditLog

- `id: uuid`;
- `company_id`, opcional;
- `user_id`, opcional;
- `action`;
- `auditable_type`;
- `auditable_id`;
- `changes_data: jsonb`;
- `metadata: jsonb`;
- `ip_address`;
- `user_agent`;
- `created_at`.

## Integridade

- `ARCH-DATA-001 MUST` Usar foreign keys.
- `ARCH-DATA-002 MUST` Usar `null: false` quando semanticamente obrigatório.
- `ARCH-DATA-003 MUST` Criar check constraints para valores financeiros.
- `ARCH-DATA-004 MUST` Criar índices compostos começando por `company_id` para consultas tenant-scoped.
- `ARCH-DATA-005 MUST` Usar optimistic locking em `CashClosing` e `Expense`.
- `ARCH-DATA-006 MUST` Não excluir fisicamente registros financeiros consolidados.
- `ARCH-DATA-007 MUST` Usar transações em transições de estado.
- `ARCH-DATA-008 MUST` Não duplicar totais derivados sem justificativa arquitetural.

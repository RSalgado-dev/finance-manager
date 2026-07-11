# Modelo de dados

Este documento define o modelo lógico mínimo. Detalhes de tipos e constraints podem ser refinados sem mudar a semântica.

## Company

- `DATA-COMPANY-001 MUST` Company possuir os seguintes campos mínimos:

- `id: uuid`;
- `name`;
- `legal_name`, opcional;
- `slug`, único globalmente;
- `document`, opcional;
- `timezone`, padrão `America/Sao_Paulo`;
- `currency`, padrão `BRL`;
- `cash_difference_tolerance_cents`, padrão zero;
- `active`;
- `suspended_at`;
- timestamps.

- `DATA-COMPANY-002 MUST` Manter `active` verdadeiro com `suspended_at` nulo para empresa ativa e `active` falso com `suspended_at` presente para empresa suspensa.

## User

- `DATA-USER-001 MUST` User possuir os seguintes campos mínimos:

- `id: uuid`;
- `name`;
- `email`, único e normalizado;
- credenciais seguras;
- `active`;
- `system_role`;
- `last_sign_in_at`;
- timestamps.

- `DATA-USER-002 MUST` Restringir `system_role` a `user` ou `platform_admin`.

## CompanyMembership

- `DATA-MEMBERSHIP-001 MUST` CompanyMembership possuir os seguintes campos mínimos:

- `id: uuid`;
- `company_id`;
- `user_id`;
- `role`;
- `active`;
- timestamps.

- `DATA-MEMBERSHIP-002 MUST` Restringir papéis a `company_admin`, `manager`, `operator` ou `viewer`.

- `DATA-MEMBERSHIP-003 MUST` Criar constraint única em `[company_id, user_id]`.

## CompanyInvitation

- `DATA-INVITATION-001 MUST` CompanyInvitation possuir os seguintes campos mínimos:

- `id: uuid`;
- `company_id`;
- `email`, normalizado e imutável após emissão;
- `role`;
- `token_digest`;
- `expires_at`;
- `accepted_at`, opcional;
- `revoked_at`, opcional;
- `invited_by_id`;
- timestamps.

- `DATA-INVITATION-002 MUST` Derivar o estado: `accepted` quando `accepted_at` estiver presente; `revoked` quando `revoked_at` estiver presente; `expired` quando não terminal e `expires_at` tiver passado; caso contrário `pending`.
- `DATA-INVITATION-003 MUST` Impedir simultaneidade de `accepted_at` e `revoked_at` e impedir aceite após expiração ou revogação.
- `DATA-INVITATION-004 MUST` Garantir no banco no máximo um convite não aceito e não revogado por empresa e e-mail normalizado; ao reenviar convite expirado, revogar o registro anterior antes de criar seu substituto.

## CashRegister

- `DATA-CASH-REGISTER-001 MUST` CashRegister possuir os seguintes campos mínimos:

- `id: uuid`;
- `company_id`;
- `name`;
- `description`, opcional;
- `active`;
- timestamps.

## CashClosing

- `DATA-CASH-CLOSING-001 MUST` CashClosing possuir os seguintes campos mínimos:

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

- `DATA-CASH-CLOSING-002 MUST` Restringir status a `draft`, `submitted`, `approved` ou `canceled`.

- `DATA-CASH-CLOSING-003 MUST` Criar constraint efetiva no banco para unicidade por empresa, caixa, data e turno, tratando turno ausente como fechamento único do dia.
- `DATA-CASH-CLOSING-004 MUST` Exigir metadados coerentes com o status atual: submissão em `submitted`/`approved`, aprovação em `approved`, cancelamento em `canceled`; reabertura deve limpar metadados do ciclo atual de submissão/aprovação e preservá-los no AuditLog.

## CashMovement

- `DATA-CASH-MOVEMENT-001 MUST` CashMovement possuir os seguintes campos mínimos:

- `id: uuid`;
- `company_id`;
- `cash_closing_id`;
- `movement_type`;
- `amount_cents`;
- `description`;
- `occurred_at`;
- `created_by_id`;
- timestamps.

- `DATA-CASH-MOVEMENT-002 MUST` Restringir tipos a `inflow` ou `withdrawal`.

## ExpenseCategory

- `DATA-EXPENSE-CATEGORY-001 MUST` ExpenseCategory possuir os seguintes campos mínimos:

- `id: uuid`;
- `company_id`;
- `name`;
- `description`, opcional;
- `active`;
- timestamps.

- `DATA-EXPENSE-CATEGORY-002 MUST` Garantir nome único por empresa, case-insensitive, no banco.

## Supplier

- `DATA-SUPPLIER-001 MUST` Supplier possuir os seguintes campos mínimos:

- `id: uuid`;
- `company_id`;
- `name`;
- `document`, opcional;
- `email`, opcional;
- `phone`, opcional;
- `active`;
- timestamps.

## Expense

- `DATA-EXPENSE-001 MUST` Expense possuir os seguintes campos mínimos:

- `id: uuid`;
- `company_id`;
- `expense_category_id`;
- `supplier_id`, opcional;
- `description`;
- `amount_cents`;
- `competence_date`;
- `due_date`, opcional;
- `paid_at`, opcional;
- `payment_method`, opcional até o pagamento;
- `status`;
- `notes`;
- `created_by_id`;
- `paid_by_id`, opcional até o pagamento;
- `canceled_by_id`, opcional até o cancelamento;
- `canceled_at`, opcional até o cancelamento;
- `cancellation_reason`, opcional até o cancelamento;
- `lock_version`;
- timestamps.

- `DATA-EXPENSE-002 MUST` Restringir status a `draft`, `pending`, `paid` ou `canceled`.

- `DATA-EXPENSE-003 MUST` Restringir formas internas a `cash`, `pix`, `debit_card`, `credit_card`, `bank_transfer`, `bank_slip` ou `other`.
- `DATA-EXPENSE-004 MUST` Exigir `paid_at`, `paid_by_id` e `payment_method` em `paid`, proibi-los em `draft`/`pending` e preservá-los em `canceled` quando a origem tiver sido `paid`.
- `DATA-EXPENSE-005 MUST` Exigir `canceled_by_id`, `canceled_at` e `cancellation_reason` se e somente se o status for `canceled`.

## AuditLog

- `DATA-AUDIT-001 MUST` AuditLog possuir os seguintes campos mínimos:

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

- `DATA-AUDIT-002 MUST NOT` Expor update ou delete de AuditLog pela aplicação.
- `DATA-AUDIT-003 MUST` Tratar a associação polimórfica auditável sem foreign key composta direta por validação explícita, allowlist de tipos, scoping, auditoria e testes de isolamento.

## Active Storage

- `DATA-STORAGE-001 MUST` Tratar blobs e attachments do framework como infraestrutura não tenant-scoped e derivar o tenant exclusivamente do registro anexado autorizado.
- `DATA-STORAGE-002 MUST` Documentar que a associação polimórfica do Active Storage não admite a foreign key composta tenant-scoped direta e cobri-la com policy, scoping pelo registro anexado e testes com duas empresas.

## Integridade

- `ARCH-DATA-001 MUST` Usar foreign keys.
- `ARCH-DATA-002 MUST` Usar `null: false` quando semanticamente obrigatório.
- `ARCH-DATA-003 MUST` Criar check constraints para valores financeiros.
- `ARCH-DATA-004 MUST` Criar índices compostos começando por `company_id` para consultas tenant-scoped.
- `ARCH-DATA-005 MUST` Usar optimistic locking em `CashClosing` e `Expense`.
- `ARCH-DATA-006 MUST` Não excluir fisicamente registros financeiros consolidados.
- `ARCH-DATA-007 MUST` Usar transações em transições de estado.
- `ARCH-DATA-008 MUST` Não duplicar totais derivados sem justificativa arquitetural.
- `ARCH-DATA-009 MUST` Criar constraint única `[company_id, id]` nos pais tenant-scoped referenciados por foreign key composta.
- `ARCH-DATA-010 MUST` Criar foreign keys compostas para toda referência entre entidades tenant-scoped.
- `ARCH-DATA-011 MUST` Validar coerência de tenant também no Rails como defesa complementar.
- `ARCH-DATA-012 MUST` Testar constraints cross-tenant por inserção direta no banco.
- `ARCH-DATA-013 MUST` Criar checks para enums e invariantes de estado representáveis no banco.
- `ARCH-DATA-014 MUST` Documentar exceções polimórficas e aplicar controles equivalentes testados.

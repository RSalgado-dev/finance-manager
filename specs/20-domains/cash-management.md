# Gestão de caixas e fechamentos

## Caixas

- `CASH-001 MUST` Empresa pode possuir vários caixas.
- `CASH-002 MUST` Caixa inativo preserva histórico.
- `CASH-003 MUST NOT` Permitir novo fechamento em caixa inativo.
- `CASH-004 MUST` Nome do caixa ser único dentro da empresa, salvo decisão diferente registrada.

## Fechamento

### Fórmulas

- `CASH-FORMULA-001 MUST` Calcular vendas totais exclusivamente pela fórmula:

```text
total_sales =
  cash_sales +
  pix_sales +
  debit_card_sales +
  credit_card_sales +
  other_sales
```

- `CASH-FORMULA-002 MUST` Calcular entradas e retiradas exclusivamente pelas fórmulas:

```text
cash_inflows = soma de CashMovement inflow
cash_withdrawals = soma de CashMovement withdrawal
```

- `CASH-FORMULA-003 MUST` Calcular caixa esperado exclusivamente pela fórmula:

```text
expected_cash =
  opening_balance +
  cash_sales +
  cash_inflows -
  cash_withdrawals
```

- `CASH-FORMULA-004 MUST` Calcular diferença de caixa exclusivamente pela fórmula:

```text
cash_difference =
  actual_cash -
  expected_cash
```

- `CASH-010 MUST` Fórmulas possuir implementação canônica testada.
- `CASH-011 MUST` Movimentações detalhadas ser a fonte dos totais de entrada e retirada.
- `CASH-012 MUST` Valores ser não negativos, salvo regra explicitamente documentada.
- `CASH-013 MUST` Permitir vários movimentos por fechamento.
- `CASH-014 MUST` Impedir duplicidade efetiva por empresa, caixa, data e turno.
- `CASH-015 MUST` Tratar turno ausente como fechamento único do dia.

### Estados

- `CASH-020 MUST` Permitir somente as transições `draft -> submitted`, `draft -> canceled`, `submitted -> approved`, `submitted -> canceled` e `approved -> draft` por reabertura explícita.
- `CASH-021 MUST` Permitir ao operator enviar seu próprio rascunho; manager e company admin podem enviar rascunho autorizado da empresa.
- `CASH-022 MUST NOT` Permitir edição de fechamento `submitted`, `approved` ou `canceled`; reabertura aprovada deve preceder nova edição.
- `CASH-023 MUST NOT` Permitir que operator aprove o próprio fechamento; operator não possui permissão de aprovação.
- `CASH-024 MUST` Permitir aprovação de `submitted` somente a manager ou company admin.
- `CASH-025 MUST` Incluir em receitas e relatórios financeiros somente fechamento `approved`; a reabertura deve removê-lo de todo período recalculado até nova aprovação.
- `CASH-026 MUST` Restringir `approved -> draft` a operação explícita de reabertura por manager ou company admin, com justificativa, responsável e data.
- `CASH-027 MUST` Permitir cancelamento somente de `draft` ou `submitted`, exigir justificativa e tornar `canceled` terminal.
- `CASH-028 MUST` Executar toda criação, alteração e transição de fechamento na mesma transação da auditoria crítica; falha da auditoria deve impedir a operação.
- `CASH-029 MUST` Fechamento usar optimistic locking.
- `CASH-034 MUST` Fazer transições inválidas falharem explicitamente sem alteração parcial de estado ou metadados.
- `CASH-035 MUST` Registrar o histórico completo de reaberturas em AuditLog; os campos `reopened_by_id`, `reopened_at` e `reopening_reason` representam a reabertura mais recente.
- `CASH-036 MUST` Ao reabrir, limpar os metadados do ciclo atual de submissão e aprovação no registro e preservar seus valores anteriores no AuditLog crítico.

### Matriz de transições

| ID | Origem | Ação | Ator autorizado | Destino | Condições | Auditoria |
|---|---|---|---|---|---|---|
| `CASH-STATE-001 MUST` | `draft` | enviar | operator autor do rascunho, manager ou company admin | `submitted` | divergência acima da tolerância exige justificativa | crítica, na mesma transação |
| `CASH-STATE-002 MUST` | `draft` | cancelar | operator autor do rascunho, manager ou company admin | `canceled` | justificativa obrigatória | crítica, na mesma transação |
| `CASH-STATE-003 MUST` | `submitted` | aprovar | manager ou company admin | `approved` | actor autorizado; operator nunca aprova | crítica, na mesma transação |
| `CASH-STATE-004 MUST` | `submitted` | cancelar | manager ou company admin | `canceled` | justificativa obrigatória | crítica, na mesma transação |
| `CASH-STATE-005 MUST` | `approved` | reabrir | manager ou company admin | `draft` | justificativa, responsável e data obrigatórios | crítica, na mesma transação |
| `CASH-STATE-006 MUST` | `canceled` | qualquer transição | ninguém | — | estado terminal | tentativa rejeitada e observável |

### Edição por estado

- `CASH-EDIT-001 MUST` Permitir alteração dos campos operacionais e movimentos somente em `draft`, por ator autorizado e com optimistic locking.
- `CASH-EDIT-002 MUST NOT` Permitir alteração direta de status ou metadados de submissão, aprovação, reabertura e cancelamento fora dos commands de transição.
- `CASH-EDIT-003 MUST NOT` Permitir criar, editar ou remover movimentos quando o fechamento não estiver em `draft`.

### Divergência

- `CASH-030 MUST` Destacar diferença de caixa na interface.
- `CASH-031 MUST NOT` Bloquear fechamento apenas por existir diferença.
- `CASH-032 MUST` Exigir justificativa quando o valor absoluto da diferença ultrapassar a tolerância da empresa.
- `CASH-033 MUST` Relatórios preservar sinal da diferença.

### Filtros

- `CASH-040 MUST` Filtrar por caixa, período, status, responsável e existência de diferença.
- `CASH-041 SHOULD` Filtrar por valor mínimo absoluto da diferença.
- `CASH-042 MUST` Filtros permanecer na query string.

# Gestão de caixas e fechamentos

## Caixas

- `CASH-001 MUST` Empresa pode possuir vários caixas.
- `CASH-002 MUST` Caixa inativo preserva histórico.
- `CASH-003 MUST NOT` Permitir novo fechamento em caixa inativo.
- `CASH-004 MUST` Nome do caixa ser único dentro da empresa, salvo decisão diferente registrada.

## Fechamento

### Fórmulas

```text
total_sales =
  cash_sales +
  pix_sales +
  debit_card_sales +
  credit_card_sales +
  other_sales
```

```text
cash_inflows = soma de CashMovement inflow
cash_withdrawals = soma de CashMovement withdrawal
```

```text
expected_cash =
  opening_balance +
  cash_sales +
  cash_inflows -
  cash_withdrawals
```

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

- `CASH-020 MUST` Rascunho pode ser editado por ator autorizado.
- `CASH-021 MUST` Operador pode enviar rascunho.
- `CASH-022 MUST` Fechamento enviado não pode ser editado pelo operador.
- `CASH-023 MUST` Operador não pode aprovar o próprio fechamento.
- `CASH-024 MUST` Apenas manager ou company admin pode aprovar.
- `CASH-025 MUST` Apenas fechamento aprovado entra em receitas e relatórios.
- `CASH-026 MUST` Reabertura exige manager ou company admin e justificativa.
- `CASH-027 MUST` Cancelamento exige permissão e justificativa.
- `CASH-028 MUST` Mudanças de estado usar transação e auditoria.
- `CASH-029 MUST` Fechamento usar optimistic locking.

### Divergência

- `CASH-030 MUST` Destacar diferença de caixa na interface.
- `CASH-031 MUST NOT` Bloquear fechamento apenas por existir diferença.
- `CASH-032 MUST` Exigir justificativa quando o valor absoluto da diferença ultrapassar a tolerância da empresa.
- `CASH-033 MUST` Relatórios preservar sinal da diferença.

### Filtros

- `CASH-040 MUST` Filtrar por caixa, período, status, responsável e existência de diferença.
- `CASH-041 SHOULD` Filtrar por valor mínimo absoluto da diferença.
- `CASH-042 MUST` Filtros permanecer na query string.

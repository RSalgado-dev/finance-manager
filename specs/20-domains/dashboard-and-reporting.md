# Dashboard e relatórios

## Dashboard

- `REP-DASH-001 MUST` Exibir cards de vendas aprovadas no dia, semana e mês.
- `REP-DASH-002 MUST` Exibir card de despesas pagas no mês.
- `REP-DASH-003 MUST` Exibir card de resultado líquido do mês.
- `REP-DASH-004 MUST` Exibir card de fechamentos aguardando aprovação.
- `REP-DASH-005 MUST` Exibir cards de despesas pendentes e vencidas.
- `REP-DASH-006 MUST` Exibir cards de divergência acumulada e caixas ativos.
- `REP-DASH-007 MUST` Exibir gráfico de receitas versus despesas por dia.
- `REP-DASH-008 MUST` Exibir gráfico de vendas por forma de pagamento.
- `REP-DASH-009 MUST` Exibir gráfico de despesas por categoria.
- `REP-DASH-010 MUST` Exibir gráfico de divergências de caixa.
- `REP-DASH-011 MUST` Exibir evolução mensal dos últimos 12 meses.

Requisitos:

- `REP-001 MUST` Funcionar sem dados.
- `REP-002 MUST` Respeitar timezone da empresa.
- `REP-003 MUST` Evitar N+1.
- `REP-004 MUST` Usar agregações no banco.
- `REP-005 MUST` Ter legendas em português e alternativa acessível.
- `REP-006 MUST NOT` Depender de serviço pago.

## Períodos

- `REP-010 MUST` Suportar semanal, mensal, anual e intervalo personalizado.
- `REP-011 MUST` Toda semana iniciar segunda-feira e terminar domingo, sem configuração por empresa.
- `REP-012 MUST` Fronteiras respeitar timezone da empresa.
- `REP-013 MUST` Comparar com período anterior de duração equivalente.

## Regras financeiras

- `REP-FORMULA-001 MUST` Calcular resultado líquido exclusivamente pela fórmula:

```text
net_result = approved_sales - included_expenses
```

- `REP-020 MUST` Somente fechamentos aprovados compor receita.
- `REP-021 MUST` Despesas canceladas nunca compor relatório.
- `REP-022 MUST` Regime padrão ser caixa.
- `REP-023 MUST` Regime de caixa usar `paid_at`.
- `REP-024 MUST` Regime de competência usar `competence_date`.
- `REP-025 MUST` Dashboard, relatório e CSV compartilhar query objects.
- `REP-026 MUST` Percentuais lidar com total zero sem erro.
- `REP-027 MUST` Regime de caixa incluir somente despesas `paid` no período definido por `paid_at`.
- `REP-028 MUST` Regime de competência incluir somente despesas `pending` ou `paid` no período definido por `competence_date`, excluindo `draft` e `canceled`.
- `REP-029 MUST` Cancelamento retroativo remover a despesa de todos os resultados recalculados, preservando o AuditLog e sem reescrever exports históricos já emitidos.

## Relatórios mínimos

### Consolidado

- `REP-REPORT-001 MUST` Relatório consolidado conter vendas brutas, despesas, resultado líquido, quantidade de fechamentos, diferença total e médias diárias.

### Forma de pagamento

- `REP-REPORT-002 MUST` Relatório por forma de pagamento conter dinheiro, PIX, débito, crédito, outras, total e percentual.

### Despesas por categoria

- `REP-REPORT-003 MUST` Relatório de despesas por categoria conter categoria, quantidade, total, percentual e comparação anterior.

### Divergências

- `REP-REPORT-004 MUST` Relatório financeiro de divergências incluir somente fechamentos `approved`.
- `REP-REPORT-005 MUST` Detalhar no relatório de divergências caixa, data, turno, responsável pela criação, caixa esperado, caixa informado, diferença com sinal preservado, justificativa, aprovador e data de aprovação.
- `REP-REPORT-006 MUST` Manter listagens operacionais separadas capazes de mostrar `draft`, `submitted`, `approved` e `canceled` conforme filtros e autorização.

### Por caixa

- `REP-REPORT-007 MUST` Relatório por caixa apresentar o desempenho de cada caixa no período.

## Saídas

- `REP-040 MUST` Oferecer página HTML adequada para impressão.
- `REP-041 MUST` Oferecer CSV.
- `REP-042 MUST` Preservar filtros na query string.
- `REP-043 MUST` Links só funcionar para usuários autorizados da empresa.
- `REP-044 MUST` Registrar exportação em auditoria.
- `REP-045 MAY` Gerar exports em job somente quando necessidade for demonstrada por medição ou limite operacional registrado.

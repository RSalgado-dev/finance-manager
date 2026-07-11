# Dashboard e relatórios

## Dashboard

Cards mínimos:

- vendas aprovadas no dia, semana e mês;
- despesas pagas no mês;
- resultado líquido do mês;
- fechamentos aguardando aprovação;
- despesas pendentes;
- despesas vencidas;
- divergência acumulada;
- caixas ativos.

Gráficos mínimos:

- receitas versus despesas por dia;
- vendas por forma de pagamento;
- despesas por categoria;
- divergências de caixa;
- evolução mensal dos últimos 12 meses.

Requisitos:

- `REP-001 MUST` Funcionar sem dados.
- `REP-002 MUST` Respeitar timezone da empresa.
- `REP-003 MUST` Evitar N+1.
- `REP-004 MUST` Usar agregações no banco.
- `REP-005 MUST` Ter legendas em português e alternativa acessível.
- `REP-006 MUST NOT` Depender de serviço pago.

## Períodos

- `REP-010 MUST` Suportar semanal, mensal, anual e intervalo personalizado.
- `REP-011 MUST` Semana padrão iniciar segunda e terminar domingo.
- `REP-012 MUST` Fronteiras respeitar timezone da empresa.
- `REP-013 MUST` Comparar com período anterior de duração equivalente.

## Regras financeiras

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

## Relatórios mínimos

### Consolidado

Vendas brutas, despesas, resultado líquido, quantidade de fechamentos, diferença total, médias diárias.

### Forma de pagamento

Dinheiro, PIX, débito, crédito, outras, total e percentual.

### Despesas por categoria

Categoria, quantidade, total, percentual e comparação anterior.

### Divergências

Caixa, data, responsável, esperado, informado, diferença, justificativa e status.

### Por caixa

Desempenho de cada caixa no período.

## Saídas

- `REP-040 MUST` Oferecer página HTML adequada para impressão.
- `REP-041 MUST` Oferecer CSV.
- `REP-042 MUST` Preservar filtros na query string.
- `REP-043 MUST` Links só funcionar para usuários autorizados da empresa.
- `REP-044 MUST` Registrar exportação em auditoria.
- `REP-045 SHOULD` Gerar exports grandes em job.

# Despesas

## Categorias

- `EXP-001 MUST` Categoria pertencer à empresa.
- `EXP-002 MUST` Nome ser único por empresa, case-insensitive.
- `EXP-003 MUST` Categoria inativa preservar histórico.
- `EXP-004 MUST NOT` Permitir nova despesa em categoria inativa.

## Fornecedores

- `EXP-010 MUST` Fornecedor pertencer à empresa.
- `EXP-011 MUST` Fornecedor inativo preservar histórico.
- `EXP-012 MUST` Documento, e-mail e telefone ser opcionais.
- `EXP-013 SHOULD` Normalizar documento e contatos quando presentes.

## Despesa

- `EXP-020 MUST` Valor ser maior que zero.
- `EXP-021 MUST` Despesa paga possuir `paid_at`, `paid_by_id` e `payment_method`; esses dados devem ser preservados após cancelamento de despesa paga.
- `EXP-022 MUST` Despesa cancelada não entrar em relatórios.
- `EXP-023 MUST` Cancelamento exigir justificativa.
- `EXP-024 MUST NOT` Apagar fisicamente despesa `pending`, `paid` ou `canceled`.
- `EXP-025 MAY` Permitir exclusão física de rascunho sem dependências, por usuário autorizado.
- `EXP-026 MUST` Executar criação, pagamento e cancelamento na mesma transação da auditoria crítica; cancelamento de despesa paga sempre exige auditoria crítica.
- `EXP-027 MUST` Considerar vencida e destacar somente despesa `pending` com `due_date` anterior à data local da empresa.
- `EXP-028 MUST` Usar optimistic locking.
- `EXP-029 MUST` Traduzir status e formas de pagamento na interface.
- `EXP-030 MUST` No regime de caixa, incluir somente `paid` e determinar período por `paid_at`.
- `EXP-031 MUST` No regime de competência, incluir somente `pending` e `paid` e determinar período por `competence_date`.
- `EXP-032 MUST` Permitir somente as transições `draft -> pending`, `draft -> canceled`, `pending -> paid`, `pending -> canceled` e `paid -> canceled`.
- `EXP-033 MUST` Tornar `canceled` terminal e fazer toda transição inválida falhar explicitamente sem alteração parcial.
- `EXP-034 MUST` Restringir pagamento a manager ou company admin; a aprovação da primeira versão é implícita na operação `pending -> paid` e não possui estado separado.
- `EXP-035 MUST` Restringir `paid -> canceled` a manager ou company admin e não criar entidade de estorno contábil na primeira versão.
- `EXP-036 SHOULD` Considerar entidade de estorno contábil como evolução futura antes de requisitos fiscais ou contábeis mais avançados.
- `EXP-037 MUST` Recalcular relatórios após cancelamento retroativo, removendo a despesa de períodos de caixa e competência sem apagar o histórico auditável.

### Matriz de transições

| ID | Origem | Ação | Ator autorizado | Destino | Condições | Auditoria |
|---|---|---|---|---|---|---|
| `EXP-STATE-001 MUST` | `draft` | enviar | operator autor, manager ou company admin | `pending` | dados obrigatórios válidos | crítica, na mesma transação |
| `EXP-STATE-002 MUST` | `draft` | cancelar | operator autor, manager ou company admin | `canceled` | justificativa obrigatória | crítica, na mesma transação |
| `EXP-STATE-003 MUST` | `pending` | pagar | manager ou company admin | `paid` | `paid_at`, `paid_by_id` e forma obrigatórios | crítica, na mesma transação |
| `EXP-STATE-004 MUST` | `pending` | cancelar | manager ou company admin | `canceled` | justificativa obrigatória | crítica, na mesma transação |
| `EXP-STATE-005 MUST` | `paid` | cancelar | manager ou company admin | `canceled` | justificativa; preservar dados de pagamento | crítica, na mesma transação |
| `EXP-STATE-006 MUST` | `canceled` | qualquer transição | ninguém | — | estado terminal | tentativa rejeitada e observável |

### Edição por estado

- `EXP-EDIT-001 MUST` Permitir ao operator editar campos operacionais somente em seus próprios `draft`; manager e company admin podem editar qualquer `draft` da empresa.
- `EXP-EDIT-002 MUST` Permitir em `pending` apenas correções de descrição, categoria, fornecedor, competência, vencimento e notas por manager ou company admin, com auditoria crítica; mudança de valor exige cancelamento e recriação.
- `EXP-EDIT-003 MUST NOT` Permitir edição dos dados financeiros ou cadastrais em `paid`; somente a transição de cancelamento é aceita.
- `EXP-EDIT-004 MUST NOT` Permitir edição de `canceled`.
- `EXP-EDIT-005 MUST NOT` Permitir alteração direta de status ou metadados de pagamento/cancelamento fora dos commands de transição.

## Comprovantes

- `EXP-040 MUST` Permitir anexo de comprovante.
- `EXP-041 MUST` Validar tamanho e MIME type.
- `EXP-042 MUST` Manter armazenamento privado.
- `EXP-043 MUST` Autorizar acesso ao arquivo pelo tenant e policy.
- `EXP-044 MUST NOT` Expor URL pública permanente.
- `EXP-045 MUST` Preservar comprovantes quando a despesa for cancelada.

## Filtros

- `EXP-050 MUST` Filtrar por competência, pagamento, vencimento, categoria, fornecedor, status, forma, faixa de valor e descrição.
- `EXP-051 MUST` Persistir filtros na query string.
- `EXP-052 MUST` Export respeitar exatamente os filtros e o tenant.

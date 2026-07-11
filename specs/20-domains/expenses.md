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
- `EXP-021 MUST` Despesa paga possuir `paid_at`.
- `EXP-022 MUST` Despesa cancelada não entrar em relatórios.
- `EXP-023 MUST` Cancelamento exigir justificativa.
- `EXP-024 MUST NOT` Apagar fisicamente despesa paga ou cancelada.
- `EXP-025 MAY` Permitir exclusão física de rascunho sem dependências, por usuário autorizado.
- `EXP-026 MUST` Alterações de despesa paga gerar auditoria.
- `EXP-027 MUST` Destacar despesa vencida e não paga.
- `EXP-028 MUST` Usar optimistic locking.
- `EXP-029 MUST` Traduzir status e formas de pagamento na interface.
- `EXP-030 MUST` Considerar regime de caixa por `paid_at`.
- `EXP-031 MUST` Considerar regime de competência por `competence_date`.

## Comprovantes

- `EXP-040 MUST` Permitir anexo de comprovante.
- `EXP-041 MUST` Validar tamanho e MIME type.
- `EXP-042 MUST` Manter armazenamento privado.
- `EXP-043 MUST` Autorizar acesso ao arquivo pelo tenant e policy.
- `EXP-044 MUST NOT` Expor URL pública permanente.

## Filtros

- `EXP-050 MUST` Filtrar por competência, pagamento, vencimento, categoria, fornecedor, status, forma, faixa de valor e descrição.
- `EXP-051 MUST` Persistir filtros na query string.
- `EXP-052 MUST` Export respeitar exatamente os filtros e o tenant.

# Matriz normativa de autorização

## Convenções

- `AUTHZ-001 MUST` Interpretar `sim` como permissão sujeita a tenant ativo, membership ativa, policy e escopo por associação.
- `AUTHZ-002 MUST` Interpretar `próprio` como permissão limitada a registro criado pelo ator e ainda no estado indicado.
- `AUTHZ-003 MUST` Interpretar `suporte` como leitura excepcional por platform admin, com motivo explícito e auditoria crítica na mesma transação que concede/registra o acesso.
- `AUTHZ-004 MUST NOT` Permitir que platform admin altere dados financeiros tenant-scoped por fluxo de suporte.
- `AUTHZ-005 MUST` Negar toda combinação de recurso, ação, estado e ator não permitida explicitamente nesta matriz.

Legenda de auditoria: `crítica` participa da mesma transação; `operacional` gera evento, mas não integra obrigatoriamente uma transação crítica; `observacional` pode ser gravada fora da transação de domínio; `não` não exige evento específico.

## Empresas e memberships

| ID | Recurso | Ação | Origem | platform_admin | company_admin | manager | operator | viewer | Restrições adicionais | Auditoria |
|---|---|---|---|---|---|---|---|---|---|---|
| `AUTHZ-010 MUST` | empresa | visualizar | qualquer | sim | própria | própria | própria | própria | empresa suspensa bloqueia acesso tenant comum | observacional |
| `AUTHZ-011 MUST` | empresa | criar com primeiro admin | inexistente | sim | — | — | — | — | operação atômica | crítica |
| `AUTHZ-012 MUST` | empresa | editar dados/configurações | ativa | sim | própria | — | — | — | semana não é configurável | operacional |
| `AUTHZ-013 MUST` | empresa | suspender/reativar | ativa/suspensa | sim | — | — | — | — | preservar dados | crítica |
| `AUTHZ-014 MUST` | membership | listar/visualizar | qualquer | sim | própria empresa | própria empresa | — | — | dados mínimos necessários | observacional |
| `AUTHZ-015 MUST` | membership | convidar/criar | inexistente | sim | própria empresa | — | — | — | papel limitado ao permitido; proteger último admin | crítica |
| `AUTHZ-016 MUST` | membership | alterar papel | ativa | sim | própria empresa | — | — | — | não alterar/remover último company_admin ativo | crítica |
| `AUTHZ-017 MUST` | membership | ativar/desativar | ativa/inativa | sim | própria empresa | — | — | — | não desativar último company_admin ativo | crítica |

## Cadastros operacionais

| ID | Recurso | Ação | Origem | platform_admin | company_admin | manager | operator | viewer | Restrições adicionais | Auditoria |
|---|---|---|---|---|---|---|---|---|---|---|
| `AUTHZ-020 MUST` | caixa | visualizar | qualquer | suporte | sim | sim | sim | sim | sempre tenant-scoped | observacional |
| `AUTHZ-021 MUST` | caixa | criar/editar | ativo | — | sim | sim | — | — | nome único por empresa | operacional |
| `AUTHZ-022 MUST` | caixa | ativar/desativar | ativo/inativo | — | sim | sim | — | — | preservar histórico | operacional |
| `AUTHZ-023 MUST` | categoria | visualizar | qualquer | suporte | sim | sim | sim | sim | sempre tenant-scoped | observacional |
| `AUTHZ-024 MUST` | categoria | criar/editar/ativar/desativar | qualquer | — | sim | sim | — | — | preservar histórico e unicidade | operacional |
| `AUTHZ-025 MUST` | fornecedor | visualizar | qualquer | suporte | sim | sim | sim | sim | sempre tenant-scoped | observacional |
| `AUTHZ-026 MUST` | fornecedor | criar/editar/ativar/desativar | qualquer | — | sim | sim | — | — | preservar histórico | operacional |

## Fechamentos e movimentações

| ID | Recurso | Ação | Origem | platform_admin | company_admin | manager | operator | viewer | Restrições adicionais | Auditoria |
|---|---|---|---|---|---|---|---|---|---|---|
| `AUTHZ-030 MUST` | fechamento | visualizar | qualquer | suporte | sim | sim | sim | sim | sempre tenant-scoped | observacional |
| `AUTHZ-031 MUST` | fechamento | criar | inexistente | — | sim | sim | sim | — | caixa ativo | crítica |
| `AUTHZ-032 MUST` | fechamento | editar | `draft` | — | sim | sim | próprio | — | optimistic locking | crítica |
| `AUTHZ-033 MUST` | fechamento | enviar | `draft` | — | sim | sim | próprio | — | cumprir justificativa de diferença | crítica |
| `AUTHZ-034 MUST` | fechamento | aprovar | `submitted` | — | sim | sim | — | — | operator nunca aprova | crítica |
| `AUTHZ-035 MUST` | fechamento | reabrir | `approved` | — | sim | sim | — | — | justificativa, responsável e data | crítica |
| `AUTHZ-036 MUST` | fechamento | cancelar | `draft` | — | sim | sim | próprio | — | justificativa | crítica |
| `AUTHZ-037 MUST` | fechamento | cancelar | `submitted` | — | sim | sim | — | — | justificativa | crítica |
| `AUTHZ-038 MUST` | movimentação | visualizar | qualquer | suporte | sim | sim | sim | sim | por fechamento tenant-scoped | observacional |
| `AUTHZ-039 MUST` | movimentação | criar/editar/excluir | fechamento `draft` | — | sim | sim | próprio fechamento | — | proibido nos demais estados | crítica |

## Despesas e comprovantes

| ID | Recurso | Ação | Origem | platform_admin | company_admin | manager | operator | viewer | Restrições adicionais | Auditoria |
|---|---|---|---|---|---|---|---|---|---|---|
| `AUTHZ-040 MUST` | despesa | visualizar | qualquer | suporte | sim | sim | sim | sim | sempre tenant-scoped | observacional |
| `AUTHZ-041 MUST` | despesa | criar | inexistente | — | sim | sim | sim | — | categoria ativa | crítica |
| `AUTHZ-042 MUST` | despesa | editar | `draft` | — | sim | sim | próprio | — | optimistic locking | crítica |
| `AUTHZ-043 MUST` | despesa | enviar | `draft` | — | sim | sim | próprio | — | dados obrigatórios válidos | crítica |
| `AUTHZ-044 MUST` | despesa | corrigir campos permitidos | `pending` | — | sim | sim | — | — | conforme `EXP-EDIT-002` | crítica |
| `AUTHZ-045 MUST` | despesa | pagar | `pending` | — | sim | sim | — | — | dados de pagamento obrigatórios | crítica |
| `AUTHZ-046 MUST` | despesa | cancelar | `draft` | — | sim | sim | próprio | — | justificativa | crítica |
| `AUTHZ-047 MUST` | despesa | cancelar | `pending` ou `paid` | — | sim | sim | — | — | justificativa; preservar pagamento | crítica |
| `AUTHZ-048 MUST` | despesa | excluir fisicamente | `draft` | — | sim | sim | próprio | — | somente sem dependências | operacional |
| `AUTHZ-049 MUST` | comprovante | visualizar | qualquer | suporte | sim | sim | sim | sim | policy da despesa e URL temporária | observacional |
| `AUTHZ-050 MUST` | comprovante | anexar/remover | despesa `draft` | — | sim | sim | própria despesa | — | tipo/tamanho válidos; ciclo final depende de `Q-015` | operacional |
| `AUTHZ-051 MUST` | comprovante | anexar/remover | despesa `pending` | — | sim | sim | — | — | remoção auditada; proibido em `paid`/`canceled` | operacional |

## Relatórios, exports, auditoria e suporte

| ID | Recurso | Ação | Origem | platform_admin | company_admin | manager | operator | viewer | Restrições adicionais | Auditoria |
|---|---|---|---|---|---|---|---|---|---|---|
| `AUTHZ-060 MUST` | dashboard/relatório | visualizar | qualquer | suporte | sim | sim | sim | sim | mesmos query objects e tenant | observacional |
| `AUTHZ-061 MUST` | relatório | imprimir | qualquer | suporte | sim | sim | — | sim | filtros e tenant preservados | observacional |
| `AUTHZ-062 MUST` | export | gerar CSV | qualquer | suporte | sim | sim | — | sim | rate limit, filtros e tenant | operacional obrigatória |
| `AUTHZ-063 MUST` | audit log tenant | listar/visualizar | qualquer | sim | sim | financeiro | — | — | manager limitado à auditoria financeira | observacional |
| `AUTHZ-064 MUST NOT` | audit log | editar/excluir | qualquer | — | — | — | — | — | imutável pela aplicação | tentativa rejeitada |
| `AUTHZ-065 MUST` | suporte platform | acessar dados financeiros | qualquer | suporte | — | — | — | — | motivo explícito; somente leitura; contexto da empresa | crítica |
| `AUTHZ-066 MUST` | audit log global | listar/visualizar | qualquer | sim | — | — | — | — | rota `/platform`, filtros e paginação | observacional |

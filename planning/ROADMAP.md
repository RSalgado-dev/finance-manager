# Roadmap de implementação

Status possíveis: `NOT_STARTED`, `IN_PROGRESS`, `BLOCKED`, `DONE`, `VERIFIED`.

Somente um milestone deve estar `IN_PROGRESS`, salvo justificativa registrada.

| Milestone | Objetivo | Dependências | Status |
|---|---|---|---|
| M0 | Especificação, decisões e scaffold do projeto | nenhuma | IN_PROGRESS |
| M1 | Fundação Rails, PostgreSQL, UUID, UI base e CI | M0 | NOT_STARTED |
| M2 | Autenticação, empresas, memberships e tenancy | M1 | NOT_STARTED |
| M3 | Autorização, painel platform e gestão de usuários | M2 | NOT_STARTED |
| M4 | Caixas e fechamento de caixa | M3 | NOT_STARTED |
| M5 | Despesas, categorias, fornecedores e anexos | M3 | NOT_STARTED |
| M6 | Dashboard e relatórios | M4, M5 | NOT_STARTED |
| M7 | Auditoria, jobs e e-mails | M3, M4, M5 | NOT_STARTED |
| M8 | Hardening de segurança e isolamento tenant | M6, M7 | NOT_STARTED |
| M9 | Docker de produção, deploy, backup e observabilidade | M8 | NOT_STARTED |
| M10 | Verificação final e release candidate | M9 | NOT_STARTED |

## Regra de passagem

Um milestone só passa a `VERIFIED` quando:

- suas tarefas estão `DONE`;
- suíte aplicável passa;
- critérios de aceite foram revisados;
- documentação e rastreabilidade estão atualizadas;
- não há bloqueio crítico aberto.

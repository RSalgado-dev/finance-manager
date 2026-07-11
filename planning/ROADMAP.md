# Roadmap de implementação

Status possíveis: `NOT_STARTED`, `IN_PROGRESS`, `BLOCKED`, `DONE`, `VERIFIED`.

Somente um milestone deve estar `IN_PROGRESS`, salvo justificativa registrada.

| Milestone | Objetivo | Dependências | Status |
|---|---|---|---|
| M0 | Especificação, Dev Container, scaffold Rails e CI inicial | nenhuma | IN_PROGRESS |
| M1 | Fundação da aplicação, UI base e padrões sobre o Dev Container existente | M0 | NOT_STARTED |
| M2 | Autenticação, empresas, memberships, convites e tenancy | M1 | NOT_STARTED |
| M3 | Autorização, painel platform, gestão de usuários e auditoria mínima | M2 | NOT_STARTED |
| M4 | Caixas e fechamento de caixa | M3 | NOT_STARTED |
| M5 | Despesas, categorias, fornecedores e anexos | M3 | NOT_STARTED |
| M6 | Dashboard e relatórios | M4, M5 | NOT_STARTED |
| M7 | Revisão transversal de auditoria, jobs e notificações complementares | M3, M4, M5, M6 | NOT_STARTED |
| M8 | Hardening de segurança e isolamento tenant | M6, M7 | NOT_STARTED |
| M9 | Docker de produção, deploy, backup e observabilidade | M8 | NOT_STARTED |
| M10 | Verificação final e release candidate | M9 | NOT_STARTED |

## Fronteiras aprovadas

- Dev Container e Docker Compose de desenvolvimento são entregues em `M0-T02A` e são dependência do scaffold `M0-T02B`.
- CI inicial é entregue em M0 e permanece obrigatório antes dos domínios.
- M1 utiliza e evolui a configuração de desenvolvimento criada em M0, sem criar uma segunda configuração Docker concorrente; imagem, processos e deploy de produção pertencem a M9.
- Convites, e-mails de convite e recuperação pertencem a M2.
- AuditLog e serviço transacional mínimo pertencem a M3; cada domínio M4/M5 implementa seus próprios eventos críticos.
- CSV e impressão pertencem a M6.
- Export assíncrono em M7 é condicional a necessidade demonstrada e não é critério obrigatório da primeira versão.
- M8 executa revisão adversarial transversal sem substituir testes tenant-scoped em cada milestone.

## Regra de passagem

Um milestone só passa a `VERIFIED` quando:

- suas tarefas estão `DONE`;
- suíte aplicável passa;
- critérios de aceite foram revisados;
- documentação e rastreabilidade estão atualizadas;
- não há bloqueio crítico aberto.

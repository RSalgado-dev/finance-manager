# Roadmap de implementação

Status possíveis: `NOT_STARTED`, `IN_PROGRESS`, `BLOCKED`, `DONE`, `VERIFIED`.

Somente um milestone deve estar `IN_PROGRESS`, salvo justificativa registrada.

| Milestone | Objetivo | Dependências | Status |
|---|---|---|---|
| M0 | Especificação, Dev Container, scaffold Rails e CI inicial | nenhuma | VERIFIED |
| M1 | Fundação da aplicação, UI base e padrões sobre o Dev Container existente | M0 | DONE |
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
- M1 utiliza a configuração de desenvolvimento entregue e verificada em M0, sem segunda configuração Docker; imagem, processos e deploy de produção pertencem a M9.
- Convites, e-mails de convite e recuperação pertencem a M2.
- AuditLog e serviço transacional mínimo pertencem a M3; cada domínio M4/M5 implementa seus próprios eventos críticos.
- CSV e impressão pertencem a M6.
- Export assíncrono em M7 é condicional a necessidade demonstrada e não é critério obrigatório da primeira versão.
- M8 executa revisão adversarial transversal sem substituir testes tenant-scoped em cada milestone.

## Progresso de M0

- `M0-T01`: `DONE` — baseline normativa validada.
- `M0-T02A`: `DONE` — Dev Container construído e validado.
- `M0-T02B`: `DONE` — scaffold Rails `CompanyFinance` incorporado e validado exclusivamente no container.
- `M0-T02`: `DONE` — tarefa agregadora concluída.
- `M0-T03`: `DONE` — implementação local e execução remota do CI verificadas.
- `M0-T03A`: `DONE` — workflow e comando canônico validados localmente, inclusive em Compose isolado.
- `M0-T03B`: `DONE` — run remoto `29173802602` verde, incluindo cleanup.

M0 foi promovido a `VERIFIED` em 2026-07-12 após revisão independente das especificações, Dev Container isolado, banco vazio, scaffold, testes, lint, segurança, assets, CI local equivalente, evidência remota e cleanup. Nenhuma tarefa de M1 foi iniciada nesta revisão.

## Progresso de M1

- `M1-T01`: `DONE` — layouts, fundação visual, página institucional, testes e documentação concluídos.
- `M1-T02`: `DONE` — `Current`, ciclo HTTP, isolamento, testes e documentação concluídos.
- `M1-T03`: `DONE` — estrutura canônica e convenções arquiteturais documentadas sem abstrações especulativas.
- `M1-T04`: `DONE` — Pagy 43.6.0, paginação offset acessível, filtros GET seguros, testes e documentação concluídos.
- `M1-T05`: `DONE / SUPERSEDED_BY_M0-T02A` — nenhuma implementação nova; Dev Container entregue em M0-T02A, integrado em M0-T02B e revalidado na revisão de M0.

M1 está `DONE` e `READY_FOR_REVIEW`, não `VERIFIED`. A próxima sessão deve executar revisão independente do milestone inteiro antes de iniciar M2.

## Regra de passagem

Um milestone só passa a `VERIFIED` quando:

- suas tarefas estão `DONE`;
- suíte aplicável passa;
- critérios de aceite foram revisados;
- documentação e rastreabilidade estão atualizadas;
- não há bloqueio crítico aberto.

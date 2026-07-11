# Propostas de mudança

Use este arquivo para mudanças ainda não aprovadas em produto, arquitetura ou escopo.

## Template

### P-XXX — Título

- Data:
- Autor:
- Status: `PROPOSED | ACCEPTED | REJECTED | SUPERSEDED`
- Problema:
- Proposta:
- Requisitos afetados:
- Alternativas:
- Consequências:
- Decisão/ADR:

## Propostas avaliadas

### P-001 — Alinhar períodos semanais à configuração da empresa

- Data: 2026-07-11
- Autor: Codex
- Status: `REJECTED`
- Problema: `USR-005` e `ARCH-026` tornam o início da semana configurável, mas `REP-011` fixa segunda-feira.
- Proposta: alterar `REP-011` para usar `Company#week_starts_on`, mantendo segunda-feira como padrão, e cobrir fronteiras por timezone em query specs.
- Requisitos afetados: `USR-005`, `ARCH-026`, `ARCH-043`, `REP-011`, `REP-012`, `TEST-005`.
- Alternativas: remover a configuração; manter segunda-feira fixa e documentar que `week_starts_on` não afeta relatórios.
- Consequências: elimina comportamento contraditório e exige testes para configurações distintas.
- Decisão/ADR: rejeitada em 2026-07-11 porque a decisão explícita fixou segunda-feira a domingo e removeu `week_starts_on`; specs de arquitetura, empresas, dados e relatórios alinhadas.

### P-002 — Impedir referências cruzadas entre tenants no banco

- Data: 2026-07-11
- Autor: Codex
- Status: `ACCEPTED`
- Problema: foreign keys simples não garantem que pai e filho com `company_id` pertençam à mesma empresa.
- Proposta: adotar foreign keys compostas `[company_id, foreign_id] -> [company_id, id]` nas associações tenant-scoped e checks para invariantes de status e valores; manter scoping e policies como controles independentes.
- Requisitos afetados: `PRD-004`, `TEN-002`, `SEC-007`, `ARCH-DATA-001` a `ARCH-DATA-004`, `TEST-007`.
- Alternativas: confiar apenas na aplicação; triggers de banco; RLS imediata, rejeitada pelo `ADR-0001` e `TEN-012`.
- Consequências: migrations e factories ficam mais explícitas; o banco rejeita combinações cross-tenant mesmo diante de bug na aplicação.
- Decisão/ADR: aceita em 2026-07-11 com os requisitos adicionais de testes diretos no banco e documentação de exceções polimórficas; `ADR-0003` aceito.

### P-003 — Corrigir ordem e fronteiras do roadmap

- Data: 2026-07-11
- Autor: Codex
- Status: `ACCEPTED`
- Problema: auditoria financeira é planejada depois dos fluxos críticos; e-mails de convite ficam depois do fluxo de convite; export assíncrono não depende de relatórios; M0 e M1 reivindicam fundação Rails/CI; Compose aparece em M1 e M9 sem distinção.
- Proposta: antecipar a infraestrutura e os eventos obrigatórios de auditoria para antes dos fluxos financeiros; entregar e-mails junto ao fluxo de identidade; fazer export assíncrono depender de M6; distinguir explicitamente scaffold/CI inicial, fundação de domínio, Compose local e imagem/execução de produção.
- Requisitos afetados: `PRD-006`, `AUTH-004`, `CASH-028`, `EXP-026`, `AUD-008`, `REP-045`, `OPS-DEV-011`, `OPS-DEV-014`.
- Alternativas: manter milestones e declarar dependências por tarefa; implementar auditoria mínima dentro de M4/M5 e consolidá-la em M7.
- Consequências: evita aceitar fluxos críticos sem requisitos obrigatórios e remove dependências circulares ou implícitas.
- Decisão/ADR: aceita em 2026-07-11 conforme orientações explícitas; roadmap e tarefas alinhados sem iniciar implementação.

### P-004 — Formalizar máquinas de estado, invariantes e matriz de autorização

- Data: 2026-07-11
- Autor: Codex
- Status: `ACCEPTED`
- Problema: fechamentos e despesas possuem campos de transição sem grafo completo, invariantes ou autorização por ação.
- Proposta: após resolver `Q-001`, `Q-007`, `Q-009` e `Q-016`, adicionar tabelas de transição com origem, destino, ator, pré-condições, campos imutáveis e evento de auditoria; adicionar checks de banco para invariantes representáveis.
- Requisitos afetados: `CASH-020` a `CASH-029`, `EXP-020` a `EXP-031`, `ARCH-DATA-003`, `ARCH-DATA-007`, `TEST-001`, `TEST-002`, `TEST-004`, `TEST-007`.
- Alternativas: deixar regras dispersas entre policies, services e validações.
- Consequências: critérios tornam-se verificáveis e estados inválidos são menos prováveis.
- Decisão/ADR: aceita em 2026-07-11; specs financeiras e matriz normativa de autorização documentam estados, atores, edição e auditoria.

### P-005 — Completar identificadores e critérios verificáveis

- Data: 2026-07-11
- Autor: Codex
- Status: `ACCEPTED`
- Problema: IDs existentes são únicos, mas listas normativas como cards de dashboard, conteúdo mínimo de relatórios, eventos de auditoria e infraestrutura local não possuem IDs; tarefas M1–M10 são apenas títulos; critérios de `M0-T01` incluem termos não mensuráveis e uma fonte ausente.
- Proposta: atribuir IDs estáveis sem renumerar os atuais, criar uma matriz de cobertura do escopo aprovado e detalhar cada tarefa com o template antes de iniciá-la, incluindo comando/evidência esperados.
- Requisitos afetados: controle documental transversal; sem mudança de comportamento pretendida.
- Alternativas: tratar cada seção sem ID como coberta pelo ID mais próximo, documentando esse agrupamento.
- Consequências: melhora rastreabilidade e permite aceite objetivo, com custo de manutenção documental.
- Decisão/ADR: aceita em 2026-07-11; namespaces adicionados, brief histórico e cobertura criados, e checagem automatizada exigida.

### P-006 — Modelar convite de empresa explicitamente

- Data: 2026-07-11
- Autor: Codex
- Status: `ACCEPTED`
- Problema: os requisitos de convite não possuem entidade ou ciclo de vida no modelo lógico.
- Proposta: após resolver `Q-011`, adicionar `CompanyInvitation` tenant-scoped com papel, e-mail normalizado, token digest, expiração, aceite, revogação e ator convidador, incluindo unicidade para convite ativo e auditoria.
- Requisitos afetados: `AUTH-004`, `AUTH-008`, `AUTH-009`, `USR-025`, `TEN-002`, `AUD-006`.
- Alternativas: armazenar convite diretamente em `User` ou em `CompanyMembership` inativa.
- Consequências: torna expiração, reenvio, revogação e usuário existente explícitos, mas adiciona uma entidade de domínio.
- Decisão/ADR: aceita em 2026-07-11; `CompanyInvitation`, estados derivados e regras transacionais adicionados sem novo ADR.

### P-007 — Definir contrato transacional de auditoria

- Data: 2026-07-11
- Autor: Codex
- Status: `ACCEPTED`
- Problema: imutabilidade e reação a falhas de auditoria estão subespecificadas.
- Proposta: adotar o contrato do `ADR-0004`, separar eventos críticos transacionais de eventos operacionais não transacionais e definir mecanismos de observabilidade para falhas.
- Requisitos afetados: `PRD-006`, `AUD-001`, `AUD-006` a `AUD-008`, `NFR-REL-001`.
- Alternativas: auditoria best-effort para todos os eventos; outbox transacional, com complexidade não justificada nesta fase.
- Consequências: eventos críticos não ficam sem trilha, ao custo de tornar a disponibilidade da gravação de auditoria parte da transação.
- Decisão/ADR: aceita em 2026-07-11 com distinção explícita entre eventos críticos e observacionais; `ADR-0004` aceito.

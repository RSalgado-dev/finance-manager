# Registro de riscos

| ID | Risco | Probabilidade | Impacto | Mitigação | Estado |
|---|---|---:|---:|---|---|
| R-001 | Vazamento entre tenants por consulta sem escopo | média | crítico | associação + policy + testes adversariais | OPEN |
| R-002 | Divergência entre dashboard, relatório e CSV | média | alto | query objects compartilhados | OPEN |
| R-003 | Fórmulas financeiras duplicadas | média | alto | implementação canônica e specs | OPEN |
| R-004 | Escopo excessivo para uma única sessão | alta | médio | tarefas atômicas e handoff obrigatório | MITIGATED |
| R-005 | Specs alteradas para justificar código | média | alto | política controlada e ADR | MITIGATED |
| R-006 | Estado de sessão desatualizado | média | médio | CURRENT + SESSION_LOG obrigatórios | MITIGATED |
| R-007 | Anexos perdidos em storage efêmero | média | alto | S3 compatível em produção | OPEN |

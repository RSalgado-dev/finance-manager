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
| R-008 | Relação cross-tenant persistida por foreign key simples | média | crítico | ADR-0003 aceito; FK composta, validação complementar e teste direto previstos por tarefa | OPEN |
| R-009 | Transições financeiras implementadas com estados ou permissões divergentes | baixa | alto | máquinas de estado, campos editáveis e AUTHZ normativos; exigir specs de service/policy | MITIGATED |
| R-010 | Roadmap aceitar fluxos antes de auditoria/e-mail obrigatório | baixa | alto | fronteiras corrigidas; auditoria mínima em M3 e e-mails de identidade em M2 | MITIGATED |
| R-011 | Requisito normativo sem ID ou critério sem fonte verificável | baixa | médio | namespaces completos, SOURCE_COVERAGE e script automatizado verificado | MITIGATED |
| R-012 | Transação crítica concluir sem auditoria correspondente | média | crítico | ADR-0004 aceito; serviço em M3 e testes de rollback obrigatórios | OPEN |
| R-013 | Cardinalidade ou descarte de comprovantes ser implementado sem decisão | média | médio | resolver Q-015 antes de detalhar/iniciar M5-T05 | OPEN |

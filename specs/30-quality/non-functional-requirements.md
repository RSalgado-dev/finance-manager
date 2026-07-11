# Requisitos não funcionais

## Interface

- `NFR-UI-001 MUST` Interface responsiva para desktop e celular.
- `NFR-UI-002 MUST` Formulários com erros claros.
- `NFR-UI-003 MUST` Ações destrutivas com confirmação.
- `NFR-UI-004 MUST` Status com texto, não apenas cor.
- `NFR-UI-005 MUST` Tabelas responsivas.
- `NFR-UI-006 MUST` Navegação por teclado e labels associadas.
- `NFR-UI-007 MUST` Contraste adequado.
- `NFR-UI-008 SHOULD` Usar Turbo quando simplificar experiência e manutenção.

## Desempenho

- `NFR-PERF-001 MUST` Paginar listagens.
- `NFR-PERF-002 MUST` Evitar N+1.
- `NFR-PERF-003 MUST` Criar índices por tenant e filtros frequentes.
- `NFR-PERF-004 MUST` Não agregar grandes datasets em Ruby quando o banco puder fazê-lo.
- `NFR-PERF-005 SHOULD` Inspecionar planos das consultas centrais antes do aceite de relatórios.

## Confiabilidade

- `NFR-REL-001 MUST` Operações financeiras críticas ser atômicas.
- `NFR-REL-002 MUST` Jobs ser idempotentes quando possível.
- `NFR-REL-003 MUST` Expor healthcheck.
- `NFR-REL-004 MUST` Tratar 404, 422 e 500 em produção.
- `NFR-REL-005 MUST` Manter logs em stdout.
- `NFR-REL-006 MUST` Identificar request, empresa e usuário nos logs sem dados sensíveis.

## Manutenibilidade

- `NFR-MNT-001 MUST` Manter documentação coerente com implementação.
- `NFR-MNT-002 MUST` Manter RuboCop configurado.
- `NFR-MNT-003 MUST` Evitar TODO crítico ao encerrar milestone.
- `NFR-MNT-004 MUST` Registrar decisões não triviais em ADR.

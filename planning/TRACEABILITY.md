# Matriz de rastreabilidade

Atualizar conforme a implementação avançar.

| Requisito | Tarefa | Código | Teste | Estado |
|---|---|---|---|---|
| PRD-004 | M2-T07, M8-T01 | — | — | SPECIFIED |
| TEN-001 | M0-T01, M2-T01 | — | — | SPECIFIED |
| TEN-004 | M2-T04 | — | — | SPECIFIED |
| TEN-014..TEN-018 | M2-T01, M2-T07, M4-T02, M5-T03, M8-T01 | — | — | SPECIFIED |
| INV-001..INV-010 | M2-T06, M2-T08 | — | — | SPECIFIED |
| AUTHZ-000..AUTHZ-066 | M3-T01, M3-T07 | — | — | SPECIFIED |
| ARCH-DATA-009..ARCH-DATA-014 | M2-T01, M4-T02, M5-T03 | — | — | SPECIFIED |
| CASH-010 | M4-T03 | — | — | SPECIFIED |
| CASH-020..CASH-035 | M4-T04..M4-T07 | — | — | SPECIFIED |
| CASH-STATE-001..CASH-STATE-006 | M4-T05..M4-T07 | — | — | SPECIFIED |
| EXP-020 | M5-T03 | — | — | SPECIFIED |
| EXP-032..EXP-037 | M5-T03, M5-T04 | — | — | SPECIFIED |
| EXP-STATE-001..EXP-STATE-006 | M5-T03, M5-T04 | — | — | SPECIFIED |
| REP-025 | M6-T01..M6-T07 | — | — | SPECIFIED |
| REP-027..REP-029 | M6-T02..M6-T04, M6-T09 | — | — | SPECIFIED |
| REP-REPORT-004..REP-REPORT-006 | M6-T05, M6-T09 | — | — | SPECIFIED |
| AUD-001..AUD-018 | M2-T08, M3-T08, M4-T04..M4-T07, M5-T03..M5-T04, M7-T01..M7-T03 | — | — | SPECIFIED |
| TEST-REQ-001 | M0-T01 | `scripts/check_spec_requirements.sh` | próprio script; revisão independente 15 specs/496 requisitos/zero falhas | VERIFIED |
| SEC-018 | M8-T05 | — | — | SPECIFIED |
| OPS-LOCAL-001, OPS-LOCAL-003..OPS-LOCAL-008 | M0-T02A | `.devcontainer/`, `.dockerignore`, `.env.example`, `README.md` | implementação/testes em M0-T02A; revisão independente revalidou build, Compose, runtime não root, hostname `db`, volumes, healthcheck e cleanup; M1-T05 superseded, sem segunda implementação | VERIFIED |
| OPS-LOCAL-002 | M0-T02A; tarefa futura do primeiro workload assíncrono | `.devcontainer/compose.yaml` (`app`/`db`); worker ainda futuro | base Compose validada em M0 e operacional nesta reconciliação; worker não implementado e não pertence mais a M1-T05 | SPECIFIED |
| ARCH-001..ARCH-007, ARCH-009 | M0-T02B | `Gemfile`, `config/application.rb`, `app/`, `config/importmap.rb`, `Procfile.dev`, schemas Solid | revisão independente: boot e banco vazio, Tailwind/assets, Active Storage e Solid Queue sem Redis | VERIFIED |
| ARCH-020, ARCH-023..ARCH-027 | M0-T02B | `config/application.rb`, `config/locales/pt-BR.yml` | runner de UUID, locale, timezone e início da semana | VERIFIED |
| TEST-000 | M0-T02B | `Gemfile`, `spec/rails_helper.rb`, `spec/support/` | request e system specs | VERIFIED |
| TEST-003, TEST-006 | M0-T02B e tarefas de domínio futuras | `spec/requests/`, `spec/system/` | smoke tests de `/up`, incluindo Chromium headless | IMPLEMENTED |
| NFR-REL-003 | M0-T02B | `config/routes.rb` | request spec, system spec e requisição real a `/up` | VERIFIED |
| NFR-MNT-001, NFR-MNT-002 | M0-T02B | `README.md`, `docs/development-container.md`, `.rubocop.yml` | documentação revisada e RuboCop sem offenses | VERIFIED |
| PRD-007, NFR-UI-001, NFR-UI-005..NFR-UI-007 | M1-T01 e telas futuras | layouts, `app/assets/tailwind/application.css`, partial de tabela | request/view/system specs; Chromium em 360/768/1280 px | TESTED |
| NFR-UI-002, NFR-UI-004 | M1-T01 e formulários/estados futuros | partials de erros/flash, helper de badge, locale `pt-BR` | helper e view specs de semântica, texto e sanitização | TESTED |
| NFR-UI-003 | tarefas futuras com ações destrutivas | convenção visual/documental em `button_classes` e `docs/ui-foundation.md` | sem ação destrutiva existente para teste funcional | SPECIFIED |
| NFR-UI-008 | M1-T01 e telas futuras | importmap/Turbo preservados; layouts server-rendered | request e system specs da página institucional | IMPLEMENTED |
| NFR-MNT-001, TEST-EVID-001 | M1-T01 | `docs/ui-foundation.md`, README, tarefa e histórico | evidência de 23 specs e verificações finais registrada | TESTED |
| TEN-008 | M1-T02, M2-T04 | `app/models/current.rb` | specs de atributos, reset, bloco, exceção e threads | IMPLEMENTED |
| AUD-007 | M1-T02, M3-T08 | `Current` e `RequestContext` | request specs de request ID, IP e user agent; persistência futura | IMPLEMENTED |
| TEN-009, NFR-REL-002 | M1-T02 e tarefas futuras de jobs | contrato em `docs/request-context.md`; nenhum job criado | sem execução de job nesta tarefa | SPECIFIED |
| NFR-REL-005, NFR-REL-006, SEC-017 | M1-T02 e hardening futuro | log tag nativa de request ID; metadados não logados; documentação de privacidade | runner de produção, request specs, Brakeman e inspeção de diff | IMPLEMENTED |
| TEST-EVID-001 | M1-T02 | tarefa, `docs/request-context.md` e histórico | 32 specs e verificações finais registradas | TESTED |
| ARCH-DESIGN-001..ARCH-DESIGN-012 | M1-T03 e tarefas de domínio | `docs/code-organization.md`, `AGENTS.md`, diretórios canônicos | contratos definidos; implementações/testes aguardam casos concretos | SPECIFIED |
| ARCH-040..ARCH-043, REP-025 | M1-T03, M6 | convenção de relation escopada e cálculo compartilhado em `docs/code-organization.md` | sem query concreta nesta tarefa | SPECIFIED |
| TEN-003, TEN-006..TEN-010, TEN-014..TEN-018 | M1-T03 e milestones de domínio | regras permanentes e contratos explícitos de service/query/policy | testes com duas empresas/constraints aguardam models | SPECIFIED |
| AUTHZ-000..AUTHZ-005, TEST-002 | M1-T03, M3 | contrato futuro de policy/scope; Pundit deliberadamente não instalado | sem policy fictícia; specs futuras por papel/tenant | SPECIFIED |
| TEST-004, TEST-005, TEST-AUD-001, TEST-AUD-002 | M1-T03 e domínios futuros | estratégia de service/query/auditoria em `docs/code-organization.md` | sem classe concreta nesta tarefa | SPECIFIED |
| NFR-MNT-001, NFR-MNT-004, TEST-EVID-001 | M1-T03 | `docs/code-organization.md`, `AGENTS.md`, tarefa e histórico | documentação revisada e verificações registradas | TESTED |
| NFR-PERF-001, ARCH-003, ARCH-008 | M1-T04 | Pagy 43.6.0, `ApplicationController`, inicializador e partial de paginação | request/view specs de páginas, limite, metadados e coleção; RSpec 50/0 | TESTED |
| CASH-042, EXP-051, REP-042 | M1-T04 e domínios futuros | `filter_form_with`, `pagination_request`, convenção `filter[...]` e documentação | filtros aninhados preservados; página removida na nova submissão; domínio ainda futuro | IMPLEMENTED |
| TEN-003, TEN-006..TEN-010, SEC-007, SEC-008, SEC-017 | M1-T04 e milestones tenant | allowlist explícita em `pagination_request`; ordem tenant/autorização/filtro/paginação documentada | token/chave tenant arbitrária excluídos; params não permitidos rejeitados; isolamento real aguarda domínio | IMPLEMENTED |
| NFR-UI-001, NFR-UI-006..NFR-UI-008 | M1-T04 | partial/helper e estilos Tailwind locais | view/helper/system specs de semântica, teclado/foco, Turbo e 360 px | TESTED |
| TEST-003, TEST-006, TEST-EVID-001 | M1-T04 | rota/controller exclusivos de teste e specs request/system | Chromium 4/0; suíte 50/0; rota ausente em produção | TESTED |
| OPS-DEV-010 | M0-T02B | `Gemfile`, `config/queue.yml`, `db/queue_schema.rb` | boot de `SolidQueue`; ausência de Redis | IMPLEMENTED |
| OPS-CI-003 | M0-T02B, M0-T03 | `Gemfile.lock`, `.ruby-version`, Dev Container | `bundle check` e versões no runtime | VERIFIED |
| OPS-CI-001, OPS-CI-004 | M0-T03A, M0-T03B | `.github/workflows/ci.yml`, `bin/ci` | nova execução isolada de `bin/ci`; API reconfirmou run `29173802602` e job `86599229166` verdes com cleanup | VERIFIED |
| OPS-CI-002 | tarefa futura de otimização após medição | sem cache remoto nesta versão | build sem cache medido em aproximadamente 85 segundos | SPECIFIED |
| OPS-DEP-001 | M9-T01 | — | — | SPECIFIED |

Estados: `SPECIFIED`, `IMPLEMENTED`, `TESTED`, `VERIFIED`, `DEPRECATED`.

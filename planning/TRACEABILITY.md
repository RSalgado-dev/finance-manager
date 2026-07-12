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
| TEST-REQ-001 | M0-T01 | `scripts/check_spec_requirements.sh` | próprio script | VERIFIED |
| SEC-018 | M8-T05 | — | — | SPECIFIED |
| OPS-LOCAL-001, OPS-LOCAL-003..OPS-LOCAL-008 | M0-T02A, M1-T05 | `.devcontainer/`, `.dockerignore`, `.env.example`, `README.md` | build, Compose, runtime, permissões e persistência | VERIFIED |
| OPS-LOCAL-002 | M0-T02A, M1-T05 | `.devcontainer/compose.yaml` (`app`/`db`); worker futuro | Compose `config`/`ps` | SPECIFIED |
| ARCH-001..ARCH-007, ARCH-009 | M0-T02B | `Gemfile`, `config/application.rb`, `app/`, `config/importmap.rb`, `Procfile.dev`, schemas Solid | boot, runner, Tailwind/assets, Active Storage e Solid Queue | VERIFIED |
| ARCH-020, ARCH-023..ARCH-027 | M0-T02B | `config/application.rb`, `config/locales/pt-BR.yml` | runner de UUID, locale, timezone e início da semana | VERIFIED |
| TEST-000 | M0-T02B | `Gemfile`, `spec/rails_helper.rb`, `spec/support/` | request e system specs | VERIFIED |
| TEST-003, TEST-006 | M0-T02B e tarefas de domínio futuras | `spec/requests/`, `spec/system/` | smoke tests de `/up`, incluindo Chromium headless | IMPLEMENTED |
| NFR-REL-003 | M0-T02B | `config/routes.rb` | request spec, system spec e requisição real a `/up` | VERIFIED |
| NFR-MNT-001, NFR-MNT-002 | M0-T02B | `README.md`, `docs/development-container.md`, `.rubocop.yml` | documentação revisada e RuboCop sem offenses | VERIFIED |
| OPS-DEV-010 | M0-T02B | `Gemfile`, `config/queue.yml`, `db/queue_schema.rb` | boot de `SolidQueue`; ausência de Redis | IMPLEMENTED |
| OPS-CI-003 | M0-T02B, M0-T03 | `Gemfile.lock`, `.ruby-version`, Dev Container | `bundle check` e versões no runtime | VERIFIED |
| OPS-DEP-001 | M9-T01 | — | — | SPECIFIED |

Estados: `SPECIFIED`, `IMPLEMENTED`, `TESTED`, `VERIFIED`, `DEPRECATED`.

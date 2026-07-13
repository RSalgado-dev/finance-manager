# Estado atual

Atualizado em: `2026-07-12 22:52 America/Sao_Paulo`

## Estado do repositório

- M0: `VERIFIED`.
- M1: `VERIFIED`.
- M2: `IN_PROGRESS`.
- M2-T01: `DONE`.
- M2-T02 a M2-T08: `NOT_STARTED`.
- Branch `main`, commit base `5f91ce4`; working tree inicial limpa.
- Compose canônico: `app` ativo e `db` healthy.

## Última tarefa trabalhada

`M2-T01 — Company e constraints`.

Company foi entregue como raiz global do tenant, sem `company_id`, autenticação, membership, rota ou resolução de contexto.

## Migration e schema

- `db/migrate/20260713013500_create_companies.rb` é a primeira migration de domínio;
- chave primária UUID com default PostgreSQL `gen_random_uuid()`, já disponível sem extensão nova;
- `db/schema.rb` permanece no formato Ruby e representa corretamente índice funcional e checks;
- campos: `name`, `legal_name`, `slug`, `document`, `timezone`, `currency`, `cash_difference_tolerance_cents`, `active`, `suspended_at` e timestamps;
- ausentes deliberadamente: `company_id`, `week_starts_on` e todos os campos especulativos.

## Defaults e constraints

- timezone: `America/Sao_Paulo`;
- currency: `BRL`;
- cash_difference_tolerance_cents: `0` em bigint;
- active: `true`;
- índice único case-insensitive `index_companies_on_lower_slug` em `lower(slug)`;
- checks: `companies_name_not_blank`, `companies_slug_format`, `companies_timezone_not_blank`, `companies_currency_supported` e `companies_tolerance_non_negative`;
- nullability obrigatória no banco para nome, slug, timezone, currency, tolerância e active.

## Model e testes

- normalizações: strip de campos textuais, opcionais vazios para nil, slug lowercase e currency uppercase;
- slug explícito e estável, sem derivação de name;
- timezone validado como IANA por TZInfo;
- moeda limitada a BRL; tolerância inteira não negativa; active boolean;
- factory mínima apenas com sequences de name/slug;
- specs de model e banco: 28 exemplos finais, 0 falhas; constraints diretas usam `insert_all!`.

## Migration limpa e reversibilidade

- `company_finance_test` foi removido e recriado sem tocar em development;
- migration aplicada, revertida com `STEP=1`, tabela confirmada ausente e migration reaplicada;
- status final em development/test: `20260713013500 CreateCompanies` `up`;
- specs focados após reaplicação: 28/0.

## Verificações executadas

- baseline Current: 6/0;
- `SELECT gen_random_uuid()` em development/test: aprovado;
- RSpec completo: 78/0;
- RSpec aleatório: 78/0, seed `39929`;
- RuboCop: 49 arquivos, 0 offenses;
- Brakeman 8.0.5: 0 erros/0 warnings;
- Bundler Audit: 1.200 advisories/0 vulnerabilidades;
- Zeitwerk: aprovado;
- Tailwind 4.3.2 e assets: aprovados;
- runner real: UUID string e defaults confirmados; registro removido;
- rotas: nenhuma rota de empresa/platform/tenant adicionada;
- Gemfile/lock: sem diff;
- buscas: nenhum User, CompanyMembership, CompanyInvitation, `Current.company =`, rota ou associação futura;
- `bin/ci`: sucesso integral com 78/0;
- verificador normativo: 15 specs, 496 requisitos, zero falhas estruturais;
- `git diff --check`: aprovado após os registros finais.

## Falhas e correções

- primeira rodada focada: 28/1 por uso de `unique?` inexistente na spec de metadados do índice;
- inspeção da API retornou `unique=true` e expressão `lower((slug)::text)`; expectativa corrigida e repetição 28/0;
- revisão final corrigiu duas frases obsoletas do README que ainda negavam qualquer persistência de Company;
- nenhuma falha funcional do model ou banco permaneceu.

## Limitações deliberadas

- sem validação completa de CNPJ ou normalização destrutiva de documento;
- sem operação/callback/policy/auditoria de suspensão; services futuros coordenarão `active` e `suspended_at`;
- sem associações a classes inexistentes;
- sem autenticação, usuários, memberships, convites, `Current.company`, tenant resolution, controllers, views, seeds ou novas gems;
- `DATA-COMPANY-002` permanece operacionalmente `SPECIFIED` até os services futuros de suspensão/reativação.

## Arquivos alterados

- `app/models/company.rb`;
- `db/migrate/20260713013500_create_companies.rb`;
- `db/schema.rb`;
- `spec/factories/companies.rb`;
- `spec/models/company_spec.rb`;
- `spec/models/company_database_constraints_spec.rb`;
- `docs/company-model.md`;
- `README.md`;
- `planning/tasks/M2-identity-and-tenancy.md`;
- `planning/ROADMAP.md`;
- `planning/TRACEABILITY.md`;
- `planning/SESSION_LOG.md`;
- `planning/CURRENT.md`.

## Questões, riscos e alterações não commitadas

- nenhuma questão aberta bloqueia o próximo passo;
- riscos tenant/cross-tenant permanecem para as tabelas filhas e tarefas já mapeadas; Company é raiz global e não usa FK composta;
- alterações não commitadas limitam-se aos arquivos acima;
- nenhum commit, push, merge, reset ou limpeza destrutiva foi executado.

## Próxima ação exata

Em nova sessão, executar o protocolo inicial e detalhar `M2-T02 — User e autenticação` antes de qualquer implementação.

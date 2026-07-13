# M2 — Identidade e tenancy

Dependência do milestone: M1 `VERIFIED`.

## M2-T01 — Company e constraints

Status: `DONE`

### Objetivo

Entregar `Company` como raiz global do isolamento lógico, com UUID, campos mínimos, normalizações conservadoras, validações e constraints PostgreSQL efetivas, sem implementar identidade, memberships, autenticação ou resolução de tenant.

### Requisitos relacionados

- `DATA-COMPANY-001`, `DATA-COMPANY-002`
- `USR-001` a `USR-005`
- `TEN-001`, `TEN-002`, `TEN-006`
- `ARCH-020`, `ARCH-022`, `ARCH-024`, `ARCH-025`
- `ARCH-DATA-002`, `ARCH-DATA-003`, `ARCH-DATA-013`
- `TEST-000`, `TEST-001`, `TEST-007`, `TEST-EVID-001`

### Dependências

- M0 e M1 `VERIFIED`.

### Dentro do escopo

- primeira migration de domínio, criando somente `companies` com UUID;
- campos e defaults normativos de Company;
- normalização de espaços, slug lowercase e moeda uppercase;
- validações de nome, slug, timezone IANA, moeda BRL e tolerância inteira não negativa;
- checks PostgreSQL nomeados para strings obrigatórias, slug, moeda e tolerância;
- índice funcional único global em `lower(slug)`;
- factory mínima, model specs e specs diretas de integridade do banco;
- validação da migration em banco test limpo, rollback e reaplicação;
- documentação concisa do model e atualização de rastreabilidade/planejamento.

### Fora do escopo

- User, autenticação, senha, session, CompanyMembership e CompanyInvitation;
- `Current.company`, resolução por slug, middleware, rotas tenant/platform e autorização;
- controllers, views, formulários, serializers, APIs, seeds ou services;
- operações/callbacks de suspensão ou reativação, auditoria e máquina de estados;
- associações com classes futuras, `company_id` em Company ou foreign keys compostas;
- validação completa/consulta externa de CNPJ ou normalização destrutiva de documento;
- `week_starts_on`, endereço, contato, cobrança, logo, JSONB, soft delete ou campos especulativos;
- gems ou extensões PostgreSQL novas;
- M2-T02 e tarefas posteriores.

### Critérios de aceite

- [x] Tarefa detalhada e checkpoint registrado antes da migration/model.
- [x] M2 e M2-T01 estão `IN_PROGRESS` durante a implementação.
- [x] `Company` existe e `companies` usa UUID gerado pelo PostgreSQL.
- [x] Company não possui `company_id`, `week_starts_on` ou campo não especificado.
- [x] Campos normativos e defaults existem no banco.
- [x] `name` é obrigatório, normalizado e não precisa ser único.
- [x] `legal_name` e `document` são opcionais, conservadores e normalizados sem validação inventada.
- [x] slug é obrigatório, lowercase, adequado para URL e não é gerado/alterado a partir do nome.
- [x] formato do slug é protegido no model e por check PostgreSQL nomeado.
- [x] unicidade global case-insensitive do slug é garantida por índice funcional.
- [x] timezone é obrigatório, usa identificador IANA válido e tem default `America/Sao_Paulo`.
- [x] currency é obrigatória, normalizada, limitada a `BRL` e tem check no banco.
- [x] tolerância usa `bigint`, default zero e rejeita negativos no model e banco.
- [x] `active` é boolean obrigatório com default true; `suspended_at` permanece opcional.
- [x] consistência operacional entre `active`/`suspended_at` está documentada como responsabilidade futura, sem callback/service nesta tarefa.
- [x] factory mínima existe sem usuários, memberships ou traits especulativas.
- [x] model specs cobrem estrutura, defaults, normalizações, formatos e validações.
- [x] specs de integridade ignoram validações Rails e provam constraints PostgreSQL.
- [x] migration aplica em banco test vazio, reverte e reaplica.
- [x] schema representa UUID, defaults, nullability, índice funcional e checks.
- [x] UUID/defaults foram confirmados por runner com registro real.
- [x] nenhum controller, rota, policy, service, associação futura ou `Current.company` foi criado.
- [x] nenhuma gem ou extensão PostgreSQL foi adicionada.
- [x] RSpec normal e aleatório, RuboCop, Brakeman, Bundler Audit e Zeitwerk passam.
- [x] Tailwind/assets e `bin/ci` passam.
- [x] documentação, rastreabilidade e registros da sessão estão atualizados.
- [x] verificador normativo e `git diff --check` passam.

### Plano técnico

1. Confirmar estado vazio, UUID/generator, schema Ruby e baseline de testes.
2. Registrar M2/M2-T01 `IN_PROGRESS` e checkpoint pré-migration.
3. Criar migration explícita de `companies`, sem extensão, com defaults, checks e índice funcional.
4. Implementar model pequeno com normalizações e validações locais.
5. Adicionar factory, model specs e specs de constraints diretas.
6. Migrar development/test e executar conjunto focado.
7. Recriar banco test, migrar, reverter apenas M2-T01 e reaplicar; revisar `db/schema.rb`.
8. Documentar limites e executar verificações finais completas.
9. Registrar evidência real; marcar M2-T01 `DONE` somente se todos os critérios passarem, mantendo M2 `IN_PROGRESS`.

### Riscos e casos de borda

- índice simples não impedir duplicidade por caixa; usar expressão `lower(slug)` e inspecionar schema;
- check de slug divergir do regex Ruby; usar a mesma linguagem de formato e casos focados;
- APIs Active Support aceitarem nomes amigáveis em vez de IANA; validar com TZInfo diretamente;
- normalização converter `nil` indevidamente; testar opcionais e strings vazias;
- bigint converter valor decimal antes da validação; testar valor não inteiro observando `before_type_cast`;
- teste de uppercase poder falhar pelo check de formato antes do índice; também inspecionar definição do índice funcional;
- rollback atingir infraestrutura; bancos principais não possuem migrations e a prova será limitada à migration M2-T01 no banco test;
- `schema.rb` não representar índice de expressão; confirmar antes de considerar mudança de formato;
- implementar prematuramente `DATA-COMPANY-002`; nesta tarefa não há operação de suspensão e a consistência será coordenada por services futuros, conforme instrução explícita da sessão.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bin/rails db:migrate
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test bin/rails db:prepare
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec spec/models/company_spec.rb spec/models/company_database_constraints_spec.rb
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec --order random
docker compose -f .devcontainer/compose.yaml exec app bundle exec rubocop
docker compose -f .devcontainer/compose.yaml exec app bundle exec brakeman --no-pager
docker compose -f .devcontainer/compose.yaml exec app bundle exec bundler-audit check --update
docker compose -f .devcontainer/compose.yaml exec app bin/rails zeitwerk:check
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test bin/rails tailwindcss:build
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
docker compose -f .devcontainer/compose.yaml exec app bin/ci
bash scripts/check_spec_requirements.sh
git diff --check
git status --short
```

Também executar runner de UUID/defaults, inspeção de rotas/escopo, diff de gems e ciclo isolado `db:drop` → `db:create` → `db:migrate` → `db:rollback STEP=1` → `db:migrate` no ambiente test.

### Evidência parcial

Checkpoint pré-migration em 2026-07-12:

- branch `main`, commit `5f91ce4`, working tree limpa; `app` ativo e `db` healthy;
- M0/M1 `VERIFIED`; M2 e todas as tarefas inicialmente `NOT_STARTED`;
- nenhum model/tabela/migration de domínio, schema principal ou factory existente;
- generator configurado com `primary_key_type: :uuid`; formato de schema permanece Ruby por default;
- `SELECT gen_random_uuid()` aprovado em development e test, sem extensão nova;
- baseline `spec/models/current_spec.rb`: 6 exemplos, 0 falhas;
- `db:migrate:status`: zero migrations em development e test;
- M2/M2-T01 registrados `IN_PROGRESS` antes de criar migration ou model.

### Evidência de conclusão

Concluída em 2026-07-12:

- implementação: `Company`, migration `20260713013500_create_companies`, schema Ruby, factory, 28 specs focados e documentação;
- banco: UUID por `gen_random_uuid()` já disponível, sem extensão nova; defaults `America/Sao_Paulo`, `BRL`, zero e `true` no PostgreSQL;
- slug: normalização lowercase/strip, regex no model, check `companies_slug_format` e índice funcional único `index_companies_on_lower_slug`;
- checks adicionais: `companies_name_not_blank`, `companies_timezone_not_blank`, `companies_currency_supported` e `companies_tolerance_non_negative`;
- model: timezone por TZInfo/IANA, moeda somente BRL, tolerância inteira não negativa, opcionais conservadores e nenhuma associação/callback/service;
- falha corrigida: primeira rodada focada teve 28 exemplos/1 falha porque a spec usava o predicate inexistente `unique?`; inspeção mostrou `IndexDefinition#unique == true` e `columns == "lower((slug)::text)"`; segunda rodada passou 28/0;
- banco test limpo: drop/create, migration, rollback `STEP=1`, confirmação de ausência de `companies`, reaplicação e specs 28/0 aprovados;
- runner real: Company recebeu UUID string e defaults corretos; registro temporário removido;
- RSpec completo: 78 exemplos, 0 falhas; aleatório: 78 exemplos, 0 falhas, seed `39929`;
- RuboCop: 49 arquivos, 0 offenses; Brakeman 8.0.5: 0 erros/0 warnings; Bundler Audit: 1.200 advisories/0 vulnerabilidades;
- Zeitwerk, Tailwind 4.3.2, assets e boot: aprovados;
- `bin/ci`: sucesso integral com 78 exemplos/0 falhas;
- escopo: rotas inalteradas, Gemfile/lock sem diff, nenhuma classe/rota/associação/`Current.company` de tarefa posterior;
- host: verificador normativo com 15 specs/496 requisitos/zero falhas e `git diff --check` aprovado.

### Próximo passo

Em nova sessão, executar o protocolo inicial e detalhar `M2-T02 — User e autenticação` antes de qualquer implementação; M2-T02 permanece `NOT_STARTED` nesta sessão.

---

## M2-T02 — User e autenticação

Status: `NOT_STARTED`

## M2-T03 — CompanyMembership

Status: `NOT_STARTED`

## M2-T04 — Resolução de tenant por slug

Status: `NOT_STARTED`

## M2-T05 — Seleção e redirecionamento de empresa

Status: `NOT_STARTED`

## M2-T06 — Convites, e-mails de identidade e recuperação de senha

Status: `NOT_STARTED`

Inclui modelo `CompanyInvitation`, envio, reenvio, revogação, aceite e e-mails de convite/recuperação. Não depende de M7.

## M2-T07 — Testes adversariais de isolamento

Status: `NOT_STARTED`

## M2-T08 — Eventos críticos e observacionais de identidade

Status: `NOT_STARTED`

Referências: `specs/20-domains/companies-and-users.md`, `specs/10-architecture/system-architecture.md`, `specs/10-architecture/security-and-authorization.md`, `specs/10-architecture/authorization-matrix.md`.

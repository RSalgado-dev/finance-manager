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

Status: `DONE`

### Objetivo

Entregar identidade global por `User`, sessões revogáveis persistidas e autenticação web por e-mail/senha, integrada a `Current.user` e protegendo controllers por padrão, sem implementar memberships, recuperação, tenant ou autorização.

### Requisitos relacionados

- `PRD-SCOPE-001`, `PRD-SUCCESS-006`, `PRD-SUCCESS-007`
- `DATA-USER-001`, `DATA-USER-002`
- `USR-010`, `USR-011`, `USR-015`
- `AUTH-001`, `AUTH-002`, `AUTH-005`, `AUTH-006`, `AUTH-008`
- `SEC-001` a `SEC-003`, `SEC-006`, `SEC-008`, `SEC-012`, `SEC-013`, `SEC-016` a `SEC-018`
- `TEN-008`
- `ARCH-020`, `ARCH-DATA-001`, `ARCH-DATA-002`, `ARCH-DATA-013`
- `TEST-000`, `TEST-001`, `TEST-003`, `TEST-006`, `TEST-007`, `TEST-EVID-001`

### Dependências

- M0 e M1 `VERIFIED`.
- M2-T01 `DONE`.

### Dentro do escopo

- inspecionar generator oficial Rails 8.1 sem aplicá-lo e adaptar seletivamente seu desenho;
- bcrypt `~> 3.1`, `User` e `Session` globais com UUID;
- validações e constraints PostgreSQL para identidade, papel e integridade de sessões;
- login, logout, cookie assinado `session_id`, mitigação de fixation e retorno local seguro;
- concern `Authentication` deny-by-default e controllers públicos declarados explicitamente;
- preenchimento somente de `Current.user`, preservando o ciclo de `RequestContext`;
- bloqueio genérico de usuário inativo, inclusive sessão persistida existente;
- atualização explícita de `last_sign_in_at` somente no sucesso;
- view de login e navegação pública/autenticada acessíveis e responsivas;
- factories e specs de model, banco, request, view/helper quando necessário e system;
- migrations reversíveis em banco test limpo, documentação e rastreabilidade.

### Fora do escopo

- cadastro público, CRUD/admin de usuários, bootstrap de platform admin ou seeds com senha;
- CompanyMembership, CompanyInvitation, convites, primeiro acesso e papéis empresariais;
- recuperação/alteração de senha, tokens, mailers ou rotas de password;
- `Current.company`, `Current.membership`, `Current.session`, seleção/resolução de tenant;
- Pundit, policies, autorização por papel, platform UI e empresa suspensa;
- MFA, login social, confirmação de e-mail, JWT, remember-me, timeout/refresh/fingerprint;
- rate limiting, auditoria persistida e tarefas M2-T03+;
- qualquer gem além de bcrypt.

### Critérios de aceite

- [x] Tarefa detalhada e checkpoint pré-Gemfile/migration registrado.
- [x] M2-T02 está `IN_PROGRESS` durante a implementação; M2-T03+ permanecem `NOT_STARTED`.
- [x] Generator Rails foi inspecionado por help, pretend e templates sem aplicar alterações.
- [x] `Current` preserva exatamente seus seis atributos e `RequestContext` não é substituído.
- [x] bcrypt é a única dependência nova e reset token está desabilitado.
- [x] User global usa UUID e não possui `company_id`.
- [x] nome é obrigatório, normalizado, preserva capitalização e respeita limite coerente.
- [x] e-mail é obrigatório, normalizado, básico/limitado e único case-insensitive no banco.
- [x] senha usa digest BCrypt, mínimo 12, máximo BCrypt e confirmação quando fornecida.
- [x] `system_role` string aceita somente `user`/`platform_admin`, com default e check.
- [x] `active` é boolean obrigatório/default true; `last_sign_in_at` é opcional.
- [x] Session global usa UUID, pertence a User e não possui `company_id`.
- [x] FK impede órfã e `ON DELETE CASCADE` remove sessões com User.
- [x] Authentication protege controllers por default e oferece opt-out público explícito.
- [x] Home e SessionsController declaram acesso público aplicável; `/up` permanece funcional.
- [x] login válido cria nova Session após `reset_session`, emite cookie seguro e atualiza sign-in.
- [x] login inválido/inativo usa a mesma mensagem e não cria Session/atualiza timestamp.
- [x] retomada de sessão exige registro existente e User ativo; sessão inativa é invalidada localmente.
- [x] logout destrói somente a sessão atual, remove cookie e limpa sessão Rails.
- [x] retorno pós-login aceita somente caminho local seguro e não permite open redirect.
- [x] Current.user existe durante action autenticada e é limpo após resposta/exceção.
- [x] Current.company/membership permanecem nulos e não existe Current.session.
- [x] cookie contém apenas UUID da Session, é assinado, httponly, lax e secure em produção.
- [x] tela de login e navegação cumprem semântica, teclado, foco, autocomplete e 360 px.
- [x] não existe cadastro público, recuperação, rota/mailer/token de senha ou rota auxiliar produtiva.
- [x] factories mínimas e testes de model/banco/request/system passam.
- [x] migrations aplicam em banco test vazio; rollback STEP=2 preserva Company; reaplicação passa.
- [x] schema representa UUIDs, defaults, checks, índice funcional, FK/cascade e ausência de company_id.
- [x] RSpec normal/aleatório, RuboCop, Brakeman, Bundler Audit e Zeitwerk passam.
- [x] Tailwind/assets e `bin/ci` passam.
- [x] documentação, rastreabilidade, verificador normativo e `git diff --check` passam.

### Plano técnico

1. Confirmar baseline de Company/Current, rotas, configuração de segurança e ausência de identidade.
2. Detalhar a tarefa e registrar checkpoint antes de Gemfile/migrations.
3. Executar `authentication --help/--pretend`, localizar e ler integralmente templates Rails 8.1.
4. Adicionar somente bcrypt e migrations explícitas de users/sessions.
5. Implementar models, constraints, factories e specs focados.
6. Integrar Authentication com RequestContext/Current e testar ordem/cleanup.
7. Implementar SessionsController, rotas, login, logout, cookie, return path, view e navegação.
8. Adicionar request/system specs e corrigir apenas defeitos reproduzidos.
9. Validar banco test limpo, rollback de duas migrations preservando Company e reaplicação.
10. Documentar e executar verificações completas; marcar DONE somente com todos os critérios verdes.

### Riscos e casos de borda

- generator oficial usar `email_address`, `Current.session`, password reset/Minitest ou IDs incompatíveis; servir apenas como referência;
- ordem de concerns limpar `Current.user` cedo ou perder metadados; provar dentro/fora da action e em exceção;
- `has_secure_password` habilitar reset token por default no Rails 8; passar `reset_token: false` e testar API ausente;
- enum string levantar antes da validação; combinar API explícita com check PostgreSQL e specs;
- cookie não expor flags no request spec de modo portátil; inspecionar headers/configuração sem confiar em parser inadequado;
- `reset_session` invalidar o return path; capturar caminho seguro antes e consumir depois;
- redirect externo entrar por session/params; armazenar somente `request.fullpath` local e validar novamente;
- Session antiga de User inativo persistir; destruir somente a atual e apagar cookie;
- delete cascade e `dependent: :destroy` divergirem; testar diretamente no banco;
- rollback STEP=2 remover Company por ordem/timestamp incorreta; confirmar status e tabela antes/depois;
- mensagens/logs enumerarem e-mail ou senha; usar mensagem única e filtros existentes.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bin/rails generate authentication --help
docker compose -f .devcontainer/compose.yaml exec app bin/rails generate authentication --pretend
docker compose -f .devcontainer/compose.yaml exec app bundle install
docker compose -f .devcontainer/compose.yaml exec app bin/rails db:migrate
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test bin/rails db:prepare
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

Também executar runner BCrypt/reset-token, inspeção de rotas/produção, buscas negativas, diff de gems e ciclo do banco test `drop/create/migrate/rollback STEP=2/migrate` preservando Company.

### Evidência parcial

Checkpoint pré-Gemfile/migration em 2026-07-12:

- branch `main`, commit `0776786`, working tree limpa; `app` ativo e `db` healthy;
- M0/M1 `VERIFIED`, M2 `IN_PROGRESS`, M2-T01 `DONE`, M2-T02..T08 inicialmente `NOT_STARTED`;
- Company/constraints revalidadas com Current: 34 exemplos, 0 falhas; migration Company `up` em test;
- ausentes User, Session, CompanyMembership, CompanyInvitation, autenticação e tabelas correspondentes;
- Current fonte preserva os seis atributos de M1; primeiro runner de introspecção falhou porque Rails 8.1 não oferece `Current.attribute_names`, confirmação refeita pela declaração/leitores;
- PostgreSQL respondeu `SELECT 1`; configuração atual mantém CSRF, filtros `:passw`/`:email`/`:token`, SSL/secure cookies em produção e Action Mailer sem fluxo de senha;
- tarefa detalhada antes de alterar Gemfile, migrations ou código.
- generator help/pretend e templates Rails/Tailwind/RSpec inspecionados; nenhuma alteração gerada foi aplicada;
- desenho oficial rejeitado onde conflitava: `Current.session`, `email_address`, password reset/mailer/rotas, rate limiting, Action Cable e arquivos de teste genéricos;
- desenho aproveitado seletivamente: sessão persistida, cookie assinado e concern deny-by-default.

### Evidência de conclusão

- generator Rails 8.1.3 inspecionado por `--help`, `--pretend` e templates; nenhum arquivo gerado foi aplicado e `Current`/`RequestContext` foram preservados;
- somente bcrypt 3.1.22 foi adicionada; User e Session globais usam UUID, não possuem `company_id` e têm constraints PostgreSQL, índice funcional de e-mail e FK cascade descritos no schema;
- `has_secure_password reset_token: false`, limites 12..72, enum string validado e autenticação genérica de User inativo foram provados por model/request specs e runner;
- concern deny-by-default, login/logout, cookie assinado `session_id`, fixation, retorno local, `last_sign_in_at`, revogação e integração restrita a `Current.user` foram cobertos por request/controller specs;
- tela e navegação foram revalidadas em Chromium quanto a fluxo, teclado, autocomplete, 360 px e overflow;
- banco test limpo migrou; rollback `STEP=2` removeu apenas users/sessions, preservou companies e a reaplicação deixou as três migrations `up`;
- falhas intermediárias reproduzidas e corrigidas: transação PostgreSQL abortada por múltiplas violações no mesmo exemplo; `Set-Cookie` array no Rails 8.1; helper isolado ausente em view specs;
- specs focados de model/banco 35/0; rodada integrada 51/0; RSpec completo 129/0; aleatório 129/0 seed `56260`; system specs Chromium 10/0;
- RuboCop 64 arquivos/0 offenses; Brakeman 0 warnings; Bundler Audit 1.200 advisories/0 vulnerabilidades; Zeitwerk, Tailwind 4.3.2, assets e `bin/ci` aprovados;
- rotas produtivas restritas a session singular, `/`, `/up` e engines Rails; buscas negativas confirmaram ausência de M2-T03+, recovery, Devise/JWT e atribuições tenant;
- verificador normativo: 15 specs, 496 requisitos, zero falhas; `git diff --check` aprovado.

### Próximo passo

Em nova sessão, executar o protocolo inicial e detalhar `M2-T03 — CompanyMembership` antes de qualquer implementação; não iniciar convites, tenant resolution ou autorização junto dela.

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

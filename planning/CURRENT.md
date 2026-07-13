# Estado atual

Atualizado em: `2026-07-12 23:47 America/Sao_Paulo`

## Estado do repositório

- M0 e M1: `VERIFIED`.
- M2: `IN_PROGRESS`.
- M2-T01 e M2-T02: `DONE`.
- M2-T03 a M2-T08: `NOT_STARTED`.
- Branch `main`, commit base `0776786`.
- Compose ao encerrar: `app` ativo e `db` healthy.
- Working tree contém somente as alterações não commitadas de M2-T02 e seus registros de planejamento; nenhum commit, push, merge ou reset foi executado.

## Última tarefa trabalhada

`M2-T02 — User e autenticação`, concluída nesta sessão.

### Entrega

- `User` global com UUID, name, email, password_digest, active, system_role, last_sign_in_at e timestamps, sem `company_id`;
- `Session` global com UUID, user_id UUID, IP/user agent opcionais e timestamps, sem `company_id`;
- bcrypt 3.1.22 como única dependência nova, `has_secure_password reset_token: false`, senha entre 12 e 72 bytes;
- e-mail normalizado por strip/lowercase, índice único `lower(email)`, constraints de strings e roles;
- roles globais string `user`/`platform_admin`, default `user`; active obrigatório/default true;
- FK sessions→users com `ON DELETE CASCADE`; nenhuma sessão órfã;
- login/logout com Session persistida, atualização de `last_sign_in_at` somente no sucesso e mensagem genérica para falhas/inatividade;
- cookie assinado `session_id` contendo apenas UUID da Session, httponly, same_site lax e secure em produção;
- `reset_session` antes do login e validação dupla de retorno local para mitigar fixation/open redirect;
- Authentication deny-by-default; Home e SessionsController explicitamente públicos onde aplicável;
- retomada exige Session existente e User ativo; sessão corrente de User inativo é destruída e o cookie removido;
- somente `Current.user` é atribuído durante a action; os seis atributos originais, metadados e cleanup normal/exceção de RequestContext permanecem intactos;
- view pública de login e navegação anônima/autenticada responsivas, acessíveis e sem funcionalidades futuras.

### Migrations e integridade

- `20260713021900_create_users.rb`;
- `20260713022000_create_sessions.rb`;
- UUID via mecanismo PostgreSQL já configurado, sem extensão nova;
- checks nomeados para name/email/password_digest não vazios e system_role suportado;
- índice funcional global case-insensitive de e-mail;
- nullability/defaults e cascade representados em `db/schema.rb`;
- banco test foi drop/create/migrate; rollback `STEP=2` removeu users/sessions, preservou companies e reaplicação deixou as três migrations `up`.

## Problemas encontrados e correções

1. A primeira rodada de model/banco terminou 29/1 porque duas violações SQL no mesmo exemplo deixavam a transação PostgreSQL abortada. Cada constraint passou a ter exemplo isolado; resultado final focado 35/0.
2. A primeira rodada integrada terminou 51/1 porque Rails 8.1 entrega `Set-Cookie` como array no request spec. O teste passou a unir/normalizar o header; resultado final 51/0.
3. A primeira suíte completa terminou 129/3 porque view specs isolados não recebem helpers do ApplicationController. O contexto de teste passou a declarar estado anônimo explicitamente; código produtivo não foi alterado e a suíte final passou 129/0.

## Verificações executadas

- protocolo inicial: working tree limpa, branch `main`, commit `0776786`, app ativo/db healthy;
- baseline Company/Current: 34 exemplos, 0 falhas; PostgreSQL `SELECT 1` aprovado;
- generator: `authentication --help`, `--pretend` e templates Rails/Tailwind/RSpec lidos; nenhum arquivo aplicado;
- bundle/migrations: bcrypt 3.1.22 instalada; development/test migrados;
- model/banco focado: 35 exemplos, 0 falhas;
- integração focada: 51 exemplos, 0 falhas;
- RSpec completo: 129 exemplos, 0 falhas;
- RSpec aleatório: 129 exemplos, 0 falhas; seed `56260`;
- system specs Chromium: 10 exemplos, 0 falhas;
- RuboCop: 64 arquivos, zero offenses;
- Brakeman 8.0.5: zero erros e zero security warnings;
- Bundler Audit: 1.200 advisories, zero vulnerabilidades;
- Zeitwerk: aprovado;
- Tailwind 4.3.2 e assets precompile: aprovados;
- runner BCrypt: UUID/digest/autenticação aprovados, plaintext ausente e reset token não habilitado;
- rotas development/production: somente session singular, `/`, `/up` e engines Rails; rotas `__test__` ausentes em produção;
- buscas negativas: sem Current.session, recovery, rotas de users/passwords, memberships, invitations, tenant assignment, Devise ou JWT;
- `bin/ci`: sucesso integral, incluindo RSpec 129/0, qualidade, segurança, assets e boot;
- verificador normativo: 15 specs, 496 requisitos, zero falhas;
- `git diff --check`: aprovado.

## Arquivos relevantes

- dependência/schema: `Gemfile`, `Gemfile.lock`, `db/schema.rb`, migrations users/sessions;
- domínio: `app/models/user.rb`, `app/models/session.rb`;
- autenticação: `app/controllers/concerns/authentication.rb`, `app/controllers/sessions_controller.rb`, Application/Home controllers e `config/routes.rb`;
- interface: view de login, navegação e texto institucional;
- testes: factories, specs de model/banco/controller/request/system e controllers exclusivos de test;
- documentação: `docs/authentication.md`, `docs/request-context.md`, `docs/ui-foundation.md`, README;
- planejamento: tarefa M2, ROADMAP, TRACEABILITY, SESSION_LOG e este arquivo.

## Limitações e riscos abertos

- sem cadastro/CRUD/bootstrap de usuário;
- sem CompanyMembership, CompanyInvitation, papéis empresariais, seleção/resolução de tenant ou Pundit;
- sem recuperação/alteração de senha, confirmação, MFA, login social ou JWT;
- timeout avançado, rate limiting, revogação global e auditoria persistida permanecem para hardening/tarefas futuras;
- nenhum bloqueio aberto para M2-T02.

## Próxima ação exata

Em uma nova sessão, executar o protocolo inicial e detalhar `M2-T03 — CompanyMembership` usando o template antes de criar migration ou código. Não iniciar CompanyInvitation, resolução de tenant ou autorização junto dela.

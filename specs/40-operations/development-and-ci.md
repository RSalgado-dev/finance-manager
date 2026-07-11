# Desenvolvimento e CI

## Ambiente local

- `OPS-LOCAL-001 MUST` Fornecer Dockerfile multi-stage reutilizável no desenvolvimento e build de produção.
- `OPS-LOCAL-002 MUST` Fornecer Compose de desenvolvimento com web, PostgreSQL e worker.
- `OPS-LOCAL-003 MUST` Configurar healthchecks no ambiente local.
- `OPS-LOCAL-004 MUST` Fornecer `.dockerignore`.
- `OPS-LOCAL-005 MUST` Fornecer `.env.example` sem secrets.
- `OPS-LOCAL-006 MUST` Documentar setup local com poucos comandos.
- `OPS-LOCAL-007 MUST` Documentar alternativa de desenvolvimento sem Docker.

- `OPS-LOCAL-008 SHOULD` Suportar o fluxo local:

```bash
cp .env.example .env
docker compose build
docker compose up
```

## Seeds

- `OPS-DEV-001 MUST` Seeds ser idempotentes.
- `OPS-DEV-002 MUST` Criar duas empresas e papéis variados.
- `OPS-DEV-003 MUST` Criar dados dos últimos 12 meses.
- `OPS-DEV-004 MUST` Não executar dados demo automaticamente em produção.
- `OPS-DEV-005 MUST` Credenciais demo existir apenas em desenvolvimento.

## Jobs e e-mails

- `OPS-DEV-010 MUST` Usar Solid Queue.
- `OPS-DEV-011 MUST` Configurar SMTP por ambiente.
- `OPS-DEV-012 MUST` Permitir inspeção local de e-mails.
- `OPS-DEV-013 MUST` Jobs tenant-scoped receber `company_id`.
- `OPS-DEV-014 MUST` Implementar convites, recuperação e limpeza de tokens.

## CI

- `OPS-CI-004 MUST` Executar no CI, com versões compatíveis e comandos equivalentes aos reais do projeto:

```bash
bundle install
bin/rails db:test:prepare
bundle exec rspec
bundle exec rubocop
bundle exec brakeman
bundle exec bundler-audit check --update
```

- `OPS-CI-001 MUST` Não ignorar falha de teste, lint ou segurança.
- `OPS-CI-002 SHOULD` Usar cache de dependências.
- `OPS-CI-003 MUST` Fixar versões por lockfile.

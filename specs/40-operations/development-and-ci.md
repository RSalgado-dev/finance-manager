# Desenvolvimento e CI

## Ambiente local

O projeto deve fornecer:

- Dockerfile multi-stage;
- Compose com web, PostgreSQL e worker;
- healthchecks;
- `.dockerignore`;
- `.env.example`;
- setup com poucos comandos;
- instrução alternativa sem Docker.

Fluxo desejado:

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

Executar:

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

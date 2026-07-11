# Deploy e operação

## Objetivo

- `OPS-DEP-000 MUST` Preparar a aplicação para plataforma compatível com containers e documentar exemplo para Render ou equivalente.

## Requisitos

- `OPS-DEP-001 MUST` Construir imagem de produção.
- `OPS-DEP-002 MUST` Precompilar assets.
- `OPS-DEP-003 MUST` Rodar migrations de forma controlada.
- `OPS-DEP-004 MUST` Executar worker separado quando necessário.
- `OPS-DEP-005 MUST` Usar PostgreSQL gerenciado ou persistente.
- `OPS-DEP-006 MUST` Usar storage S3 ou compatível para anexos.
- `OPS-DEP-007 MUST NOT` Usar disco efêmero para comprovantes.
- `OPS-DEP-008 MUST` Expor healthcheck.
- `OPS-DEP-009 MUST` Forçar SSL.
- `OPS-DEP-010 MUST` Documentar rollback.
- `OPS-DEP-011 MUST` Documentar backup e restauração.
- `OPS-DEP-012 MUST` Emitir logs em stdout.

## Variáveis esperadas

- `OPS-DEP-020 MUST` Documentar e configurar, quando aplicáveis, as seguintes variáveis sem versionar seus valores secretos:

```text
RAILS_ENV
RAILS_MASTER_KEY
DATABASE_URL
APP_HOST
APP_PROTOCOL
SECRET_KEY_BASE
PLATFORM_ADMIN_NAME
PLATFORM_ADMIN_EMAIL
PLATFORM_ADMIN_PASSWORD
SMTP_ADDRESS
SMTP_PORT
SMTP_USERNAME
SMTP_PASSWORD
SMTP_DOMAIN
STORAGE_SERVICE
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_BUCKET
```

- `OPS-DEP-021 MUST` Fazer README e o guia final de deployment em `docs/` refletirem os nomes realmente implementados.

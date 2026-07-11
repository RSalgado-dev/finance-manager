# Segurança, autenticação e autorização

## Autenticação

- `AUTH-001 MUST` Permitir login por e-mail e senha.
- `AUTH-002 MUST` Permitir logout.
- `AUTH-003 MUST` Permitir redefinição segura de senha.
- `AUTH-004 MUST` Implementar convite e primeiro acesso.
- `AUTH-005 MUST NOT` Permitir cadastro público.
- `AUTH-006 MUST` Bloquear usuários inativos.
- `AUTH-007 MUST` Bloquear uso de empresas suspensas por usuários comuns.
- `AUTH-008 MUST` Evitar enumeração evidente de e-mails.
- `AUTH-009 MUST` Expirar tokens de convite e recuperação.
- `AUTH-010 MUST` Criar administrador global por comando idempotente e variáveis de ambiente.

Variáveis:

```text
PLATFORM_ADMIN_NAME
PLATFORM_ADMIN_EMAIL
PLATFORM_ADMIN_PASSWORD
```

## Autorização

- `AUTHZ-000 MUST` Usar Pundit ou mecanismo equivalente explicitamente aprovado e implementar integralmente `specs/10-architecture/authorization-matrix.md`.

As descrições dos atores em produto são contextuais. A matriz normativa é a fonte verificável para cada combinação de recurso, ação, estado e papel; permissões não listadas são negadas.

## Controles obrigatórios

- `SEC-001 MUST` Proteger contra CSRF.
- `SEC-002 MUST` Usar cookies seguros em produção.
- `SEC-003 MUST` Prevenir session fixation.
- `SEC-004 MUST` Aplicar headers de segurança.
- `SEC-005 MUST` Aplicar rate limiting a login, recuperação, convites e exports.
- `SEC-006 MUST` Autorizar todos os controllers e actions.
- `SEC-007 MUST` Prevenir IDOR por escopo tenant e policy.
- `SEC-008 MUST` Prevenir mass assignment.
- `SEC-009 MUST` Validar tipo e tamanho de uploads.
- `SEC-010 MUST` Armazenar anexos de forma privada.
- `SEC-011 MUST` Usar URLs temporárias para anexos.
- `SEC-012 MUST` Não mostrar stack traces em produção.
- `SEC-013 MUST` Usar secrets por ambiente.
- `SEC-014 MUST` Ativar SSL forçado em produção.
- `SEC-015 MUST` Configurar CSP compatível.
- `SEC-016 MUST` Prevenir open redirect.
- `SEC-017 MUST` Não registrar dados sensíveis.
- `SEC-018 MUST` Executar Brakeman e Bundler Audit.

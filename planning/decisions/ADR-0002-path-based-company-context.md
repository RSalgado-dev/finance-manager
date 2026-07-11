# ADR-0002 — Contexto da empresa por path e slug

Status: `ACCEPTED`

## Contexto

É necessário representar a empresa ativa na navegação. As alternativas principais são subdomínio, path com slug e path com ID.

## Decisão

Usar `/c/:company_slug/...`.

## Motivos

- configuração local e de produção mais simples;
- não exige wildcard DNS ou certificados específicos;
- permite seleção explícita de empresa;
- slug é legível;
- migração futura para subdomínio permanece possível.

## Segurança

O slug não é autorização. A aplicação deve:

1. localizar a empresa;
2. validar membership ativa;
3. definir `Current.company`;
4. carregar recursos por associação;
5. aplicar policy.

## Alternativas rejeitadas

- `/companies/:id`: funcional, mas menos legível e incentiva exposição de identificador;
- subdomínio: adiciona complexidade sem benefício necessário na primeira versão.

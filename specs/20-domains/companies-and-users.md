# Empresas, usuários e memberships

## Empresas

- `USR-001 MUST` Platform admin pode criar, editar, ativar, suspender e reativar empresa.
- `USR-002 MUST` Slug deve ser único, validado e adequado para URL.
- `USR-003 MUST` Empresa suspensa preserva dados.
- `USR-004 MUST` Empresa suspensa impede acesso comum.
- `USR-005 MUST` Configurações de timezone, moeda, semana e tolerância pertencem à empresa.

## Usuários

- `USR-010 MUST` E-mail é único globalmente e normalizado.
- `USR-011 MUST` Um usuário pode pertencer a várias empresas.
- `USR-012 MUST` Usuário com uma empresa ativa é redirecionado diretamente para ela.
- `USR-013 MUST` Usuário com múltiplas empresas vê seletor.
- `USR-014 MUST` Usuário sem empresa disponível recebe estado informativo, sem acesso tenant.
- `USR-015 MUST` Usuários podem ser ativados e desativados sem apagar histórico.

## Memberships

- `USR-020 MUST` Membership define papel e estado do vínculo.
- `USR-021 MUST` Não permitir duplicidade de membership.
- `USR-022 MUST` Company admin só gerencia memberships da própria empresa.
- `USR-023 MUST` Não permitir remover ou desativar o último `company_admin` ativo.
- `USR-024 MUST` Mudanças de papel gerar auditoria.
- `USR-025 MUST` Convites de empresa só podem atribuir papéis permitidos pelo ator.

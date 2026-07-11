# Empresas, usuários e memberships

## Empresas

- `USR-001 MUST` Platform admin pode criar, editar, ativar, suspender e reativar empresa.
- `USR-002 MUST` Slug deve ser único, validado e adequado para URL.
- `USR-003 MUST` Empresa suspensa preserva dados.
- `USR-004 MUST` Empresa suspensa impede acesso comum.
- `USR-005 MUST` Configurações de timezone, moeda e tolerância de diferença pertencem à empresa; o início da semana não é configurável na primeira versão.

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

## Convites

- `INV-001 MUST` Representar convite tenant-scoped por `CompanyInvitation` com empresa, e-mail destinatário normalizado, papel solicitado, token digest, expiração, aceite, revogação, ator convidador e timestamps.
- `INV-002 MUST` Derivar o estado do convite como `pending`, `accepted`, `expired` ou `revoked`, sem permitir retorno a `pending` após estado terminal.
- `INV-003 MUST` Exibir o token em texto puro apenas no envio e persistir somente seu digest.
- `INV-004 MUST` Expirar todo convite em `expires_at` e permitir revogação explícita antes do aceite.
- `INV-005 MUST` Invalidar o token anterior ao reenviar; convite ainda pendente pode receber novo digest transacionalmente, enquanto convite expirado deve ser revogado e substituído por novo registro.
- `INV-006 MUST` Aceitar convite em transação que cria ou reutiliza o usuário e cria a membership sem duplicidade.
- `INV-007 MUST` Falhar com mensagem compreensível quando o destinatário já possuir membership na empresa.
- `INV-008 MUST NOT` Alterar o destinatário do convite quando o e-mail do usuário for modificado após a emissão.
- `INV-009 MUST NOT` Permitir que o ator convide para papel superior ao que sua autorização permite.
- `INV-010 MUST` Auditar criticamente emissão, reenvio, revogação e aceite quando alterarem acesso.

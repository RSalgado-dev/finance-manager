# Plataforma global e auditoria

## Painel global

- `PLAT-001 MUST` Exibir empresas ativas e suspensas.
- `PLAT-002 MUST` Exibir usuários totais e ativos.
- `PLAT-003 SHOULD` Exibir atividade recente e empresas inativas.
- `PLAT-004 MUST` Permitir criação da empresa com primeiro administrador em operação transacional.
- `PLAT-005 MUST` Permitir visualizar memberships.
- `PLAT-006 MUST` Permitir suporte com acesso auditado.
- `PLAT-007 MUST` Isolar layout e rotas sob `/platform`.

## Auditoria

Registrar:

- login e logout;
- falhas relevantes de autenticação;
- criação, suspensão e reativação de empresa;
- criação, convite, ativação e desativação de usuário;
- mudança de papéis;
- eventos de fechamento;
- eventos de despesa;
- exportação;
- acesso de platform admin a dados de empresa.

- `AUD-001 MUST` Audit logs financeiros não ser editáveis pela interface.
- `AUD-002 MUST` Permitir filtros por empresa, usuário, ação, entidade e período.
- `AUD-003 MUST` Paginar logs.
- `AUD-004 MUST` Permitir `company_id` nulo para evento global.
- `AUD-005 MUST` Permitir `user_id` nulo para evento de sistema.
- `AUD-006 MUST NOT` Registrar senha, token, cookie, secret ou conteúdo integral de anexo.
- `AUD-007 MUST` Capturar request ID, IP e user agent quando disponíveis.
- `AUD-008 MUST` Auditoria não pode impedir silenciosamente transação crítica; falhas devem ser tratadas explicitamente conforme desenho da operação.

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

- `AUD-010 MUST` Registrar como eventos observacionais login, logout, tentativas de autenticação e visualizações comuns selecionadas.
- `AUD-011 MUST` Registrar criticamente suspensão e reativação de empresa.
- `AUD-012 MUST` Registrar criticamente convite, aceite, revogação, ativação e desativação de membership e mudança de papel.
- `AUD-013 MUST` Registrar criticamente criação, alteração e toda transição de fechamento.
- `AUD-014 MUST` Registrar criticamente criação, pagamento e cancelamento de despesa.
- `AUD-015 MUST` Registrar exportação como evento operacional obrigatório.
- `AUD-016 MUST` Registrar criticamente acesso de platform admin a dados financeiros de empresa.
- `AUD-017 MUST` Registrar criticamente toda ação administrativa que altere autorização.

- `AUD-001 MUST NOT` Permitir edição ou exclusão de qualquer AuditLog pela interface ou por métodos comuns da aplicação.
- `AUD-002 MUST` Permitir filtros por empresa, usuário, ação, entidade e período.
- `AUD-003 MUST` Paginar logs.
- `AUD-004 MUST` Permitir `company_id` nulo para evento global.
- `AUD-005 MUST` Permitir `user_id` nulo para evento de sistema.
- `AUD-006 MUST NOT` Registrar senha, token, cookie, secret ou conteúdo integral de anexo.
- `AUD-007 MUST` Capturar request ID, IP e user agent quando disponíveis.
- `AUD-008 MUST` Executar auditoria crítica na mesma transação da operação e impedir a operação correspondente quando a gravação do AuditLog falhar.
- `AUD-009 MUST` Testar imutabilidade, filtragem de dados sensíveis e rollback causado por falha de auditoria crítica.
- `AUD-018 MUST` Permitir que eventos observacionais sejam gravados fora de transação de domínio, mantendo falhas observáveis em logs operacionais sem dados sensíveis.

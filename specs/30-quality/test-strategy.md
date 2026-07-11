# Estratégia de testes

## Ferramentas

- `TEST-000 MUST` Usar RSpec, FactoryBot e Capybara, salvo ADR aceito que altere a escolha.

## Cobertura por camada

- `TEST-001 MUST` Model specs para validações, associações, fórmulas e estados.
- `TEST-002 MUST` Policy specs para papéis e operações.
- `TEST-003 MUST` Request specs para autenticação, tenancy, CRUDs, filtros e CSV.
- `TEST-004 MUST` Service specs para transições financeiras.
- `TEST-005 MUST` Query specs para relatórios, regimes, períodos e timezone.
- `TEST-006 MUST` System specs para fluxos críticos.
- `TEST-007 MUST` Testes de migration/constraint para integridade não garantida apenas pelo Rails.

## Cenários de sistema mínimos

1. `TEST-SYS-001 MUST` Platform admin cria empresa e primeiro administrador.
2. `TEST-SYS-002 MUST` Company admin cria caixa.
3. `TEST-SYS-003 MUST` Operator cria e envia fechamento.
4. `TEST-SYS-004 MUST` Manager aprova fechamento.
5. `TEST-SYS-005 MUST` Despesa é criada, enviada e paga.
6. `TEST-SYS-006 MUST` Relatório mensal mostra valores corretos nos dois regimes.
7. `TEST-SYS-007 MUST` Usuário tenta acessar recurso de outra empresa.
8. `TEST-SYS-008 MUST` Empresa suspensa não utiliza aplicação.
9. `TEST-SYS-009 MUST` Reabertura remove fechamento das receitas até nova aprovação.
10. `TEST-SYS-010 MUST` Cancelamento retroativo remove despesa dos resultados recalculados.

## Isolamento tenant

- `TEST-TEN-001 MUST` Usar ao menos duas empresas.
- `TEST-TEN-002 MUST` Testar listagens.
- `TEST-TEN-003 MUST` Testar acesso por ID válido de outro tenant.
- `TEST-TEN-004 MUST` Testar dashboard.
- `TEST-TEN-005 MUST` Testar relatórios.
- `TEST-TEN-006 MUST` Testar exports.
- `TEST-TEN-007 MUST` Testar buscas e filtros.
- `TEST-TEN-008 MUST` Testar jobs.
- `TEST-TEN-009 MUST` Testar anexos.

## Regra de evidência

- `TEST-EVID-001 MUST` Cada tarefa listar:

- comando executado;
- resultado;
- testes adicionados;
- critérios cobertos.

- `TEST-EVID-002 MUST NOT` Usar mocks como substitutos da persistência real em regras financeiras.
- `TEST-TEN-010 MUST` Tentar persistir foreign keys cross-tenant diretamente no banco e esperar rejeição pela constraint.
- `TEST-AUD-001 MUST` Testar que falha de auditoria crítica reverte a operação de domínio.
- `TEST-AUD-002 MUST` Testar que AuditLog não pode ser atualizado ou destruído pela aplicação.
- `TEST-REQ-001 MUST` Executar a checagem automatizada de IDs, referências e requisitos normativos antes de concluir revisão de especificação.

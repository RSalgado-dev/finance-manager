# Estratégia de testes

## Ferramentas

RSpec, FactoryBot e Capybara, salvo ADR que altere a escolha.

## Cobertura por camada

- `TEST-001 MUST` Model specs para validações, associações, fórmulas e estados.
- `TEST-002 MUST` Policy specs para papéis e operações.
- `TEST-003 MUST` Request specs para autenticação, tenancy, CRUDs, filtros e CSV.
- `TEST-004 MUST` Service specs para transições financeiras.
- `TEST-005 MUST` Query specs para relatórios, regimes, períodos e timezone.
- `TEST-006 MUST` System specs para fluxos críticos.
- `TEST-007 MUST` Testes de migration/constraint para integridade não garantida apenas pelo Rails.

## Cenários de sistema mínimos

1. platform admin cria empresa e primeiro administrador;
2. company admin cria caixa;
3. operator cria e envia fechamento;
4. manager aprova;
5. despesa é criada e paga;
6. relatório mensal mostra valores corretos;
7. usuário tenta acessar recurso de outra empresa;
8. empresa suspensa não utiliza aplicação.

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

Cada tarefa deve listar:

- comando executado;
- resultado;
- testes adicionados;
- critérios cobertos.

Mocks não substituem persistência real para regras financeiras.

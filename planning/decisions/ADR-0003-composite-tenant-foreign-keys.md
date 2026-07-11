# ADR-0003 — Foreign keys compostas para integridade tenant-scoped

Status: `ACCEPTED`

## Contexto

O `ADR-0001` determina banco e schema compartilhados e exige `company_id` em toda entidade do tenant. O modelo repete esse campo em filhos para scoping e índices, mas foreign keys apenas pelo UUID não impedem que um filho da empresa A referencie um pai da empresa B.

Policies e consultas por associação impedem acesso indevido no caminho esperado, porém não protegem contra bugs em services, jobs, imports, console ou manutenção direta. RLS está explicitamente fora da primeira versão.

## Decisão

Para associações entre duas entidades tenant-scoped:

1. manter `company_id` em pai e filho;
2. criar chave candidata ou índice único em `[company_id, id]` no pai;
3. criar foreign key composta de `[company_id, foreign_id]` no filho para `[company_id, id]` no pai;
4. criar índices tenant-first adequados às consultas;
5. manter validações Rails, resolução por `Current.company`, policies e testes com duas empresas.
6. testar tentativas de persistência cross-tenant diretamente no banco, sem depender de validações Rails;
7. documentar e testar controles equivalentes para associações polimórficas ou relações sem suporte à mesma estratégia direta no PostgreSQL.

Aplicar inicialmente a:

- `CashClosing -> CashRegister`;
- `CashMovement -> CashClosing`;
- `Expense -> ExpenseCategory`;
- `Expense -> Supplier`, quando presente.

Relações com `User` continuam globais. A aplicação deve validar que atores tenant-scoped possuem vínculo e permissão apropriados, pois essa regra não cabe em uma foreign key simples.

## Consequências

- o banco rejeita referências cross-tenant mesmo quando a aplicação falha;
- migrations e schemas ficam mais explícitos;
- associações Rails continuam convencionais, mas testes de migration/constraint são obrigatórios;
- operações de troca de `company_id` tornam-se deliberadamente restritas;
- não substitui policy, scoping ou testes adversariais.

## Alternativas

- confiar apenas em validações e policies: rejeitada na proposta por não proteger todos os caminhos de escrita;
- usar triggers: possível, porém menos declarativo e mais difícil de manter;
- remover `company_id` dos filhos e derivá-lo do pai: prejudica scoping, índices e a regra permanente do repositório;
- ativar RLS: fora do escopo da primeira versão por `TEN-012` e `ADR-0001`.

## Registro da decisão

Aceito em 2026-07-11 por decisão explícita do responsável do produto. As migrations permanecem fora do escopo de `M0-T01`; os requisitos devem ser implementados e testados nas tarefas de modelo correspondentes.

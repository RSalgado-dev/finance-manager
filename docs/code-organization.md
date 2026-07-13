# Organização do código de aplicação

## Objetivo e estado atual

Este documento define convenções mínimas para controllers, models, services, queries e policies. O objetivo é manter limites claros quando o domínio começar a ser implementado, sem criar um framework interno.

Os nomes de classes apresentados aqui são exemplos futuros. Nenhum deles está implementado nesta etapa. Atualmente, os diretórios canônicos existem apenas com `.keep`.

## Escolha da camada

| Camada | Responsabilidade principal | Não deve fazer |
|---|---|---|
| Controller | autenticar, resolver contexto, autorizar, normalizar parâmetros, chamar uma operação/consulta e selecionar a resposta | coordenar transações críticas, fórmulas, SQL complexo ou vários saves dependentes |
| Model | associações, validações locais, invariantes da entidade, cálculos intrínsecos, scopes simples e estado local | acessar request, formatar interface, enviar e-mail diretamente ou coordenar vários agregados |
| Service/command | representar uma ação relevante e coordenar mudança de estado, dependências, transação e efeitos | renderizar, redirecionar, manipular flash ou depender de params/request/session/cookies |
| Query object | encapsular filtros, joins, agregações e cálculos de leitura reutilizáveis | modificar dados, autorizar, formatar interface ou obter tenant implicitamente |
| Policy | responder se um ator pode tentar uma ação sobre um recurso e restringir o conjunto visível | modificar dados, auditar, iniciar transação ou substituir invariantes/constraints |

Scopes simples e locais podem permanecer no model. Services e queries só devem surgir quando um caso concreto não couber claramente nas responsabilidades existentes.

## Estrutura canônica

```text
app/services/
app/queries/
app/policies/

spec/services/
spec/queries/
spec/policies/
```

Rails reconhece automaticamente os diretórios sob `app/` no autoloader. Não adicionar esses caminhos manualmente a `autoload_paths` ou `eager_load_paths`.

Exemplos futuros de organização, não implementados:

```text
app/services/cash_closings/approve.rb
app/queries/reports/financial_summary_query.rb
app/policies/cash_closing_policy.rb

spec/services/cash_closings/approve_spec.rb
spec/queries/reports/financial_summary_query_spec.rb
spec/policies/cash_closing_policy_spec.rb
```

## Services e commands

### Quando usar

Criar um service quando uma ação concreta:

- coordena mais de um model ou persistência dependente;
- altera estado ou representa uma transição;
- exige uma unidade transacional explícita;
- aplica precondições/invariantes que envolvem mais de uma entidade;
- grava auditoria crítica;
- agenda job ou notificação;
- representa uma ação nomeada do usuário.

Exemplos futuros de nomes, não implementados:

```text
Companies::CreateWithAdministrator
CashClosings::Submit
CashClosings::Approve
CashClosings::Reopen
CashClosings::Cancel
Expenses::MarkAsPaid
Expenses::Cancel
Memberships::ChangeRole
```

Usar verbo/ação e namespace do domínio. Evitar nomes vagos como `CashClosingService`, `ExpenseManager`, `CompanyHandler` ou `FinancialProcessor`.

### Contrato

Um service futuro deve:

- ser uma classe Ruby simples;
- receber dependências e contexto relevante por argumentos nomeados no construtor;
- expor uma operação pública principal, normalmente `call`;
- manter auxiliares privados;
- validar precondições no servidor;
- ser independente de parâmetros de controller;
- retornar o registro ou valor produzido no sucesso;
- levantar erro específico e esperado quando a operação não puder ser concluída;
- deixar erros inesperados de programação/infraestrutura propagarem;
- não resgatar `StandardError` genericamente;
- não esconder o fluxo principal em callbacks.

Não existe objeto genérico `Result`. Validações Active Record podem usar suas exceções próprias quando isso representar corretamente a falha. Uma abstração de resultado só será reconsiderada diante de casos concretos repetidos.

### Transações e efeitos externos

A transação pertence à operação que conhece a unidade atômica. Controllers não coordenam transações de negócio.

Usar transação quando houver:

- múltiplas persistências dependentes;
- transição crítica de estado;
- auditoria crítica obrigatória;
- atualização que precise ser confirmada ou revertida como unidade.

Não envolver indiscriminadamente leituras ou persistências isoladas. A auditoria crítica deve ser gravada na mesma transação; se falhar, a operação deve reverter conforme o ADR-0004.

Não executar e-mail externo, HTTP externo ou processamento demorado dentro da transação sem justificativa específica. Jobs/notificações devem ser enfileirados após commit quando necessário.

## Multi-tenancy e dependências explícitas

`Current` representa contexto na borda da execução; não é service locator. Services tenant-scoped recebem explicitamente empresa, membership, ator ou um recurso já tenant-scoped.

Exemplo futuro aceitável, não implementado:

```ruby
CashClosings::Approve.new(
  company: company,
  cash_closing: cash_closing,
  actor: current_user
).call
```

Outra assinatura pode receber `membership:` quando ela carregar o contexto/autoridade necessária. A escolha deve ser guiada pelo caso concreto, não por uma base genérica.

Regras permanentes:

- não aceitar `company_id` diretamente de parâmetros do usuário;
- não buscar recurso tenant-scoped globalmente por UUID;
- não usar `unscoped`;
- validar que recursos relacionados pertencem à mesma empresa;
- manter foreign keys compostas e constraints como defesa independente;
- não tratar `Current.company` como substituto de argumentos explícitos;
- definir contrato distinto para operação global de plataforma e operação tenant-scoped.

Jobs devem receber IDs explícitos, reconstruir contexto dentro da execução e limpá-lo ao final, conforme `docs/request-context.md`.

## Query objects

### Quando usar

Criar query object quando uma consulta concreta:

- possui múltiplos filtros ou combinações relevantes;
- exige joins, subqueries ou agregações;
- é reutilizada por dashboard, HTML e CSV;
- precisa de testes próprios;
- não cabe claramente em scope simples;
- implementa cálculo canônico compartilhado.

Exemplos futuros, não implementados:

```text
CashClosings::FilterQuery
Expenses::FilterQuery
Reports::FinancialSummaryQuery
Reports::ExpensesByCategoryQuery
Reports::CashDifferencesQuery
Dashboard::MonthlyMetricsQuery
```

Queries usam nome descritivo terminado em `Query`.

### Contrato

Uma query futura deve:

- ser classe Ruby simples;
- receber uma relation base já autorizada e tenant-scoped;
- receber filtros por argumentos nomeados;
- expor uma operação principal, normalmente `call`;
- retornar `ActiveRecord::Relation` enquanto tecnicamente possível;
- permanecer composável;
- executar filtros/agregações no banco, evitando `to_a`, `each` e cálculo Ruby desnecessário;
- preservar `company_id` nos joins e condições relevantes;
- evitar N+1;
- não modificar dados, autorizar, paginar por decisão própria, formatar moeda/data ou gerar CSV/HTML.

Exemplo futuro correto, não implementado:

```ruby
Expenses::FilterQuery.new(
  relation: company.expenses,
  filters: filters
).call
```

Uma query tenant-scoped não deve omitir `relation:` e começar internamente por `Expense.all`. Também não deve obter empresa implicitamente de `Current`.

Dashboard, relatório HTML e CSV devem consumir os mesmos query objects ou a mesma camada canônica de cálculo. Fórmulas financeiras não podem ser duplicadas em controllers, helpers, presenters, views ou exports.

Paginação pertence à camada de apresentação/integração enquanto não houver motivo concreto para incorporá-la à query. A infraestrutura de paginação pertence a M1-T04.

## Policies futuras

Pundit ainda não está instalado. Policies e policy specs só serão criadas no milestone de autorização com recursos e atores reais.

Uma policy futura deve:

- negar por padrão;
- receber ator e recurso;
- declarar cada ação explicitamente;
- validar membership ativa, empresa correta e estado do recurso quando aplicável;
- tratar platform admin explicitamente;
- impedir elevação de privilégio;
- não confiar em slug/UUID;
- não modificar dados, auditar, iniciar transação ou renderizar resposta;
- não depender exclusivamente de `Current`.

Policy scopes futuros devem começar por relation, restringir por tenant/papel/ator, evitar `unscoped` e carregamento em memória, e ser testados com pelo menos duas empresas.

### Separação obrigatória

```text
Policy: o ator pode tentar esta ação sobre este recurso?
Service: a operação é válida no estado atual e pode ser concluída atomicamente?
Constraints/FKs: o banco aceita esta estrutura de dados?
```

As três camadas são complementares. Policy não substitui precondições do service; service não substitui autorização; ambas não substituem constraints tenant-scoped.

## Erros esperados

Erros esperados devem ser específicos e viver próximos ao namespace da operação. Exemplos futuros, não implementados:

```text
CashClosings::InvalidTransition
CashClosings::SelfApprovalNotAllowed
Expenses::AlreadyCanceled
Memberships::LastAdministratorRemoval
TenantMismatchError
```

Não foi criado `ApplicationError`: hoje não existe comportamento compartilhado, uso imediato ou tratamento comum que justifique uma base. Erros não devem mascarar bugs ou falhas inesperadas; services não resgatam `StandardError` genericamente.

Uma hierarquia mínima só será considerada quando classes concretas repetirem comportamento verificável, como metadados seguros ou mapeamento consistente para respostas.

## Controllers

Controllers futuros devem:

- autenticar e resolver contexto na borda;
- autorizar;
- normalizar parâmetros permitidos;
- chamar service ou query;
- selecionar formato/resposta;
- renderizar ou redirecionar.

Não devem conter fórmulas financeiras, SQL complexo, transições diretas, múltiplos saves críticos, filtros duplicados ou auditoria manual dispersa.

## Models

Models futuros devem conter associações, validações locais, invariantes da entidade, cálculos intrínsecos, scopes simples e métodos de estado sem coordenação externa.

Não devem conter lógica de controller, formatação de interface, request, envio direto de e-mail, consultas extensas de relatório ou coordenação de múltiplos agregados. Concerns genéricos não serão criados sem comportamento compartilhado concreto.

## Auditoria e jobs

Operações críticas devem criar auditoria na mesma transação. O service define a unidade atômica; falha do AuditLog reverte a mudança. O payload deve usar allowlist e excluir senha, token, cookie, secret e conteúdo de anexos.

Eventos observacionais podem seguir contrato diferente conforme ADR-0004, mas falhas continuam observáveis sem dados sensíveis.

Jobs tenant-scoped recebem `company_id` explícito, localizam a empresa no job, usam `Current.set` em bloco controlado e limpam o contexto. Não herdam contexto da request nem recebem objetos completos serializados. Efeitos que dependem do commit são enfileirados após commit.

## Estratégia de testes por camada

Não criar specs para classes inexistentes. Quando houver casos concretos:

### Service specs

- sucesso e valor retornado;
- precondições e estados inválidos;
- transação e rollback;
- auditoria crítica e rollback quando ela falha;
- tenant mismatch;
- efeitos colaterais e enqueue após commit;
- idempotência quando aplicável.

Operações financeiras usam banco real de teste; mocks não substituem persistência, constraints ou transações.

### Query specs

- cada filtro e combinações relevantes;
- duas empresas e ausência de vazamento;
- períodos/timezone e fronteiras locais;
- ausência de dados e total zero;
- agregações e comparação de períodos;
- consistência entre consumidores;
- SQL/planos/N+1 quando relevante.

### Policy specs

- todos os papéis;
- empresa correta e diferente;
- membership ativa e inativa;
- empresa suspensa;
- estado do recurso;
- platform admin e suporte;
- elevação de privilégio;
- scopes com pelo menos duas empresas.

Specs de migration/constraint devem provar rejeição cross-tenant diretamente no banco, independentemente das validações Rails.

## Anti-patterns proibidos

- services genéricos chamados `Manager`, `Handler` ou `Processor`;
- classes com `.call` apenas para esconder uma linha sem comportamento relevante;
- controller coordenando transação financeira;
- query começando por `.all` para recurso tenant-scoped;
- query autorizando ou formatando interface;
- policy alterando estado ou duplicando toda a máquina de estados;
- `Current` como origem implícita de dependências;
- `unscoped`, `default_scope` de tenancy ou busca global por UUID;
- callbacks com efeitos colaterais ocultos;
- resgate genérico de `StandardError`;
- agregação financeira em Ruby quando o banco pode executá-la;
- fórmula duplicada entre dashboard, relatório e CSV;
- e-mail/HTTP/processamento longo dentro de transação sem justificativa;
- spec fictícia para classe ainda inexistente.

## Abstrações deliberadamente não criadas

Não existem e não devem ser adicionadas sem casos concretos repetidos:

- `ApplicationService`, `BaseService`, `ApplicationCommand` ou `Callable`;
- `ApplicationQuery` ou `BaseQuery`;
- objeto genérico `Result`, `Success`/`Failure` ou monads;
- DSL de transições, pipelines ou macros de operação;
- service locator ou registry;
- container de injeção de dependências;
- hierarquia base de erros sem comportamento compartilhado;
- `ApplicationPolicy` ou policies antes da instalação/configuração de Pundit.

Cada item só poderá ser reconsiderado quando houver problema concreto, múltiplos usos e benefício testável. Decisões arquiteturais relevantes devem ser registradas conforme o `AGENTS.md`.

## Decisões adiadas

- instalação/configuração de Pundit e policies reais: milestone de autorização;
- primeira assinatura concreta de cada service/query: tarefa do domínio correspondente;
- hierarquia de erros e Result object: somente após repetição real;
- paginação e normalização compartilhada de filtros: M1-T04;
- abstração de jobs tenant-scoped: quando existir o primeiro job concreto;
- ferramentas de medição de SQL/planos: quando as queries centrais existirem.

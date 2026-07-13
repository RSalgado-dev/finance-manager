# AGENTS.md — Instruções permanentes do repositório

## Missão

Construir e manter uma aplicação web multi-tenant para gestão financeira operacional de empresas, seguindo as especificações versionadas neste repositório.

Este arquivo contém apenas regras permanentes de trabalho. Requisitos de produto, arquitetura detalhada e tarefas ficam em `specs/` e `planning/`.

## Idioma e convenções

- Código, nomes de classes, tabelas, colunas, métodos, commits e identificadores: inglês.
- Interface, mensagens para usuários e documentação funcional: português do Brasil.
- Valores monetários: inteiros em centavos com colunas `bigint` terminadas em `_cents`.
- Datas e cálculos por período devem respeitar o timezone da empresa.
- Não usar `float` para dinheiro.
- Preferir código Rails explícito, convencional e testável.
- Não introduzir microserviços, SPA separada, CQRS, event sourcing ou abstrações genéricas sem necessidade comprovada.

## Fontes de verdade

Em caso de conflito, use esta ordem:

1. Instrução explícita do usuário na sessão atual.
2. ADR aceito em `planning/decisions/`.
3. Especificações em `specs/`.
4. Critérios da tarefa ativa em `planning/tasks/`.
5. Testes automatizados.
6. Código existente.
7. Suposições do agente.

Uma decisão dada apenas no chat não deve ficar efêmera. Antes de encerrar a sessão, registre-a na especificação, em um ADR ou na tarefa correspondente.

Não altere uma especificação para fazer o código parecer correto. Quando código e especificação divergirem, registre a divergência e implemente a especificação, salvo decisão explícita em contrário.

## Leitura obrigatória no início de toda sessão

Antes de editar código:

1. Execute `git status --short` e identifique branch e alterações não commitadas.
2. Leia integralmente:
   - `AGENTS.md`;
   - `specs/README.md`;
   - `planning/CURRENT.md`;
   - `planning/ROADMAP.md`;
   - a tarefa indicada como ativa em `planning/CURRENT.md`;
   - ADRs citados pela tarefa ativa.
3. Consulte somente as especificações referenciadas pela tarefa ativa. Expanda a leitura se detectar dependências.
4. Inspecione o código e os testes relacionados antes de propor mudanças.
5. Execute o menor conjunto de verificações capaz de estabelecer um baseline.
6. Resuma internamente:
   - estado atual;
   - tarefa ativa;
   - critérios de aceite;
   - riscos;
   - próximo incremento verificável.

Se houver uma tarefa `IN_PROGRESS`, retome-a. Não escolha outra tarefa apenas porque parece mais fácil.

Se o estado registrado contradizer o repositório, trate o repositório como evidência operacional e corrija `planning/CURRENT.md`, sem apagar o histórico.

## Seleção e execução do trabalho

- Trabalhe em apenas uma tarefa primária por sessão.
- A tarefa deve possuir identificador estável, por exemplo `M2-T03`.
- Não inicie uma tarefa cuja dependência esteja incompleta.
- Divida tarefas grandes antes de implementar.
- Cada sessão deve buscar um incremento vertical verificável, não uma grande quantidade de arquivos parcialmente concluídos.
- Não amplie o escopo sem registrar a necessidade.
- Não faça refatorações paralelas sem relação com a tarefa ativa.
- Não substitua implementação real por mocks, páginas estáticas ou TODOs quando o critério exige fluxo funcional.

## Política para especificações

Os arquivos em `specs/` são controlados.

Você pode corrigi-los diretamente apenas quando:

- a alteração foi explicitamente solicitada pelo usuário; ou
- é uma correção inequívoca de ortografia, link ou inconsistência interna sem mudança semântica.

Para mudanças de comportamento, arquitetura ou escopo:

1. registre a proposta em `planning/PROPOSALS.md`;
2. crie ou atualize um ADR quando for decisão arquitetural;
3. marque a tarefa como `BLOCKED` se a decisão impedir implementação correta;
4. não assuma aprovação silenciosa.

## Regras obrigatórias de multi-tenancy

- Toda entidade pertencente a uma empresa deve possuir `company_id`, foreign key e índices adequados.
- Nunca confiar em `company_id` vindo de formulário ou URL.
- Resolver a empresa no servidor e carregar recursos por associação, por exemplo `Current.company.expenses.find(...)`.
- Não usar `default_scope` para tenancy.
- Não usar `unscoped` sem justificativa, policy e teste explícitos.
- Policies, exports, dashboards, jobs, buscas e relatórios também devem ser tenant-scoped.
- Todo fluxo relevante deve possuir teste com pelo menos duas empresas.
- Slug e UUID não são barreiras de segurança.

## Segurança e integridade

- Aplicar autorização em todos os endpoints.
- Usar transações nas mudanças financeiras de estado.
- Usar optimistic locking nos registros financeiros editáveis.
- Não registrar senhas, tokens, cookies, secrets ou conteúdo integral de anexos.
- Não adicionar credenciais ao repositório.
- Não apagar fisicamente registros financeiros consolidados.
- Toda mudança crítica deve produzir auditoria conforme a especificação.
- Novas dependências de produção exigem justificativa registrada na tarefa.

## Organização das camadas

- Services tenant-scoped devem receber empresa, membership, ator ou recurso escopado explicitamente; `Current` não é service locator.
- Query objects devem receber uma relation já autorizada e tenant-scoped, sem iniciar implicitamente por `.all` ou por `Current.company`.
- Policies autorizam; services validam e coordenam a operação; foreign keys e constraints preservam a integridade no banco.
- Não criar classes base, Result objects, DSLs ou abstrações genéricas sem comportamento compartilhado real, imediato e testável.

## Testes e verificação

Uma tarefa não está concluída apenas porque o código foi escrito.

Para marcar `DONE`:

1. todos os critérios de aceite devem estar implementados;
2. os testes relevantes devem existir e passar;
3. lint e análise de segurança aplicáveis devem passar;
4. migrations devem funcionar em banco limpo quando alteradas;
5. documentação afetada deve estar atualizada;
6. não pode haver vazamento entre tenants;
7. a evidência deve estar registrada na tarefa.

Use o menor teste relevante durante o ciclo. Execute a suíte completa:

- ao concluir um milestone;
- após mudanças transversais;
- antes de declarar o projeto pronto para deploy.

Nunca afirme que um comando passou sem executá-lo. Registre comandos e resultados reais.

## Checkpoints durante a sessão

Não dependa apenas do encerramento normal da sessão.

Após cada incremento coerente e verificável, ou antes de iniciar uma operação longa:

1. atualize a evidência parcial da tarefa;
2. atualize `planning/CURRENT.md` com o próximo passo exato;
3. registre falhas ou decisões que não podem se perder;
4. mantenha o status como `IN_PROGRESS` até satisfazer todos os critérios.

Se o contexto estiver ficando extenso, se houver risco de interrupção ou se a tarefa tiver crescido além do previsto, pare de implementar e produza um handoff completo antes de continuar.

## Encerramento obrigatório de toda sessão

Antes de encerrar:

1. pare de iniciar trabalho novo;
2. execute as verificações adequadas;
3. atualize o status e a evidência da tarefa ativa;
4. atualize `planning/TRACEABILITY.md` quando requisitos, código ou testes forem adicionados;
5. acrescente uma entrada em `planning/SESSION_LOG.md`;
6. reescreva `planning/CURRENT.md` com:
   - estado preciso;
   - última tarefa trabalhada;
   - próximo passo exato;
   - arquivos relevantes;
   - comandos executados e resultados;
   - falhas conhecidas;
   - decisões pendentes;
   - alterações não commitadas;
7. deixe o repositório executável ou marque claramente `BROKEN_STATE` com recuperação exata;
8. não marque tarefa como concluída com testes falhando.

Não faça commit, push, merge, reset destrutivo, force push ou alteração de histórico sem autorização explícita do usuário.

## Formato da resposta final de cada sessão

Informe:

- tarefa trabalhada;
- resultado concreto;
- arquivos principais alterados;
- verificações executadas e resultados;
- pendências ou bloqueios;
- próximo passo registrado em `planning/CURRENT.md`.

Se algo não pôde ser verificado, diga exatamente o motivo.

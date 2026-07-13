# Contexto da execução atual

`Current` concentra somente referências e metadados válidos durante uma execução controlada. A classe herda de `ActiveSupport::CurrentAttributes`, que fornece armazenamento isolado pela unidade de execução do Rails e uma API explícita de atribuição/reset.

Esta infraestrutura não autentica usuários, não resolve empresas e não consulta o banco.

## Atributos

Referências reservadas para integrações futuras:

- `Current.user`;
- `Current.company`;
- `Current.membership`.

Metadados preenchidos nas requests atuais:

- `Current.request_id`;
- `Current.ip_address`;
- `Current.user_agent`.

Nenhum atributo possui default global. Identidade, empresa e membership permanecem `nil` até as tarefas que implementarem autenticação e tenancy.

## Ciclo de vida HTTP

`RequestContext`, incluído em `ApplicationController`, usa um `around_action`:

1. limpa qualquer contexto anterior antes de processar a request;
2. copia `request.request_id`, `request.remote_ip` e `request.user_agent` para um bloco `Current.set`;
3. executa a action e sua renderização dentro desse bloco;
4. executa `Current.reset` em `ensure`, inclusive quando a action gera exceção.

O reset explícito complementa o executor do Rails e torna o contrato verificável. Ele ocorre depois do bloco da action, não durante uma request válida. Callbacks, auditoria ou observabilidade futuros que precisem desses valores devem executar dentro do ciclo da action.

## Dados que não são armazenados

`Current` não recebe o objeto `request`, controller, parâmetros, headers completos, session, cookies, senha, token, secret ou conteúdo de anexos. Guardar o request inteiro aumentaria o tempo de retenção de dados, criaria acoplamento com HTTP e facilitaria acesso acidental a informações sensíveis.

IP e user agent podem ser dados pessoais ou identificadores indiretos. Eles existem apenas para a auditoria futura prevista nas especificações e não são adicionados automaticamente aos logs.

## Request ID e logging

Rails fornece `request.request_id`, normalmente definido pelo middleware nativo de request ID. A configuração de produção já usa `config.log_tags = [ :request_id ]`, sem incluir e-mail, IP, user agent, usuário ou empresa.

Esta tarefa não introduz logging estruturado. `Current.ip_address` e `Current.user_agent` não devem ser logados indiscriminadamente.

## Endereço remoto e proxies

O concern usa `request.remote_ip`, a API do Rails que considera a cadeia de proxies confiáveis configurada pelo framework. Não há parsing manual nem confiança direta em `X-Forwarded-For`.

A lista de proxies confiáveis depende da topologia real de produção e deverá ser revisada na tarefa de deploy. Até lá, nenhuma configuração específica de provedor é presumida.

## Isolamento e exceções

Specs demonstram que:

- reset remove todos os seis valores;
- `Current.set` restaura o estado anterior após sucesso e exceção;
- duas threads sincronizadas enxergam somente seus próprios valores;
- requests sequenciais não compartilham metadados;
- contexto é limpo depois de resposta normal e depois de exceção.

Testes também executam `Current.reset` no encerramento para impedir contaminação entre exemplos.

## Contrato futuro de autenticação e tenant

As tarefas futuras deverão seguir esta ordem:

1. autenticação validada preencherá `Current.user`;
2. a rota de empresa e a membership autenticada serão usadas para resolver `Current.company` no servidor;
3. a membership ativa e autorizada preencherá `Current.membership`;
4. policies e services consumirão esse contexto;
5. consultas continuarão tenant-scoped e relações serão validadas no backend e no banco quando aplicável.

`Current` não substitui autenticação, autorização, foreign keys, scoping por associação ou validações. Slug, UUID e a simples presença de `Current.company` não são barreiras de segurança.

## Contrato futuro para jobs

Jobs tenant-scoped deverão:

1. receber `company_id` explicitamente como argumento serializável;
2. localizar a empresa dentro da execução do job;
3. executar o trabalho dentro de `Current.set(company: company)`;
4. limpar o contexto ao final, inclusive após exceção;
5. nunca serializar objetos inteiros em `Current`;
6. nunca depender do contexto da request que enfileirou o job.

Nenhum helper ou job foi criado agora porque ainda não existe uso concreto. A implementação futura deve testar cleanup, retry e isolamento entre empresas.

## Limites atuais

- não há `User`, `Company`, `CompanyMembership` ou autenticação;
- não há resolução de slug, hostname, header ou session;
- não há persistência de auditoria;
- não há contexto automático para jobs;
- não há configuração específica de proxies de produção;
- não há logging de usuário, empresa, IP ou user agent.

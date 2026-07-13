# M1 — Fundação

Dependência do milestone: M0 concluído, incluindo Dev Container, scaffold Rails e CI inicial.

## M1-T01 — Layouts e design system mínimo

Status: `DONE`

### Objetivo

Entregar uma fundação visual mínima, reutilizável, responsiva e acessível para páginas públicas e para os futuros contextos de plataforma, empresa e impressão, sem simular funcionalidades ainda inexistentes.

### Requisitos relacionados

- `PRD-007`
- `ARCH-003`, `ARCH-004`, `ARCH-005`, `ARCH-008`, `ARCH-DESIGN-005`, `ARCH-DESIGN-006`
- `NFR-UI-001` a `NFR-UI-008`
- `NFR-MNT-001`, `NFR-MNT-002`, `NFR-MNT-003`
- `NFR-REL-003`
- `TEST-000`, `TEST-003`, `TEST-006`, `TEST-EVID-001`

### Dependências

- M0 `VERIFIED`.

### Dentro do escopo

- composição de layouts `application`, `public`, `platform`, `tenant` e `print` sem dependência de autenticação ou tenant;
- página institucional em português do Brasil e navegação mínima, mantendo `/up`;
- partials ou helpers explícitos para cabeçalho, flash, botões, cards, badges, estado vazio, tabela responsiva e erros de formulário;
- estilos Tailwind para superfícies, tipografia, formulários, feedback, foco, responsividade e impressão;
- testes request, helper/view e system proporcionais ao comportamento;
- documentação da fundação visual e seus limites.

### Fora do escopo

- autenticação, identidade, `CurrentAttributes`, tenancy, autorização ou rotas de plataforma/empresa;
- models, migrations, dados financeiros, dashboard, relatórios, gráficos, exports, uploads ou deploy;
- ViewComponent, React, Bootstrap, bibliotecas de UI/ícones, gems de formulário/breadcrumbs ou qualquer dependência nova;
- modo escuro, temas por empresa ou navegação de domínio;
- tarefas `M1-T02` a `M1-T05`.

### Critérios de aceite

- [x] Tarefa detalhada e checkpoint registrado antes de qualquer alteração de código.
- [x] M1 e M1-T01 ficaram `IN_PROGRESS` durante a implementação.
- [x] Layouts `application`, `public`, `platform`, `tenant` e `print` existem por composição, sem duplicação estrutural desnecessária.
- [x] Nenhum layout depende de autenticação, `Current` ou tenant.
- [x] Página institucional usa `public`, está em português e não simula funcionalidades futuras.
- [x] Navegação possui apenas marca, início e indicação não produtiva de desenvolvimento.
- [x] Cabeçalho de página suporta título, descrição e ações opcionais com hierarquia semântica.
- [x] Flash suporta sucesso, aviso, erro e informação com texto e semântica apropriada.
- [x] Botões/links possuem variantes primária, secundária, neutra, destrutiva e desabilitada.
- [x] Cards, badges textuais, estado vazio e tabela responsiva possuem estruturas reutilizáveis.
- [x] Erros de formulário mostram quantidade e mensagens em português.
- [x] Formulários, foco, contraste, teclado, landmarks e headings possuem base acessível.
- [x] Layout e CSS de impressão removem navegação/interações e preservam legibilidade.
- [x] Celular estreito, tablet e desktop não apresentam overflow indevido; tabelas possuem overflow explícito.
- [x] Layouts adicionais renderizam em teste sem rotas de produção extras.
- [x] Request spec cobre página inicial e preservação de `/up`.
- [x] Helper/view specs cobrem contratos semânticos relevantes.
- [x] System spec em Chromium confirma página inicial navegável.
- [x] Tailwind e assets compilam.
- [x] RSpec, RuboCop, Brakeman, Bundler Audit, Zeitwerk e `bin/ci` passam.
- [x] Requisições reais a `/` e `/up` retornam sucesso.
- [x] Documentação e rastreabilidade estão atualizadas.
- [x] Nenhuma gem, model, migration, rota futura ou funcionalidade de M1-T02+ foi adicionada.
- [x] Verificador normativo e `git diff --check` passam.

### Plano técnico

1. Registrar tarefa, estados e checkpoint de planejamento.
2. Criar a página institucional e a composição compartilhada dos cinco layouts.
3. Implementar helpers, partials e estilos mínimos, usando Stimulus somente se surgir necessidade real.
4. Adicionar cobertura request, helper/view e system, incluindo renderização isolada dos layouts.
5. Documentar contratos e limites da fundação visual.
6. Executar verificações incrementais e finais, inspecionar o diff e registrar evidência.

### Riscos e casos de borda

- duplicar `<html>`, `<head>` ou `<main>` entre layouts em vez de compor a estrutura;
- criar abstrações sem uso concreto ou testar classes Tailwind em excesso;
- esconder status ou feedback somente por cor;
- introduzir links/rotas que antecipem autenticação ou domínio;
- tabelas e grupos de ações causarem overflow em telas estreitas;
- partial de erros assumir exclusivamente Active Record em vez de contrato Active Model;
- layout de impressão herdar navegação ou controles interativos;
- testes de layouts exigirem rotas de produção artificiais.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
docker compose -f .devcontainer/compose.yaml exec app bundle exec rubocop
docker compose -f .devcontainer/compose.yaml exec app bundle exec brakeman --no-pager
docker compose -f .devcontainer/compose.yaml exec app bundle exec bundler-audit check --update
docker compose -f .devcontainer/compose.yaml exec app bin/rails zeitwerk:check
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test bin/rails tailwindcss:build
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
docker compose -f .devcontainer/compose.yaml exec app bin/ci
bash scripts/check_spec_requirements.sh
git diff --check
git status --short
```

Também executar requisições reais a `/` e `/up` dentro do container, pois o Compose não publica a porta por padrão.

### Evidência de conclusão

Concluída em 2026-07-12:

- arquivos alterados: layouts e partial de navegação em `app/views/layouts/`; elementos em `app/views/shared/`; `HomeController`/home/rota; `ApplicationHelper`; Tailwind e locale; specs request/helper/view/system; `docs/ui-foundation.md`, README e planejamento;
- testes adicionados: request spec da home e `/up`, helper specs de flash/botão/badge/erros, view specs de partials e dos cinco layouts, e system specs de navegação/responsividade em Chromium;
- RSpec: 23 exemplos, 0 falhas;
- RuboCop: 34 arquivos, 0 offenses;
- Brakeman 8.0.5: 0 erros e 0 security warnings;
- Bundler Audit: advisory DB com 1.200 advisories, 0 vulnerabilidades;
- Zeitwerk: aprovado;
- Tailwind 4.3.2 e assets: compilação/precompile aprovados;
- `bin/ci`: sucesso integral após a última alteração de código;
- requisições reais dentro do container: `/` e `/up` retornaram HTTP 200;
- verificador normativo: 15 specs, 496 requisitos e zero falhas estruturais;
- `git diff --check`: aprovado;
- falhas tratadas: quatro expectativas/locale na primeira rodada de componentes; system spec detectou CSS precompilado anterior em 360 px e passou após o `assets:precompile` obrigatório;
- escopo: nenhuma gem, model, migration, rota de plataforma/tenant ou funcionalidade de M1-T02+ adicionada.

### Próximo passo

Em nova sessão, detalhar M1-T02 pelo template antes de iniciá-la; M1-T02 permanece não iniciada nesta sessão.

---

## M1-T02 — CurrentAttributes e contexto de request

Status: `DONE`

### Objetivo

Entregar uma infraestrutura explícita, isolada e testável para o contexto da execução atual, disponibilizando referências futuras de identidade/tenant e metadados mínimos de request sem implementar autenticação, resolução de empresa ou acesso ao banco.

### Requisitos relacionados

- `TEN-003`, `TEN-008`, `TEN-009`
- `AUD-006`, `AUD-007`
- `NFR-REL-002`, `NFR-REL-005`, `NFR-REL-006`
- `NFR-MNT-001`, `NFR-MNT-003`
- `SEC-017`
- `TEST-003`, `TEST-EVID-001`

### Dependências

- M0 `VERIFIED`.
- M1-T01 `DONE`.

### Dentro do escopo

- `Current < ActiveSupport::CurrentAttributes` com `user`, `company`, `membership`, `request_id`, `ip_address` e `user_agent`;
- concern de controller com ciclo de vida explícito para preencher somente metadados HTTP e limpar o contexto em `ensure`;
- integração do concern ao `ApplicationController`;
- specs unitárias de atribuição, reset, `Current.set`, exceção e isolamento concorrente com sincronização;
- request specs de preenchimento durante a action e limpeza após resposta/exceção, sem endpoint de diagnóstico em produção;
- documentação do contrato atual e das integrações futuras com autenticação, tenant e jobs.

### Fora do escopo

- `User`, `Company`, `CompanyMembership`, `CompanyInvitation`, migrations, factories ou consultas ao banco;
- autenticação, session de usuário, resolução por slug/host/header e rotas tenant/platform;
- policies, Pundit, services de domínio, jobs de negócio ou auditoria persistida;
- middleware customizado de tenancy, logging estruturado ou configuração de proxies de produção;
- armazenamento de request, headers completos, parâmetros, session, cookies, senha, token ou anexos;
- gems novas e M1-T03 ou tarefas posteriores.

### Critérios de aceite

- [x] Tarefa detalhada e checkpoint registrado antes do código.
- [x] `Current` herda de `ActiveSupport::CurrentAttributes`.
- [x] Atributos `user`, `company`, `membership`, `request_id`, `ip_address` e `user_agent` existem.
- [x] Todos os atributos começam nulos e são removidos por reset.
- [x] `Current.set` restaura o estado após sucesso e exceção.
- [x] Contexto é isolado entre threads por sincronização determinística.
- [x] Controller preenche somente request ID, IP via API Rails e user agent.
- [x] `user`, `company` e `membership` permanecem nulos nas requests atuais.
- [x] Contexto é limpo após request normal e após exceção.
- [x] Segunda request não herda valores da primeira.
- [x] Nenhum endpoint de diagnóstico existe em produção.
- [x] Nenhum request completo, params, session, cookies ou headers completos são armazenados.
- [x] Nenhuma consulta ao banco, autenticação ou resolução de tenant foi implementada.
- [x] Logging existente de request ID foi verificado sem adicionar dados pessoais.
- [x] Contratos futuros de autenticação, tenant e jobs e limites de proxy estão documentados.
- [x] Specs unitárias, request e concorrência passam.
- [x] RSpec completo, RuboCop, Brakeman, Bundler Audit, Zeitwerk, assets e `bin/ci` passam.
- [x] Runner confirma a herança de `Current`.
- [x] Nenhuma gem, migration ou model de domínio foi adicionado.
- [x] Verificador normativo e `git diff --check` passam.

### Plano técnico

1. Registrar tarefa e checkpoint antes do código.
2. Criar `Current` com somente os seis atributos aprovados e specs unitárias/concurrentes.
3. Criar concern `RequestContext` com `around_action`, atribuição por `Current.set` e cleanup garantido; integrar ao controller.
4. Testar requests por controller anônimo e rotas exclusivas do ambiente de teste, sem endpoint produtivo.
5. Documentar ciclo de vida, privacidade, proxy, autenticação/tenant/jobs futuros e limites.
6. Executar verificações completas, inspecionar escopo e registrar evidência.

### Riscos e casos de borda

- confiar apenas no executor implícito e não provar limpeza após exceção;
- `Current.set` restaurar valores anteriores legítimos em vez de zerar um contexto contaminado antes do request;
- teste concorrente instável baseado em `sleep`;
- usar `request.ip`/headers manualmente sem considerar a API de proxies confiáveis do Rails;
- expor metadados em endpoint ou logs para facilitar teste;
- armazenar objetos de domínio futuros em jobs ou herdar contexto da request enfileiradora;
- autoload do concern ou controller anônimo interferir nas rotas reais.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
docker compose -f .devcontainer/compose.yaml exec app bundle exec rubocop
docker compose -f .devcontainer/compose.yaml exec app bundle exec brakeman --no-pager
docker compose -f .devcontainer/compose.yaml exec app bundle exec bundler-audit check --update
docker compose -f .devcontainer/compose.yaml exec app bin/rails zeitwerk:check
docker compose -f .devcontainer/compose.yaml exec app bin/rails runner 'abort unless Current < ActiveSupport::CurrentAttributes'
docker compose -f .devcontainer/compose.yaml exec app bin/ci
git diff -- Gemfile Gemfile.lock
git status --short db/migrate
bash scripts/check_spec_requirements.sh
git diff --check
git status --short
```

### Evidência de conclusão

Concluída em 2026-07-12:

- arquivos alterados: `app/models/current.rb`, `app/controllers/concerns/request_context.rb`, `ApplicationController`, rotas condicionais de teste, specs model/request/support, `docs/request-context.md`, README e planejamento;
- testes adicionados: 6 specs unitárias de `Current` e 3 request specs de ciclo HTTP, incluindo duas threads com `Queue`, requests sequenciais e exceção;
- RSpec: 32 exemplos, 0 falhas;
- RuboCop: 39 arquivos, 0 offenses;
- Brakeman 8.0.5: 0 erros e 0 security warnings;
- Bundler Audit: advisory DB com 1.200 advisories, 0 vulnerabilidades;
- Zeitwerk, Tailwind 4.3.2 e assets: aprovados;
- runners: herança de `Current` e `:request_id` em `config.log_tags` de produção aprovados;
- `bin/ci`: sucesso integral;
- rota auxiliar: ausente em `RAILS_ENV=production`, confirmada por `bin/rails routes`;
- escopo: diffs de Gemfile/lock vazios, nenhuma migration ou model de domínio, banco não consultado;
- verificador normativo: 15 specs, 496 requisitos e zero falhas estruturais;
- `git diff --check`: aprovado;
- observação: Rails 8 retorna `{}` em `Current.attributes` antes da primeira atribuição; leitores declarados foram testados diretamente como `nil`.

### Próximo passo

Em nova sessão, detalhar M1-T03 pelo template antes de qualquer implementação; M1-T03 permaneceu não iniciada nesta sessão.

---

## M1-T03 — Convenções de services, queries e policies

Status: `DONE`

### Objetivo

Definir convenções arquiteturais mínimas e verificáveis para operações de estado, consultas complexas, autorização futura, transações, erros esperados, multi-tenancy, dependências e testes, sem criar um framework interno ou objetos de domínio fictícios.

### Requisitos relacionados

- `ARCH-008`
- `ARCH-DESIGN-001` a `ARCH-DESIGN-012`
- `ARCH-040` a `ARCH-043`
- `ARCH-DATA-007`, `ARCH-DATA-009` a `ARCH-DATA-014`
- `TEN-003`, `TEN-006` a `TEN-010`, `TEN-014` a `TEN-018`
- `AUTHZ-000` a `AUTHZ-005`
- `AUD-006` a `AUD-009`
- `NFR-PERF-002` a `NFR-PERF-005`
- `NFR-REL-001`, `NFR-REL-002`
- `NFR-MNT-001`, `NFR-MNT-003`, `NFR-MNT-004`
- `TEST-001` a `TEST-007`, `TEST-EVID-001`, `TEST-EVID-002`, `TEST-TEN-001` a `TEST-TEN-010`, `TEST-AUD-001`, `TEST-AUD-002`

### Dependências

- M0 `VERIFIED`.
- M1-T01 e M1-T02 `DONE`.

### Dentro do escopo

- diretórios canônicos vazios de services, queries e policies e estruturas correspondentes de specs, preservados por `.keep`;
- documentação de responsabilidades, nomes, contratos, transações, erros esperados, tenant, auditoria, jobs, Current, dependências e testes;
- convenção futura de Pundit/policies, sem instalar ou implementar autorização;
- regras permanentes mínimas em `AGENTS.md` quando não cobertas pelas regras atuais;
- verificação de autoload/Zeítwerk e ausência de abstrações especulativas.

### Fora do escopo

- Pundit, `ApplicationPolicy`, policies concretas ou autorização provisória;
- services, queries, commands ou erros concretos de domínio;
- classes base, Result objects, monads, DSLs, macros, registries, service locators ou containers de dependência;
- models, migrations, autenticação, tenant resolution, domínio financeiro, relatórios, jobs, paginação ou filtros reais;
- alterações em `Current`, autoload/eager load, máquinas de estado, regras financeiras, matriz normativa ou gems;
- M1-T04 e tarefas posteriores.

### Critérios de aceite

- [x] Tarefa detalhada e checkpoint registrado antes de estrutura/documentação.
- [x] Diretórios `app/services`, `app/queries`, `app/policies` e equivalentes em `spec/` existem somente com `.keep`.
- [x] Estrutura não exige configuração manual de autoload.
- [x] Contratos de services, queries e policies futuras estão documentados.
- [x] Responsabilidades de controller, model, policy, service e constraint estão separadas.
- [x] Services tenant-scoped exigem contexto/recurso explícito e não usam `Current` como service locator.
- [x] Queries recebem relation autorizada e tenant-scoped e preservam execução no banco.
- [x] Transações e auditoria crítica possuem unidade atômica explícita.
- [x] Convenção mínima de erros específicos está documentada sem criar classe base vazia.
- [x] Nomenclatura, organização de arquivos e testes por camada estão documentados.
- [x] Anti-patterns e abstrações deliberadamente adiadas estão explícitos.
- [x] Regras permanentes essenciais estão resumidas no `AGENTS.md`.
- [x] Nenhuma classe Ruby fictícia/base, service/query/policy de domínio ou erro concreto foi criada.
- [x] Pundit e novas gems não foram adicionados.
- [x] Nenhum model/migration de domínio ou funcionalidade de M1-T04 foi criado.
- [x] Current permanece contexto de borda, não dependência implícita.
- [x] Autoload paths foram inspecionados e Zeitwerk passa.
- [x] RSpec, RuboCop, Brakeman, Bundler Audit, assets e `bin/ci` passam.
- [x] Verificador normativo e `git diff --check` passam.

### Plano técnico

1. Registrar tarefa e checkpoint antes da implementação documental.
2. Criar somente os seis diretórios canônicos com `.keep`; verificar comportamento de autoload sem alterar configuração.
3. Escrever `docs/code-organization.md` com contratos, exemplos futuros, anti-patterns e decisões adiadas.
4. Acrescentar ao `AGENTS.md` apenas as regras permanentes essenciais não cobertas.
5. Revisar o diff contra abstrações proibidas, domínio, gems e migrations.
6. Executar verificações completas e registrar evidência.

### Riscos e casos de borda

- transformar convenções em framework interno antes de casos concretos;
- exemplos documentais parecerem classes já implementadas;
- criar `.rb` vazio ou classe fictícia para forçar autoload;
- configurar paths manualmente apesar do comportamento convencional de Rails;
- confundir policy, precondição do service e constraint do banco;
- permitir query iniciar por `.all` e perder o limite do tenant;
- usar `Current` para ocultar dependências relevantes;
- duplicar em `AGENTS.md` toda a documentação detalhada.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bin/rails runner 'puts Rails.autoloaders.main.dirs'
docker compose -f .devcontainer/compose.yaml exec app bin/rails zeitwerk:check
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
docker compose -f .devcontainer/compose.yaml exec app bundle exec rubocop
docker compose -f .devcontainer/compose.yaml exec app bundle exec brakeman --no-pager
docker compose -f .devcontainer/compose.yaml exec app bundle exec bundler-audit check --update
docker compose -f .devcontainer/compose.yaml exec app bin/ci
git diff -- Gemfile Gemfile.lock
git status --short db/migrate
rg --glob '*.rb' 'ApplicationService|ApplicationQuery|BaseService|BaseQuery|Result|Callable|ServiceRegistry|DependencyContainer|ApplicationPolicy' app spec || true
bash scripts/check_spec_requirements.sh
git diff --check
git status --short
```

### Evidência de conclusão

Concluída em 2026-07-12:

- arquivos alterados: `docs/code-organization.md`, `AGENTS.md`, README e arquivos de planejamento;
- diretórios criados: `app/services`, `app/queries`, `app/policies`, `spec/services`, `spec/queries` e `spec/policies`, todos somente com `.keep`;
- autoload: runner listou automaticamente os três diretórios de `app/`, sem alteração em `config/application.rb`;
- RSpec: 32 exemplos, 0 falhas; nenhuma spec fictícia adicionada;
- RuboCop: 39 arquivos, 0 offenses;
- Brakeman 8.0.5: 0 erros e 0 security warnings;
- Bundler Audit: advisory DB com 1.200 advisories, 0 vulnerabilidades;
- Zeitwerk, Tailwind 4.3.2 e assets: aprovados;
- `bin/ci`: sucesso integral;
- dependências/migrations: Gemfile/lock sem diff e `db/migrate` sem arquivos;
- busca em Ruby: nenhuma ocorrência das abstrações proibidas, `ApplicationPolicy` ou classe fictícia;
- Pundit, models, domínio, paginação, filtros e M1-T04 não foram iniciados;
- verificador normativo: 15 specs, 496 requisitos e zero falhas estruturais;
- `git diff --check`: aprovado.

### Próximo passo

Em nova sessão, detalhar M1-T04 pelo template antes de qualquer implementação; M1-T04 permaneceu não iniciada nesta sessão.

---

## M1-T04 — Infraestrutura de paginação e filtros

Status: `DONE`

### Objetivo

Entregar infraestrutura server-side mínima, reutilizável, acessível e segura para paginação por offset e formulários de filtro por `GET`, sem criar models, migrations, query objects ou filtros de domínio.

### Requisitos relacionados

- `ARCH-003`, `ARCH-004`, `ARCH-008`, `ARCH-DESIGN-003`, `ARCH-DESIGN-005`, `ARCH-DESIGN-006`
- `TEN-002`, `TEN-003`, `TEN-006` a `TEN-010`
- `CASH-040` a `CASH-042`
- `EXP-050` a `EXP-052`
- `REP-025`, `REP-042`, `REP-043`
- `NFR-UI-001`, `NFR-UI-006` a `NFR-UI-008`
- `NFR-PERF-001` a `NFR-PERF-004`
- `NFR-MNT-001` a `NFR-MNT-003`
- `SEC-006` a `SEC-008`, `SEC-017`, `SEC-018`
- `TEST-000`, `TEST-003`, `TEST-006`, `TEST-EVID-001`

### Dependências

- M0 `VERIFIED`.
- M1-T01, M1-T02 e M1-T03 `DONE`.

### Dentro do escopo

- Pagy `~> 43.6`, usando somente a API da versão resolvida e documentação empacotada na gem;
- integração explícita de `Pagy::Method` no `ApplicationController`, sem callback ou acesso a domínio;
- paginação offset com página top-level `page`, limite padrão de 25 e máximo de 100, aceitando `limit` somente se a API oficial limitar valores com segurança;
- política controlada para página/limite malformado, não positivo ou fora do intervalo, sem resgate genérico;
- partial server-side de paginação acessível, responsivo, sem JavaScript e com preservação explícita de parâmetros permitidos;
- helper de formulário de filtros com `form_with`, método `GET`, URL e URL de limpeza explícitas, bloco para campos específicos e convenção `filter[...]`;
- rota, controller e view auxiliares disponíveis somente em teste, usando coleção estática e sem endpoint produtivo;
- testes de integração, helper/view, request e system em Chromium headless;
- estilos Tailwind mínimos e documentação de paginação, filtros, ordenação futura, query objects e multi-tenancy.

### Fora do escopo

- qualquer model, migration, tabela, dado financeiro, tenant resolution, autenticação, Pundit, policy ou autorização concreta;
- filtros de caixas, fechamentos, despesas, relatórios, dashboard, busca textual, ordenação ou query objects concretos;
- keyset, cursor, countish, countless, infinite scroll, paginação client-side, APIs JSON ou múltiplas paginações;
- Ransack, Kaminari, will_paginate, gems de busca, framework CSS, CDN ou JavaScript específico;
- concern ou classe base que apenas envolva Pagy, DSL/classe genérica de filtros ou `SortingConcern`;
- alterações em `Current`, tarefas M1-T05 ou posteriores.

### Critérios de aceite

- [x] Tarefa detalhada antes da implementação e checkpoint pré-Gemfile registrado.
- [x] Pagy foi adicionado com restrição `~> 43.6`, versão resolvida reproduzível e API empacotada inspecionada.
- [x] Apenas `Pagy::Method` e métodos atuais do objeto Pagy são usados; APIs legadas estão ausentes.
- [x] `ApplicationController` disponibiliza paginação somente mediante chamada explícita, sem callbacks, models, `Current.company` ou alteração de parâmetros.
- [x] Inicializador mínimo define paginação offset, `page`, limite padrão 25 e limite máximo 100 ou documenta limite fixo caso `limit` seguro não seja suportado.
- [x] Página malformada/não positiva retorna primeira página; página acima da última é controlada; limite inválido não causa 500 nem consulta ilimitada.
- [x] Partial reutilizável recebe `pagy:` explicitamente, omite navegação desnecessária, informa registros e possui `nav` acessível, página atual, anterior e próximo textuais.
- [x] Links preservam somente filtros aninhados e demais parâmetros explicitamente permitidos, sem `params.to_unsafe_h`, tokens ou dados sensíveis.
- [x] Helper reutilizável usa `form_with`, `GET`, `role=search`, URL/URL limpa explícitas, bloco de campos, botão Filtrar e link Limpar filtros.
- [x] Formulário usa `filter[...]`, labels visíveis, não reenvia `page` e novo filtro retorna à primeira página.
- [x] Ordenação futura por whitelist e ordem tenant → autorização → filtros → ordenação estável → paginação estão documentadas.
- [x] Nenhuma DSL/classe base genérica, model, migration, filtro real ou rota de teste em produção foi criado.
- [x] Specs cobrem integração Pagy, partial, helper/formulário, parâmetros inválidos, preservação de filtros e segurança.
- [x] System spec em Chromium cobre links, teclado/foco, 360 px, query string e retorno à primeira página.
- [x] Layout responsivo, Tailwind e assets passam.
- [x] RSpec completo, RuboCop, Brakeman, Bundler Audit, Zeitwerk e `bin/ci` passam.
- [x] Documentação, roadmap, rastreabilidade, histórico, estado atual e evidências estão atualizados.
- [x] Verificador normativo e `git diff --check` passam.

### Plano técnico

1. Registrar detalhamento, estado `IN_PROGRESS` e checkpoint antes do `Gemfile`.
2. Adicionar Pagy, resolver a versão e inspecionar README, documentação e código empacotados antes de escolher configuração/helpers.
3. Integrar `Pagy::Method` ao controller e criar inicializador mínimo com política de limites/páginas suportada oficialmente.
4. Implementar partial acessível e helper de filtro GET, com parâmetros permitidos explícitos e estilos responsivos/de impressão.
5. Criar infraestrutura exclusiva de teste com array estático e cobrir integração, views, requests e Chromium sem domínio.
6. Documentar contratos, limites e exemplos futuros; executar verificações completas e revisar diff/segurança/escopo.
7. Registrar resultados reais e manter a tarefa `IN_PROGRESS` se qualquer critério obrigatório não puder ser comprovado.

### Riscos e casos de borda

- usar documentação de Pagy anterior à versão 43 e introduzir API removida ou configuração incompatível;
- propagação indiscriminada de parâmetros preservar token, segredo ou `page` antiga;
- tratamento de erro amplo esconder falha de programação ou criar loop de redirecionamento;
- controle de `limit` permitir valor arbitrário, zero, negativo ou ilimitado;
- `series_nav` produzir HTML marcado como seguro pela gem e ser escapado ou confiado sem confirmação documental;
- teste com array divergir de relation real; documentação deve limitar seu papel à prova de infraestrutura;
- rota/controller auxiliar vazar para produção;
- paginação ocorrer antes de tenant, autorização, filtros ou ordenação estável em usos futuros;
- CSS de navegação causar overflow horizontal em 360 px ou ocultar foco/estado atual.

### Verificação obrigatória

```bash
docker compose -f .devcontainer/compose.yaml exec app bundle install
docker compose -f .devcontainer/compose.yaml exec app bundle exec ruby -e 'require "pagy"; puts Pagy::VERSION'
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
docker compose -f .devcontainer/compose.yaml exec app bundle exec rubocop
docker compose -f .devcontainer/compose.yaml exec app bundle exec brakeman --no-pager
docker compose -f .devcontainer/compose.yaml exec app bundle exec bundler-audit check --update
docker compose -f .devcontainer/compose.yaml exec app bin/rails zeitwerk:check
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test bin/rails tailwindcss:build
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
docker compose -f .devcontainer/compose.yaml exec app bin/ci
rg 'Pagy::Backend|Pagy::Frontend|pagy_nav|pagy_info|Pagy::DEFAULT' app config spec || true
rg 'kaminari|will_paginate|ransack' Gemfile Gemfile.lock app config spec || true
rg 'params\.to_unsafe_h|unscoped' app config spec || true
git status --short db/migrate
bash scripts/check_spec_requirements.sh
git diff --check
git status --short
```

Executar `bash -n` em qualquer script shell alterado e confirmar em `RAILS_ENV=production` que nenhuma rota auxiliar de teste existe.

### Evidência de conclusão

Concluída em 2026-07-12:

- protocolo/detalhamento: tarefa registrada `IN_PROGRESS` e checkpoint pré-Gemfile concluído antes do código; alterações anteriores preservadas;
- dependência: somente Pagy adicionado diretamente com `~> 43.6`; lock resolveu `43.6.0` e a dependência transitiva `yaml 0.4.0`;
- inspeção: configuração, exemplo Rails, paginator offset, request, links, helpers, i18n e exceções empacotados na gem foram lidos antes da integração;
- código: `Pagy::Method` no controller, `Pagy::OPTIONS` congelado, limite fixo 25, `page`/`limit` top-level, request construído somente de parâmetros permitidos e locale pt-BR;
- UI: partial acessível com `series_nav`, informação textual, anterior/próxima, página atual e estilos responsivos/de impressão; `filter_form_with` GET com URLs explícitas e `filter[...]`;
- política: página malformada/não positiva vira 1; acima da última retorna vazio controlado; `limit` do cliente fica desabilitado/ignorado e o teto 100 permanece documentado para eventual habilitação segura;
- testes: helper/view/request/system com coleção estática e rota/controller somente em teste; suíte completa 50 exemplos, 0 falhas; system spec específico 4/0 após precompile;
- qualidade: RuboCop 44 arquivos/0 offenses; Brakeman 8.0.5 com 0 erros/0 warnings; Bundler Audit com 1.200 advisories/0 vulnerabilidades; Zeitwerk aprovado;
- assets/CI: Tailwind 4.3.2 e assets precompile aprovados; `bin/ci` concluído com sucesso;
- produção: runner em `RAILS_ENV=production` confirmou zero rotas `__test__`; versão reconfirmada como 43.6.0;
- escopo/segurança: buscas por API legada, Kaminari/will_paginate/Ransack, `params.to_unsafe_h`, `unscoped` e interpolação SQL não retornaram ocorrências; nenhuma migration/model/filtro de domínio;
- documentação: `docs/pagination-and-filters.md`, README, roadmap, rastreabilidade, histórico e estado atual atualizados;
- host: verificador normativo com 15 specs/496 requisitos/zero falhas e `git diff --check` aprovados;
- ambiente: o shim `docker` da distro não funcionou; os mesmos comandos foram executados no Dev Container por `docker.exe compose` após o usuário iniciar Docker Desktop.

### Próximo passo

Em nova sessão, detalhar M1-T05 pelo template antes de qualquer implementação. M1 permanece `IN_PROGRESS`; não iniciar tarefa posterior sem novo protocolo.

---

## M1-T05 — Integrar a fundação ao Dev Container existente

Status: `DONE`

Disposition: `SUPERSEDED_BY_M0-T02A`

### Definição encontrada

O planejamento residual definia M1-T05 como adaptação dos comandos e serviços do Dev Container criado em M0-T02A à aplicação Rails inicializada, sem Dockerfile ou Compose concorrente. Imagem e processos de produção permaneciam em M9.

### Decisão de reconciliação

Não existe implementação nova para M1-T05. A responsabilidade de Docker de desenvolvimento foi transferida e entregue por `M0-T02A — Construir e validar o Dev Container`; a integração da aplicação ao mesmo ambiente ocorreu em `M0-T02B` e ambas foram revalidadas na revisão independente de M0.

M1-T05 é encerrada administrativamente como satisfeita pela implementação anterior, sem ser tratada como uma segunda entrega e sem criar ou alterar Dockerfile, Compose, imagem, volumes, scripts ou documentação operacional.

### Evidência referenciada

- `planning/tasks/M0-specification-and-scaffold.md`, seção M0-T02A: 18/18 critérios, build, Compose, runtime não root, PostgreSQL healthy, hostname `db`, volumes, permissões e pós-criação idempotente;
- mesmo arquivo, seção M0-T02B: scaffold integrado exclusivamente ao Dev Container, imagem reconstruída e `app`/`db` operacionais;
- mesmo arquivo, seção “Verificação independente do milestone M0”: Compose isolado, build, runtime, banco vazio, CI e cleanup revalidados antes de M0 virar `VERIFIED`;
- `planning/SESSION_LOG.md`, sessões `2026-07-11 20:23 — M0-T02A`, `2026-07-11 21:00 — M0-T02B` e `2026-07-12 07:54 — Verificação independente de M0`;
- `.devcontainer/`, `docs/development-container.md`, README, `.dockerignore` e `.env.example` como implementação/documentação canônica única.

### Critérios da reconciliação

- [x] Definição residual de M1-T05 identificada.
- [x] Sobreposição com M0-T02A e integração já executada em M0-T02B confirmadas.
- [x] Evidência da revisão independente de M0 referenciada.
- [x] Nenhuma segunda infraestrutura Docker criada.
- [x] Nenhum arquivo funcional do Dev Container alterado.
- [x] M1-T05 removida da sequência de implementação ativa.
- [x] Limite entre desenvolvimento e Docker de produção em M9 preservado.
- [x] Pendência de worker em `OPS-LOCAL-002` mantida explícita sem inventar escopo para M1-T05.

### Limitação preservada

O Compose canônico possui `app` e `db`; `OPS-LOCAL-002` também cita worker. A rastreabilidade já mantinha esse requisito como `SPECIFIED` com “worker futuro”. Como ainda não há job de negócio, esta lacuna permanece para uma tarefa futura concreta ligada ao primeiro workload assíncrono e não reabre M1-T05 nem autoriza uma segunda configuração Docker.

### Evidência desta sessão

- inventário encontrou somente `.devcontainer/Dockerfile` e `.devcontainer/compose.yaml` até profundidade 3;
- Compose `config` permaneceu válido e `ps` mostrou `app` ativo e `db` healthy;
- verificador normativo passou com 15 specs/496 requisitos/zero falhas estruturais;
- hashes protegidos confirmaram Dockerfile, Compose, devcontainer.json, post-create, Gemfile e lockfile inalterados nesta sessão;
- nenhuma migration foi criada e `git diff --check` passou;
- nenhuma tarefa de M2 foi iniciada;
- reconciliação alterou somente planejamento e histórico.

### Próximo passo

Executar uma revisão independente do milestone M1 antes de iniciar M2.

---

## Revisão documental preliminar do milestone M1

Esta revisão confirma somente o estado e as evidências registradas; não substitui a revisão técnica independente do milestone.

- `M1-T01 DONE`: layouts, fundação visual, partials, acessibilidade, impressão e responsividade possuem critérios/evidências registrados;
- `M1-T02 DONE`: `Current`, contexto HTTP, isolamento por request/thread, reset após exceção e documentação possuem critérios/evidências registrados;
- `M1-T03 DONE`: convenções de services/queries/policies futuras, dependências explícitas, diretórios e ausência de abstrações especulativas possuem critérios/evidências registrados;
- `M1-T04 DONE`: Pagy 43.6.0, offset, filtros GET, parâmetros permitidos, partial acessível, query string segura e ausência de rotas produtivas de teste possuem critérios/evidências registrados;
- `M1-T05 DONE / SUPERSEDED_BY_M0-T02A`: nenhuma nova implementação; responsabilidade satisfeita e verificada em M0.

M1 está `DONE` e `READY_FOR_REVIEW`, mas não `VERIFIED`. A próxima sessão deve reler e inspecionar criticamente todo o milestone, executar novamente as verificações aplicáveis e somente então decidir promoção. M2 permanece `NOT_STARTED`.

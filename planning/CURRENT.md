# Estado atual

Atualizado em: `2026-07-12 09:15 America/Sao_Paulo`

## Estado do repositório

- Milestone `M0`: `VERIFIED`.
- Milestone `M1`: `IN_PROGRESS`.
- Última tarefa: `M1-T01 — Layouts e design system mínimo`, `DONE`.
- `M1-T02` a `M1-T05`: `NOT_STARTED`.
- Branch: `main`; `HEAD` e `origin/main` locais em `a1cb0e7554c69ce3ee6dbe03c7bb4f17e6de4950`.
- Working tree inicial: cinco arquivos de planejamento modificados pela revisão de M0; estado final preserva essas mudanças e acrescenta os arquivos de M1-T01, todos não commitados.

## Resultado de M1-T01

- layouts: `application`, `public`, `platform`, `tenant` e `print`, compostos sobre um único documento HTML e sem autenticação/tenant;
- página institucional: `HomeController#index` em `/`, layout público, português e conteúdo estritamente correspondente ao estado atual;
- navegação: somente marca, início e indicação de desenvolvimento fora de produção;
- elementos: cabeçalho, flash semântico/sanitizado, variantes de botão, card, badge textual, estado vazio, tabela responsiva e erros Active Model;
- estilos: largura, espaçamento, superfícies, tipografia, foco, formulários, feedback, estados disabled/hover, redução de movimento e impressão;
- documentação: `docs/ui-foundation.md` e referência no README;
- testes: request da raiz/healthcheck, helpers, partials, cinco layouts e Chromium para navegação e 360/768/1280 px;
- limites confirmados: nenhuma gem, model, migration, autenticação, tenancy, autorização, domínio, rota futura ou implementação de M1-T02+.

## Verificações executadas

- baseline: 2 exemplos/0 falhas; Tailwind 4.3.2 aprovado;
- RSpec final: 23 exemplos/0 falhas;
- RuboCop final: 34 arquivos/0 offenses;
- Brakeman 8.0.5: 0 erros/0 security warnings;
- Bundler Audit: advisory DB com 1.200 advisories/0 vulnerabilidades;
- Zeitwerk: aprovado;
- Tailwind 4.3.2 e assets precompile: aprovados;
- `bin/ci`: sucesso integral após a última alteração de código;
- requisições reais: `/` e `/up` retornaram HTTP 200 dentro do container;
- specs normativas: 15 arquivos/496 requisitos/zero falhas estruturais;
- `git diff --check`: aprovado.

## Problemas encontrados e resolvidos

- quatro falhas iniciais em specs dos componentes por expectativas, chamada de helper e tradução; corrigidas sem ampliar escopo;
- teste responsivo inicialmente detectou CSS precompilado anterior em 360 px; `assets:precompile` atualizou o manifest e a validação passou em 360, 768 e 1280 px.

## Arquivos relevantes

- `app/views/layouts/` e `app/views/shared/`;
- `app/views/home/index.html.erb`, `app/controllers/home_controller.rb`, `config/routes.rb`;
- `app/helpers/application_helper.rb`, `app/assets/tailwind/application.css`, `config/locales/pt-BR.yml`;
- `spec/requests/home_spec.rb`, `spec/helpers/`, `spec/views/`, `spec/system/home_spec.rb`;
- `docs/ui-foundation.md`, README e arquivos de planejamento.

## Limitações

- os layouts `platform` e `tenant` são somente estruturas sem rotas ou contexto, conforme escopo;
- a confirmação funcional de ações destrutivas pertence às tarefas que criarem essas ações;
- a fundação não é um design system definitivo e deve crescer apenas por uso concreto;
- alterações permanecem não commitadas; nenhum commit, push ou merge foi autorizado.

## Próxima ação exata

Em nova sessão, detalhar `M1-T02 — CurrentAttributes e contexto de request` usando `planning/templates/TASK_TEMPLATE.md` antes de qualquer implementação. Não iniciar M1-T03 ou tarefa posterior.

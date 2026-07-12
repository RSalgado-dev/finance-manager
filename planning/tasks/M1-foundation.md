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
## M1-T03 — Convenções de services, queries e policies
## M1-T04 — Infraestrutura de paginação e filtros
## M1-T05 — Integrar a fundação ao Dev Container existente

Escopo de `M1-T05`: adaptar comandos e serviços do Dev Container criado em `M0-T02A` à aplicação já inicializada, sem criar Dockerfile ou Compose concorrente. Imagem e processos de produção permanecem em M9.

Cada tarefa deve ser detalhada com o template de `planning/templates/TASK_TEMPLATE.md` antes de entrar em `IN_PROGRESS`.

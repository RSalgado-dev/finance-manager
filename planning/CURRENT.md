# Estado atual

Atualizado em: `2026-07-11 21:27 America/Sao_Paulo`

## Estado do repositório

- Milestone `M0`: `IN_PROGRESS`; não promover antes da execução remota do CI.
- Última tarefa: `M0-T03A` — `DONE`.
- `M0-T03B`: `NOT_STARTED`; depende de commit/push autorizados e run real.
- Agregadora `M0-T03`: `IN_PROGRESS`.
- `M0-T01`, `M0-T02A`, `M0-T02B` e `M0-T02`: `DONE`.
- Branch: `main`.
- Último commit: `3230b5a Add custom 500 error page, application icon, and robots.txt`.
- Working tree inicial: limpa; atual: alterações de M0-T03A não commitadas.

## Resultado de M0-T03A

O CI local foi implementado com `.github/workflows/ci.yml` e `bin/ci`. GitHub Actions usa `ubuntu-24.04` apenas como host Docker; aplicação e PostgreSQL usam os serviços `app` e `db` de `.devcontainer/compose.yaml`. Nenhuma ferramenta Ruby ou banco é instalado no runner.

O workflow possui push em `main`, pull request e `workflow_dispatch`, `contents: read`, concorrência com cancelamento, timeout de 30 minutos e cleanup `always()`. A única action é `actions/checkout` v7.0.0, SHA `9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0`, confirmada como release oficial não prerelease.

`LOCAL_UID`/`LOCAL_GID` são obtidos do runner e enviados ao build. O container permanece não root e o volume de gems/workspace fica gravável. `ripgrep` foi a única dependência sistêmica acrescentada.

## Evidências executadas

- baseline: `CompanyFinance::Application` iniciou; o verificador inicialmente falhou em `app` por ausência de `rg`;
- build local após ajuste: sucesso em aproximadamente 74 s; ripgrep 13.0.0;
- `bin/ci` no ambiente existente: sucesso;
- workflow: parser YAML dentro de `app` e invariantes de triggers, permissões, runner, timeout, SHA e cleanup passaram; `actionlint` não estava disponível;
- simulação isolada `company_finance_ci_validation`: build `--no-cache` em aproximadamente 85 s, banco/volume de gems novos e banco test inicialmente ausente;
- permissão: usuário `vscode` 1000:1000 escreveu no workspace;
- `bin/ci` isolado: instalou 126 gems, criou `company_finance_test` e passou em aproximadamente 70 s;
- verificações: 496 requisitos válidos; 2 specs/0 falhas; 28 arquivos RuboCop/0 offenses; Brakeman/0 warnings; Bundler Audit/0 vulnerabilidades; Zeitwerk, Tailwind, assets e boot verdes;
- teste negativo: host PostgreSQL inválido interrompeu `db:prepare` e retornou exit code 1;
- cleanup: containers, rede e volumes isolados removidos; `finance-manager-dev` permaneceu com app ativo e db healthy;
- nenhuma funcionalidade de domínio, deploy, cache remoto, registry ou publicação de imagem foi adicionada.

## Arquivos alterados

- `.github/workflows/ci.yml`
- `bin/ci`
- `.devcontainer/Dockerfile`
- `README.md`
- `docs/development-container.md`
- `planning/tasks/M0-specification-and-scaffold.md`
- `planning/ROADMAP.md`
- `planning/TRACEABILITY.md`
- `planning/SESSION_LOG.md`
- `planning/CURRENT.md`

## Limitações reais

- GitHub Actions não foi executado: workflow não foi commitado nem enviado ao remoto.
- `actionlint` não está instalado; validação local usou parser YAML no container e checagens estruturais, sem alegar equivalência a um run remoto.
- não há cache remoto; o build limpo medido em cerca de 85 segundos pode orientar otimização futura.
- alterações não commitadas; não houve autorização para commit ou push.

## Próxima ação exata

Após autorização explícita, criar commit com M0-T03A, fazer push, disparar ou observar o workflow por push/pull request/`workflow_dispatch`, confirmar todos os steps verdes e o cleanup nos logs, e registrar a URL ou ID do run em M0-T03B. Manter M0-T03 `IN_PROGRESS` e não iniciar M1 até essa evidência remota existir.

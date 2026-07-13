# Estado atual

Atualizado em: `2026-07-12 22:25 America/Sao_Paulo`

## Estado do repositório

- Milestone `M0`: `VERIFIED`.
- Milestone `M1`: `VERIFIED` após revisão independente.
- `M1-T01`, `M1-T02`, `M1-T03` e `M1-T04`: `DONE` e revalidadas.
- `M1-T05`: `DONE / SUPERSEDED_BY_M0-T02A`, corretamente satisfeita pela infraestrutura verificada de M0.
- Milestone `M2`: `NOT_STARTED`; nenhuma tarefa posterior a M1 foi iniciada.
- Branch: `main`; commit revisado: `921f50d`.
- Working tree inicial da revisão: limpa.

## Resultado da revisão independente de M1

M1 satisfaz os critérios de promoção. Código, views, helpers, controllers, concerns, configuração, rotas, gems, documentação, testes e integração entre as entregas foram inspecionados sem depender somente das evidências anteriores.

- M1-T01: composição dos cinco layouts, elementos compartilhados, página institucional, acessibilidade estrutural, responsividade e impressão revalidadas;
- M1-T02: `Current` e ciclo HTTP revalidados quanto aos seis atributos, isolamento, privacidade, reset e exceções;
- M1-T03: diretórios somente com `.keep`, autoload convencional e ausência de abstrações especulativas confirmados;
- M1-T04: Pagy 43.6.0, offset, limite fixo 25, páginas inválidas, allowlist, formulário GET e partial acessível revalidados;
- M1-T05: sobreposição com M0 confirmada, sem segunda implementação Docker.

Nenhum model, migration, autenticação, empresa, membership, convite, resolução de tenant, Pundit, policy concreta ou rota de M2 existe.

## Problemas encontrados e correções

- Nenhum defeito funcional foi encontrado e nenhuma tarefa de M1 precisou ser reaberta.
- `planning/CURRENT.md` ainda descrevia commit-base `8657cdd` e alterações não commitadas anteriores, embora o repositório estivesse limpo em `921f50d`; o estado factual foi corrigido nesta revisão.
- Nenhuma especificação normativa, código de aplicação, teste, Gemfile/lock, migration, Dev Container ou CI foi alterado.

## Verificações executadas

- protocolo Git: branch `main`, commit `921f50d`, working tree inicial limpa; últimos cinco commits inspecionados;
- Compose inicial: `app` ativo e `db` healthy;
- baseline focado de M1: 48 exemplos, 0 falhas;
- RSpec completo: 50 exemplos, 0 falhas;
- RSpec aleatório: 50 exemplos, 0 falhas; seed `56916`;
- system specs Chromium: 7 exemplos, 0 falhas;
- responsividade: página pública em 360/768/1280 px e paginação em 360 px, sem overflow horizontal indevido;
- RuboCop: 44 arquivos, 0 offenses;
- Brakeman 8.0.5: 0 erros e 0 security warnings;
- Bundler Audit: advisory database com 1.200 advisories, 0 vulnerabilidades;
- Zeitwerk: aprovado; services, queries e policies reconhecidos sem configuração manual;
- Tailwind 4.3.2 e assets precompile: aprovados;
- HTTP real: `/` e `/up` retornaram 200; servidor temporário encerrado;
- rotas: nenhuma rota própria `__test__`, platform, tenant, autenticação ou domínio em desenvolvimento/produção;
- Pagy/API/segurança: nenhuma API legada, concorrente, `params.to_unsafe_h` ou propagação arbitrária encontrada;
- Current/privacidade: nenhum `Thread.current` direto, global, banco, request completo ou logging automático de IP/user agent;
- dependências: Pagy 43.6.0 é a única dependência funcional direta de M1; `yaml` 0.4.0 é transitiva;
- migrations: `db/migrate` sem arquivos;
- busca de M2: apenas falso positivo no comentário padrão de `has_secure_password` do Gemfile;
- `bin/ci`: sucesso integral;
- verificador normativo: 15 specs, 496 requisitos, zero falhas estruturais;
- `git diff --check`: aprovado após as atualizações finais de planejamento.

## Arquivos alterados nesta revisão

- `planning/tasks/M1-foundation.md`;
- `planning/ROADMAP.md`;
- `planning/TRACEABILITY.md`;
- `planning/SESSION_LOG.md`;
- `planning/CURRENT.md`.

## Questões e riscos ainda abertos

- Nenhuma questão ou risco aberto bloqueia M1.
- `OPS-LOCAL-002` mantém o worker futuro como `SPECIFIED`, vinculado ao primeiro workload assíncrono concreto; não reabre M1-T05.
- Questões de produto e riscos de tenancy/auditoria permanecem para seus milestones já planejados, sem implementação antecipada.

## Alterações não commitadas

- somente os cinco arquivos de planejamento listados acima, referentes à promoção e ao registro desta revisão;
- nenhum commit, push, merge, reset, limpeza destrutiva ou alteração de histórico foi executado.

## Próxima ação exata

Em nova sessão, executar o protocolo inicial e detalhar `M2-T01 — Company e constraints` antes de qualquer implementação de M2.

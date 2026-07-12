# Finance Manager

Aplicação web multi-tenant para gestão financeira operacional de empresas. O projeto é dirigido pelas especificações versionadas em `specs/`; o scaffold Rails está configurado, mas nenhuma funcionalidade de negócio foi implementada.

## Stack

| Componente | Versão ou estratégia |
|---|---|
| Ruby | 3.4.10 |
| Rails | 8.1.3 (`CompanyFinance`) |
| Bundler | 2.7.2 |
| PostgreSQL | 17.10 (`postgres:17.10-bookworm`) |
| Front-end | views Rails, Hotwire, importmap e Tailwind CSS |
| Jobs | Solid Queue sobre PostgreSQL, sem Redis |
| Testes | RSpec, FactoryBot, Capybara e Selenium/Chromium |
| Qualidade | RuboCop Rails Omakase, Brakeman e Bundler Audit |

O Dev Container é o ambiente canônico. Não instale Ruby, Bundler, Rails ou PostgreSQL no host. O host precisa somente de Git, Docker e Docker Compose; VS Code com a extensão Dev Containers é opcional.

## Preparar o ambiente

Copie as variáveis fictícias de desenvolvimento. Ajuste `LOCAL_UID` e `LOCAL_GID` se o usuário do host não utilizar `1000:1000`.

```bash
cp .env.example .env
docker compose -f .devcontainer/compose.yaml build
docker compose -f .devcontainer/compose.yaml up -d
docker compose -f .devcontainer/compose.yaml ps
```

No VS Code, abra a raiz e execute “Dev Containers: Reopen in Container”. O editor utiliza o serviço `app`, inicia `db` e executa o pós-criação idempotente. Ele instala gems quando há `Gemfile`, mas nunca gera a aplicação.

Pare os serviços preservando os volumes:

```bash
docker compose -f .devcontainer/compose.yaml down
```

Reconstrua depois de alterar a imagem:

```bash
docker compose -f .devcontainer/compose.yaml build --no-cache app
docker compose -f .devcontainer/compose.yaml up -d
```

Para apagar deliberadamente somente os volumes de desenvolvimento deste Compose, incluindo banco e cache de gems:

```bash
docker compose -f .devcontainer/compose.yaml down --volumes
```

## Executar a aplicação

Todos os comandos Ruby devem ser executados em `app`:

```bash
docker compose -f .devcontainer/compose.yaml exec app bundle install
docker compose -f .devcontainer/compose.yaml exec app bin/rails db:create
docker compose -f .devcontainer/compose.yaml exec app bin/rails db:prepare
docker compose -f .devcontainer/compose.yaml exec app env RAILS_ENV=test bin/rails db:prepare
docker compose -f .devcontainer/compose.yaml exec app bin/rails server -b 0.0.0.0
```

Para iniciar Rails e o watcher do Tailwind em conjunto:

```bash
docker compose -f .devcontainer/compose.yaml exec app bin/dev
```

O Compose não publica portas no host por padrão. Dentro do VS Code Dev Container, o encaminhamento da porta 3000 é configurado por `.devcontainer/devcontainer.json`. Para uma verificação sem publicação, acesse `/up` de dentro de `app`.

`bin/setup --skip-server` instala gems ausentes, prepara o banco e limpa temporários de modo idempotente. Ele não reseta dados.

## Verificações

```bash
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
docker compose -f .devcontainer/compose.yaml exec app bundle exec rubocop
docker compose -f .devcontainer/compose.yaml exec app bundle exec brakeman
docker compose -f .devcontainer/compose.yaml exec app bundle exec bundler-audit check --update
docker compose -f .devcontainer/compose.yaml exec app bin/rails zeitwerk:check
docker compose -f .devcontainer/compose.yaml exec app bin/rails tailwindcss:build
docker compose -f .devcontainer/compose.yaml exec app bin/rails assets:precompile
```

RSpec usa o banco `company_finance_test`. O smoke test de sistema executa Chromium headless já instalado na imagem.

## Banco e arquivos

Desenvolvimento e teste usam bancos separados e acessam PostgreSQL pelo hostname interno `db`. Credenciais de `.env.example` são apenas valores fictícios locais. Produção será configurada por `DATABASE_URL` e URLs específicas dos adaptadores Solid.

Active Storage está carregado, mas suas tabelas ainda não foram instaladas: comprovantes pertencem ao milestone de despesas. Solid Queue e seus schemas de infraestrutura estão disponíveis, sem jobs de negócio ou worker de produção.

Consulte [docs/development-container.md](docs/development-container.md) para arquitetura, conexão PostgreSQL, permissões e diagnóstico.

## Especificações e planejamento

- `AGENTS.md`: protocolo permanente de trabalho;
- `specs/`: baseline normativa do produto e da arquitetura;
- `planning/CURRENT.md`: estado operacional e próxima ação;
- `planning/tasks/`: tarefas executáveis e evidências.

O scaffold não inclui empresas, usuários, autenticação, tenancy, caixas, despesas, relatórios ou qualquer outra funcionalidade de domínio.

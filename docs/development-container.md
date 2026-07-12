# Ambiente de desenvolvimento containerizado

## Arquitetura

O Compose define dois serviços:

- `app`: Ruby/Rails CLI e ferramentas de desenvolvimento, executado como usuário `vscode` não root, com o repositório montado em `/workspace/finance-manager` e cache de gems persistente;
- `db`: PostgreSQL de desenvolvimento, acessível apenas na rede interna pelo hostname `db`, com healthcheck e volume próprio.

Não há Ruby no host, Redis, Sidekiq, Node.js, socket Docker ou modo privilegiado. A aplicação `CompanyFinance` usa Solid Queue com PostgreSQL, sem jobs de negócio nesta fase.

Chromium e ChromeDriver atendem aos system specs headless; libvips atende ao processamento futuro de imagens do Active Storage. RSpec, FactoryBot, Capybara, Selenium, RuboCop, Brakeman e Bundler Audit são executados somente em `app`.

## Comandos canônicos

Validar configuração e construir:

```bash
docker compose -f .devcontainer/compose.yaml config
docker compose -f .devcontainer/compose.yaml build
```

Iniciar somente o banco ou todo o ambiente:

```bash
docker compose -f .devcontainer/compose.yaml up -d db
docker compose -f .devcontainer/compose.yaml up -d
```

Inspecionar estado e logs:

```bash
docker compose -f .devcontainer/compose.yaml ps
docker compose -f .devcontainer/compose.yaml logs db
docker compose -f .devcontainer/compose.yaml logs app
```

Executar shell ou comando:

```bash
docker compose -f .devcontainer/compose.yaml exec app bash
docker compose -f .devcontainer/compose.yaml exec app ruby --version
docker compose -f .devcontainer/compose.yaml exec app bin/rails db:prepare
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec
```

Parar preservando dados, reconstruir ou remover volumes estão documentados no README.

## PostgreSQL

As credenciais de `.env.example` são exclusivamente locais. O serviço não publica a porta 5432 no host. A aplicação futura usará:

```text
host=db
port=5432
user=app
database=company_finance_development
```

Teste a conexão a partir de `app`:

```bash
docker compose -f .devcontainer/compose.yaml exec app sh -lc \
  'PGPASSWORD="$DATABASE_PASSWORD" psql -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USERNAME" -d "$DATABASE_NAME" -c "SELECT 1"'
```

Se falhar:

1. execute `docker compose -f .devcontainer/compose.yaml ps` e confirme `db` como healthy;
2. inspecione `docker compose -f .devcontainer/compose.yaml logs db`;
3. confira se `.env` usa hostname `db`, não `localhost`;
4. confirme que usuário, senha e banco são iguais nos dois serviços;
5. recrie volumes somente se os dados locais puderem ser descartados.

## Permissões

O usuário `vscode` é construído com `LOCAL_UID` e `LOCAL_GID`, ambos `1000` por padrão. Em hosts com valores diferentes, ajuste `.env` antes do build e reconstrua `app`. O código permanece no bind mount do host; gems e banco usam volumes separados.

O socket Docker não é montado e nenhum serviço usa `privileged`.

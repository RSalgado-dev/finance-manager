# M0 — Especificação e scaffold

## M0-T01 — Validar estrutura de especificações

Status: `IN_PROGRESS`

### Objetivo

Revisar os documentos iniciais, identificar decisões ainda ambíguas e garantir que o Codex consiga localizar requisitos e progresso entre sessões.

### Dependências

Nenhuma.

### Critérios de aceite

- [ ] `AGENTS.md` é conciso e operacional.
- [ ] Todas as áreas do prompt original estão representadas em `specs/`.
- [ ] Requisitos possuem identificadores estáveis.
- [ ] Protocolo de sessão está documentado.
- [ ] Roadmap e tarefas iniciais existem.
- [ ] Decisões de tenancy estão registradas.
- [ ] Não há contradições materiais conhecidas.

### Evidência

Ainda não verificada.

### Próximo passo

Revisar com o responsável pelo produto e registrar ajustes.

---

## M0-T02 — Inicializar aplicação Rails

Status: `NOT_STARTED`

### Objetivo

Criar a aplicação Rails no repositório com PostgreSQL e escolhas técnicas aprovadas.

### Dependências

M0-T01.

### Critérios de aceite

- [ ] Aplicação inicia.
- [ ] Banco PostgreSQL conecta.
- [ ] Test framework funciona.
- [ ] UUID padrão definido.
- [ ] Locale e timezone base configurados.
- [ ] README contém setup inicial.
- [ ] `.env.example` existe.
- [ ] Baseline de testes, lint e segurança registrado.

### Requisitos

`ARCH-001` a `ARCH-027`, `OPS-CI-001`.

---

## M0-T03 — Configurar CI inicial

Status: `NOT_STARTED`

### Dependências

M0-T02.

### Critérios de aceite

- [ ] GitHub Actions executa testes.
- [ ] RuboCop executa.
- [ ] Brakeman executa.
- [ ] Bundler Audit executa.
- [ ] Pipeline falha corretamente.

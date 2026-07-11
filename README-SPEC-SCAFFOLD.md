# Como usar este scaffold

1. Copie todo o conteúdo para a raiz do repositório.
2. Inicie uma nova sessão do Codex na raiz.
3. Use o texto de `prompts/START_OR_CONTINUE_SESSION.md`.
4. Na primeira sessão, conclua `M0-T01`; não peça a criação completa do sistema de uma vez.
5. Ao fim de cada sessão, confira se `planning/CURRENT.md` e `planning/SESSION_LOG.md` foram atualizados.

## Princípio central

- `AGENTS.md`: como o agente trabalha.
- `specs/`: o que o sistema deve fazer.
- `planning/tasks/`: unidades executáveis.
- `planning/CURRENT.md`: ponto exato de retomada.
- `planning/SESSION_LOG.md`: histórico imutável de sessões.
- `planning/TRACEABILITY.md`: prova de que requisito virou código e teste.
- `planning/decisions/`: decisões arquiteturais aceitas.

Não use o antigo prompt gigante como prompt de cada sessão. Ele passa a ser representado pelos arquivos versionados.

## Sessões interrompidas

O handoff não deve depender apenas da última mensagem. O agente deve atualizar `planning/CURRENT.md` após cada incremento verificável. Assim, uma nova sessão consegue reconstruir o estado mesmo que a anterior seja encerrada sem o ritual final completo.

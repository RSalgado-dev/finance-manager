# Regras locais para `specs/`

- Estes arquivos definem o comportamento esperado do produto.
- Não reduza requisitos para acomodar limitações da implementação.
- Não altere semântica sem solicitação explícita ou proposta registrada.
- Todo requisito normativo deve possuir um identificador estável.
- Use `MUST`, `SHOULD` e `MAY` de forma consistente:
  - `MUST`: obrigatório para aceite;
  - `SHOULD`: esperado, salvo justificativa;
  - `MAY`: opcional.
- Quando uma mudança for aceita, atualize também:
  - ADR aplicável;
  - tarefas afetadas;
  - `planning/TRACEABILITY.md`;
  - riscos relacionados.

Faça uma revisão de consistência da especificação sem implementar código.

Procure:

- requisitos contraditórios;
- regras sem ator autorizado;
- estados sem transição definida;
- campos sem uso;
- fórmulas ambíguas;
- ausência de constraints;
- risco de vazamento entre tenants;
- critérios não testáveis;
- dependências incorretas no roadmap.

Não modifique semântica silenciosamente. Registre dúvidas em `planning/OPEN_QUESTIONS.md` e mudanças propostas em `planning/PROPOSALS.md`. Corrija apenas inconsistências inequívocas. Atualize o handoff ao terminar.

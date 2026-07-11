# ADR-0001 — Banco e schema compartilhados para multi-tenancy

Status: `ACCEPTED`

## Contexto

A aplicação atenderá múltiplas empresas. É necessário escolher entre banco separado, schema separado ou tabelas compartilhadas com `company_id`.

## Decisão

Usar um único PostgreSQL, um único schema e tabelas compartilhadas. Toda entidade de tenant possuirá `company_id`.

## Motivos

- menor complexidade de migrations e operação;
- deploy e backup mais simples;
- adequado ao estágio inicial e ao perfil de pequenas e médias empresas;
- permite consultas globais controladas pelo painel técnico;
- isolamento pode ser reforçado por policies, scoping e testes.

## Consequências

- uma consulta sem escopo pode causar vazamento crítico;
- índices devem começar por `company_id` quando apropriado;
- testes com duas empresas são obrigatórios;
- exports, jobs e relatórios exigem atenção equivalente a controllers;
- RLS pode ser adicionada no futuro como defesa adicional.

## Alternativas rejeitadas

- banco por empresa: custo operacional desproporcional;
- schema por empresa: migrations e manutenção mais complexas;
- RLS imediata: defesa útil, mas aumenta complexidade inicial e não substitui autorização da aplicação.

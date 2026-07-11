# Brief de origem reconstruído

Status: `HISTORICAL_NON_NORMATIVE`

## Proveniência

O texto integral do prompt original não está disponível neste repositório. Este documento é uma síntese reconstruída a partir do scaffold documental inicial, do commit-base `3b8c3c750bb7a2c7d38c85c5fc4cd0fb1844a205` e das decisões aprovadas em 2026-07-11.

Este brief é histórico e não normativo. Em caso de divergência, prevalecem os ADRs aceitos e as especificações normativas atuais. Para evitar bloqueio indefinido por uma fonte ausente, o responsável do produto aceitou as especificações corrigidas em `specs/` como baseline normativa inicial.

## Intenção reconstruída

A intenção inicial foi criar uma aplicação web multi-tenant para gestão financeira operacional de pequenas e médias empresas brasileiras. O núcleo do produto abrange identidade sem cadastro público, empresas e papéis, caixas e fechamentos, movimentações, despesas e comprovantes privados, dashboards, relatórios, CSV, administração global e auditoria.

O produto deve privilegiar isolamento forte entre empresas, valores monetários inteiros em centavos, períodos no timezone da empresa, interface brasileira responsiva, trilha auditável de operações críticas e deploy por containers. A implementação pretendida é um monólito Rails server-rendered com PostgreSQL, Hotwire, Tailwind, Active Storage e Solid Queue.

Os fluxos centrais esperados são:

- platform admin cria empresa e primeiro administrador;
- operator registra e envia fechamento, e manager/company admin aprova;
- despesas percorrem rascunho, pendência, pagamento ou cancelamento;
- receitas consideram apenas fechamentos aprovados;
- relatórios permitem caixa e competência com cálculos compartilhados;
- todas as consultas, anexos, jobs e exports respeitam o tenant;
- operação inclui CI, segurança, storage privado, backup, recuperação e observabilidade.

Emissão fiscal, integração bancária, conciliação automática, estoque, folha, cobrança, checkout, contabilidade fiscal, aplicativo nativo e microserviços não pertencem à primeira versão.

## Limite histórico

Esta reconstrução não afirma reproduzir literalmente o prompt ausente. A cobertura verificável é mantida em `planning/SOURCE_COVERAGE.md`, baseada na baseline normativa aprovada.

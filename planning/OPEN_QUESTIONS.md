# Questões abertas

Uma questão aberta não bloqueia automaticamente. Quando houver default seguro definido, o Codex pode prosseguir e registrar a decisão.

## Q-001 — Aprovação de despesas

A especificação atual possui status `draft`, `pending`, `paid`, `canceled`, mas também menciona `approved_by_id`.

Decidir entre:

1. aprovação explícita antes do pagamento;
2. aprovação implícita ao marcar como paga;
3. manter aprovação opcional configurável.

Default recomendado para a primeira versão: aprovação implícita ao marcar como paga por manager/company admin. Operator cria `draft` ou `pending`, mas não marca como paga sem permissão.

Estado: `OPEN`.

## Q-002 — Multiplicidade de turnos

`shift_name` é texto opcional. Avaliar se deve permanecer livre ou se a empresa deve configurar turnos.

Default inicial: texto normalizado, sem cadastro separado de turnos.

Estado: `OPEN`.

## Q-003 — Política de retenção

Não há prazo definido para retenção de audit logs e anexos.

Default inicial: sem exclusão automática na primeira versão; documentar impacto operacional.

Estado: `OPEN`.

## Q-004 — Limites de upload

Definir MIME types e tamanho máximo.

Default inicial sugerido: PDF, JPEG e PNG; máximo de 10 MB por comprovante.

Estado: `OPEN`.

## Q-005 — Exportações grandes

O limiar para processamento assíncrono ainda não está definido.

Default inicial: export síncrono na primeira versão, com interface de serviço preparada; medir antes de adicionar complexidade.

Estado: `OPEN`.

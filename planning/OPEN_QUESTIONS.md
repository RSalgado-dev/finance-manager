# Questões abertas

Uma questão aberta não bloqueia automaticamente. Quando houver default seguro definido, o Codex pode prosseguir e registrar a decisão.

## Q-001 — Aprovação de despesas

A especificação atual possui status `draft`, `pending`, `paid`, `canceled`, mas também menciona `approved_by_id`.

Também não define as transições válidas, quem pode executá-las, se aprovação e pagamento são uma única operação, nem quais campos de uma despesa paga podem ser corrigidos.

Decidir entre:

1. aprovação explícita antes do pagamento;
2. aprovação implícita ao marcar como paga;
3. manter aprovação opcional configurável.

Default recomendado para a primeira versão: aprovação implícita ao marcar como paga por manager/company admin. Operator cria `draft` ou `pending`, mas não marca como paga sem permissão.

Decisão: aprovação implícita na transição `pending -> paid`, permitida a manager ou company admin; `approved_by_id`/`approved_at` foram substituídos por `paid_by_id`/`paid_at`. Transições e campos editáveis estão em `expenses.md` e na matriz de autorização.

Arquivos afetados: `specs/10-architecture/data-model.md`, `specs/10-architecture/authorization-matrix.md`, `specs/20-domains/expenses.md`.

Estado: `RESOLVED`.

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

Decisão: exportação assíncrona é opcional e só será implementada quando medição ou limite operacional demonstrar necessidade; CSV e impressão síncronos pertencem a M6.

Arquivos afetados: `specs/20-domains/dashboard-and-reporting.md`, `planning/ROADMAP.md`, tarefas M6/M7.

Estado: `RESOLVED`.

## Q-006 — Início da semana nos relatórios

`USR-005` define `week_starts_on` como configuração da empresa e `ARCH-026` define segunda-feira apenas como padrão, enquanto `REP-011` obriga toda semana a iniciar na segunda-feira.

Decidir se relatórios semanais devem usar a configuração da empresa ou sempre segunda-feira.

Default recomendado: usar `Company#week_starts_on`, com segunda-feira como valor padrão.

Decisão: a semana é fixa de segunda-feira a domingo; `week_starts_on` foi removido do modelo e das configurações.

Arquivos afetados: `system-architecture.md`, `data-model.md`, `companies-and-users.md`, `dashboard-and-reporting.md`.

Estado: `RESOLVED`.

## Q-007 — Máquina de estados de fechamento

Os status de `CashClosing` são `draft`, `submitted`, `approved` e `canceled`, mas a especificação não define:

- para qual status um fechamento aprovado retorna ao ser reaberto;
- quais status podem ser cancelados ou reabertos;
- se manager ou company admin pode aprovar o próprio fechamento;
- em qual transição a justificativa de divergência passa a ser obrigatória;
- se os campos `reopened_*` guardam somente o último evento ou histórico.

Default recomendado: `approved -> submitted` na reabertura; somente `draft`, `submitted` e `approved` podem ser cancelados; fechamento cancelado é terminal; nenhum usuário aprova fechamento criado ou enviado por si; a justificativa de divergência é validada no envio e na aprovação; histórico completo fica em `AuditLog`.

Decisão: adotada a máquina `draft -> submitted/canceled`, `submitted -> approved/canceled`, `approved -> draft` apenas por reabertura; `canceled` é terminal. Reabertura volta a `draft`, exige manager/company admin, justificativa, responsável, data, transação e auditoria crítica. Os campos `reopened_*` representam o evento mais recente e AuditLog preserva o histórico.

Arquivos afetados: `cash-management.md`, `authorization-matrix.md`, `ADR-0004`.

Estado: `RESOLVED`.

## Q-008 — Despesas incluídas no regime de competência

`REP-021` exclui apenas despesas canceladas e `REP-024` usa `competence_date`, mas não informa se rascunhos e pendentes entram no resultado por competência. A expressão `included_expenses` da fórmula de resultado líquido não está definida.

Default recomendado: regime de caixa inclui somente despesas `paid`; regime de competência inclui `pending` e `paid`, excluindo `draft` e `canceled`.

Decisão: caixa inclui somente `paid` por `paid_at`; competência inclui `pending` e `paid` por `competence_date`; `draft` e `canceled` são excluídas.

Arquivos afetados: `expenses.md`, `dashboard-and-reporting.md`.

Estado: `RESOLVED`.

## Q-009 — Matriz de autorização operacional

As descrições dos papéis não formam uma matriz verificável para criar, visualizar, editar, enviar, pagar, aprovar, reabrir e cancelar cada recurso. Permanecem ambíguos o alcance de “registros permitidos” para viewer, “conforme regras” para operator e “administra” para manager.

Default recomendado: detalhar uma matriz por ação antes de `M3-T01`, incluindo propriedade do registro e proibição de autoaprovação.

Decisão: criada matriz normativa por recurso, ação, origem, ator, restrição e auditoria; toda permissão não listada é negada.

Arquivo afetado: `specs/10-architecture/authorization-matrix.md`.

Estado: `RESOLVED`.

## Q-010 — Integridade referencial entre tenants

As entidades filhas repetem `company_id`, mas foreign keys simples permitem combinações inconsistentes, como um fechamento da empresa A ligado a um caixa da empresa B ou uma despesa ligada à categoria de outra empresa.

Aprovar ou rejeitar a estratégia proposta no `ADR-0003`: chaves estrangeiras compostas por `[company_id, id]` nas relações tenant-scoped, além do scoping e das policies da aplicação.

Decisão: estratégia aceita com índices únicos de suporte, foreign keys compostas, validação Rails complementar, testes diretos no banco e controles documentados para exceções polimórficas.

Arquivos afetados: `ADR-0003`, `system-architecture.md`, `data-model.md`, `test-strategy.md`.

Estado: `RESOLVED`.

## Q-011 — Ciclo de vida de convites

`AUTH-004`, `AUTH-009` e `USR-025` exigem convite expirável com empresa, papel e ator autorizador, mas o modelo lógico não define onde ficam token digest, expiração, aceite, revogação e vínculo pretendido. Também não está definido o comportamento ao convidar um e-mail já cadastrado.

Default recomendado: entidade tenant-scoped `CompanyInvitation`, token armazenado apenas como digest, uso único, expiração e revogação explícitas; para usuário existente, o aceite cria ou ativa a membership sem alterar credenciais.

Decisão: modelar `CompanyInvitation` tenant-scoped com destinatário imutável, token digest, expiração, aceite/revogação, reenvio invalidante e aceite transacional que reutiliza usuário sem duplicar membership.

Arquivos afetados: `companies-and-users.md`, `data-model.md`, `authorization-matrix.md`.

Estado: `RESOLVED`.

## Q-012 — Atomicidade e imutabilidade da auditoria

O glossário chama `AuditLog` de imutável, enquanto `AUD-001` protege apenas logs financeiros e apenas contra edição pela interface. `AUD-008` exige tratamento explícito de falha, sem definir se a falha de auditoria deve reverter uma transação crítica.

Aprovar ou rejeitar a estratégia proposta no `ADR-0004`: auditoria crítica na mesma transação do domínio, com rollback em caso de falha; todos os logs sem update/delete pela aplicação; eventos não transacionais com falha observável e sem dados sensíveis.

Decisão: `ADR-0004` aceito. Eventos críticos participam da transação e sua falha impede a operação; eventos observacionais podem ser externos à transação. Todos os AuditLogs são imutáveis pela aplicação e testados.

Arquivos afetados: `ADR-0004`, `platform-and-audit.md`, `data-model.md`, `test-strategy.md`.

Estado: `RESOLVED`.

## Q-013 — Escopo do relatório de divergências

`CASH-025` afirma que somente fechamentos aprovados entram em relatórios, mas o relatório mínimo de divergências inclui `status`. Não está claro se esse relatório operacional deve mostrar enviados, aprovados e cancelados. Também não está definido qual ator é o “responsável” usado em `CASH-040` e exibido no relatório.

Default recomendado: receitas e indicadores financeiros usam apenas aprovados; o relatório operacional de divergências permite filtrar `submitted`, `approved` e `canceled`; “responsável” deve ser um filtro explícito por criador, remetente ou aprovador.

Decisão: relatório financeiro mostra somente `approved` e detalha caixa, data, turno, criador responsável, esperado, informado, diferença com sinal, justificativa, aprovador e data. Listagem operacional permanece separada e multistatus.

Arquivos afetados: `dashboard-and-reporting.md`, `cash-management.md`.

Estado: `RESOLVED`.

## Q-014 — Fonte verificável do escopo original

O critério de `M0-T01` exige confirmar que todas as áreas do prompt original estão em `specs/`, mas o repositório informa que o prompt antigo foi substituído e não preserva seu conteúdo. O commit inicial e o índice demonstram cobertura interna, mas não permitem comparação com a fonte original.

Decidir entre versionar uma cópia somente para rastreabilidade ou substituir o critério por uma matriz explícita de áreas esperadas, aprovada pelo responsável do produto.

Decisão: specs corrigidas foram aceitas como baseline normativa inicial. Criados brief histórico reconstruído, explicitamente não normativo, e matriz de cobertura.

Arquivos afetados: `specs/00-product/source-brief.md`, `planning/SOURCE_COVERAGE.md`, `specs/README.md`.

Estado: `RESOLVED`.

## Q-015 — Cardinalidade e ciclo de vida de comprovantes

`EXP-040` usa “anexo de comprovante” sem definir se uma despesa aceita um ou vários arquivos, nem o que ocorre com anexos quando um rascunho é excluído ou uma despesa é cancelada.

Default recomendado: múltiplos comprovantes por despesa, preservados no cancelamento e removidos com purge assíncrono apenas quando um rascunho elegível for excluído fisicamente.

Estado: `OPEN`.

## Q-016 — Invariantes de despesa e pagamento

O modelo não informa se `payment_method` é obrigatório antes do pagamento, nem explicita as equivalências `status = paid`/`paid_at` presente e `status = canceled`/justificativa e metadados de cancelamento presentes. Também falta definir “vencida” para despesas canceladas e segundo o timezone da empresa.

Default recomendado: forma de pagamento e `paid_at` obrigatórios somente em `paid`; os dois sentidos das invariantes de status devem ser validados; vencida é a despesa `pending` com `due_date` anterior à data local da empresa.

Decisão: forma, data e ator de pagamento são obrigatórios ao pagar e preservados após cancelamento; cancelamento exige metadados; vencida é somente `pending` anterior à data local. Edição por estado foi normatizada.

Arquivos afetados: `data-model.md`, `expenses.md`, `authorization-matrix.md`.

Estado: `RESOLVED`.

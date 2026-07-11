# ADR-0004 — Auditoria transacional para eventos críticos

Status: `ACCEPTED`

## Contexto

Mudanças financeiras e administrativas críticas devem produzir auditoria. `AUD-008` determina que falhas não sejam silenciosas, mas não define se o registro de domínio pode ser confirmado quando a auditoria falha. O glossário define o log como imutável, enquanto `AUD-001` limita a proteção explícita à edição de logs financeiros pela interface.

## Decisão

1. Gravar o `AuditLog` de toda mudança crítica na mesma transação de banco da mudança de domínio.
2. Se a auditoria crítica falhar, reverter a operação e apresentar erro observável, sem incluir dados sensíveis.
3. Proibir update e delete de todos os audit logs pela camada de aplicação; correções operacionais devem ser novos eventos correlacionados.
4. Para eventos sem transação de domínio, como falha de login, tentar gravação síncrona e emitir log operacional estruturado quando ela falhar.
5. Filtrar `changes_data` e `metadata` por allowlist para cumprir `AUD-006`.

São críticos e transacionais: criação, alteração e transição de fechamento; criação, pagamento e cancelamento de despesa; mudança de papel; ativação ou desativação de membership; suspensão ou reativação de empresa; acesso de suporte a dados financeiros; e ações administrativas que alterem autorização.

São observacionais e podem ser registrados fora de transação de domínio: login, logout, tentativa de autenticação e visualização comum.

## Consequências

- nenhuma transação crítica suportada termina sem o evento correspondente;
- indisponibilidade da tabela/serviço de auditoria impede a operação crítica em vez de degradar silenciosamente;
- eventos de autenticação que não alteram domínio precisam de observabilidade separada;
- não exige event sourcing nem infraestrutura adicional.

## Alternativas

- best-effort para todos os eventos: permite lacunas incompatíveis com a exigência de trilha crítica;
- auditoria assíncrona: pode perder evento entre commit e enqueue sem outbox;
- outbox transacional: robusta, mas adiciona complexidade ainda não justificada.

## Registro da decisão

Aceito em 2026-07-11 por decisão explícita do responsável do produto. A infraestrutura mínima deve preceder operações financeiras auditáveis, e falha de auditoria crítica deve impedir a operação correspondente.

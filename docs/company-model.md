# Modelo Company

`Company` representa uma empresa cliente e é a raiz global do isolamento lógico. Ela não é tenant-scoped: não possui `company_id` nem pertence a outra empresa. Entidades tenant-scoped futuras referenciarão `companies.id`, e o acesso será condicionado por membership e autorização implementadas em tarefas posteriores.

O slug e o UUID identificam a empresa, mas não autorizam acesso.

## Campos e defaults

| Campo | Regra atual |
|---|---|
| `id` | UUID gerado pelo PostgreSQL com `gen_random_uuid()` |
| `name` | obrigatório; espaços externos removidos; capitalização preservada |
| `legal_name` | opcional; espaços externos removidos; vazio vira `nil` |
| `slug` | obrigatório, global e adequado para URL |
| `document` | opcional; espaços externos removidos; vazio vira `nil` |
| `timezone` | identificador IANA obrigatório; default `America/Sao_Paulo` |
| `currency` | código obrigatório; default e único valor suportado `BRL` |
| `cash_difference_tolerance_cents` | `bigint` obrigatório, default zero, inteiro não negativo |
| `active` | boolean obrigatório, default `true` |
| `suspended_at` | datetime opcional |
| timestamps | obrigatórios pelo Rails |

Não existe `week_starts_on`: a primeira versão mantém semana fixa de segunda-feira a domingo.

## Slug

O model remove espaços externos e converte o slug para lowercase. O formato aceita somente letras ASCII minúsculas, números e hífens simples entre segmentos, por exemplo `empresa-exemplo` e `empresa-2`.

O PostgreSQL repete a proteção com o check nomeado `companies_slug_format` e garante unicidade global case-insensitive pelo índice funcional único `index_companies_on_lower_slug`, definido sobre `lower(slug)`. O slug é informado explicitamente: não é derivado de `name` e não muda quando o nome muda.

## Timezone e moeda

O timezone é armazenado como identificador IANA e validado por `TZInfo::Timezone.get`; nomes amigáveis do Active Support não são persistidos. O banco garante ao menos presença não vazia por `companies_timezone_not_blank`.

A moeda é normalizada para uppercase. A primeira versão aceita somente `BRL`, protegida também pelo check `companies_currency_supported`. O model não armazena símbolo/nome, formata valores nem realiza conversão cambial.

## Integridade no banco

Além de `null: false` e defaults, a migration define:

- `companies_name_not_blank`;
- `companies_slug_format`;
- `companies_timezone_not_blank`;
- `companies_currency_supported`;
- `companies_tolerance_non_negative`;
- índice único em `lower(slug)`.

Company é a raiz do tenant e não referencia entidade tenant-scoped, portanto esta migration não possui `company_id`, foreign key composta ou índice tenant-first. Essas proteções serão adicionadas nas tabelas filhas conforme ADR-0003.

## Documento e suspensão

`document` preserva o texto informado depois de remover espaços externos. Não há remoção de pontuação, validação completa de CNPJ, suporte a CPF, unicidade ou consulta externa nesta etapa.

`active` e `suspended_at` são somente dados estruturais nesta tarefa. Não há callback, máquina de estados, scope, policy, auditoria ou operação de suspensão/reativação. Services futuros coordenarão atomicamente a consistência operacional exigida entre os dois campos.

## Limites atuais

Não existem usuários, memberships, convites, autenticação, `Current.company`, resolução de tenant, controllers, rotas ou interface de gestão de empresas. Também não existem associações com models futuros. Esses elementos devem ser adicionados somente pelas tarefas responsáveis.

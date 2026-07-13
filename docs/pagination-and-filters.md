# Paginação e filtros

## Estado e objetivo

Esta infraestrutura fornece paginação server-side por offset e uma estrutura mínima de formulários `GET` para futuras listagens administrativas. Ela não implementa filtros, ordenação, tenant, autorização ou query objects de domínio.

Listagens reais devem paginar uma `ActiveRecord::Relation`. A coleção estática existente em testes serve somente para provar a integração sem criar model, migration, tabela ou dado financeiro fictício.

## Versão e API do Pagy

A dependência é `pagy ~> 43.6`; o lockfile resolveu `43.6.0`. Antes da integração foram inspecionados no pacote instalado o inicializador de exemplo, a aplicação Rails de exemplo, o paginator offset, o parser da request, a composição de links, a navegação em série, i18n e exceções.

A API utilizada é a atual da versão 43:

```ruby
include Pagy::Method

@pagy, @records = pagy(:offset, relation, request: pagination_request(list_params))
```

O objeto retornado fornece `page`, `limit`, `count`, `pages`, `from`, `to`, `in`, `previous`, `next` e `series_nav`. Não são usados os módulos antigos de backend/frontend, helpers antigos de navegação/informação ou constantes antigas de configuração. A aplicação usa `Pagy::OPTIONS` e os métodos do objeto conforme o código e o exemplo empacotados na gem.

## Configuração

`config/initializers/pagy.rb` define:

- paginator offset escolhido explicitamente em cada chamada;
- `page` como chave top-level da página;
- `limit` como chave reservada top-level;
- limite fixo de 25 registros;
- integração oficial com Rails I18n e rótulos em português;
- opções congeladas após a configuração.

O controle de limite pelo cliente está desabilitado nesta primeira versão. Na versão 43.6, `max_limit` limita valores altos, mas um valor negativo ainda chega à validação como inválido e pode levantar `Pagy::OptionError`. Sem `max_limit`, Pagy ignora qualquer `limit` da query e sempre usa 25; portanto não existe quantidade arbitrária ou ilimitada. Caso uma listagem futura demonstre necessidade de escolha pelo usuário, o teto será 100 e a normalização deverá ganhar testes antes de habilitar `max_limit`.

Não estão habilitados Bootstrap, Bulma, JavaScript do Pagy, dev tools, PagyWand, extras ou CSS externo.

## Política de páginas inválidas

O parser oficial do Pagy 43.6 converte a página para inteiro e aplica mínimo 1. Assim:

- `page=abc`, `page=0`, `page=-1` e estruturas malformadas resultam na primeira página;
- uma página acima da última mantém o número solicitado e retorna coleção vazia sem exceção por padrão;
- `limit` ausente, malformado, negativo ou excessivo é ignorado e o limite permanece 25;
- nenhuma consulta pode solicitar quantidade ilimitada.

Não há `rescue StandardError`, redirecionamento ou callback global. Em testes com `Array`, o slice Ruby retorna `nil` quando o offset excede a coleção; somente o controller exclusivo de teste converte esse resultado em `[]`. Uma `ActiveRecord::Relation` real retorna relation vazia para o mesmo offset.

## Integração em controllers

`ApplicationController` inclui `Pagy::Method`, mas não pagina automaticamente. Não há callback, acesso a model, `Current.company`, resolução de tenant ou alteração de parâmetros.

Cada controller futuro deve permitir somente as chaves da própria listagem e entregar esse conjunto a `pagination_request`. O helper protegido rejeita `ActionController::Parameters` não permitidos e constrói a request Pagy com base/path atuais, sem cookies e sem copiar a request inteira.

Exemplo futuro, não implementado:

```ruby
def index
  relation = Expenses::FilterQuery.new(
    relation: authorized_expenses,
    filters: expense_filter_params
  ).call

  @pagy, @expenses = pagy(
    :offset,
    relation,
    request: pagination_request(expense_list_params)
  )
end

def expense_list_params
  params.permit(
    :page,
    :sort,
    :direction,
    filter: %i[status query start_date end_date category_id]
  )
end
```

As chaves acima são apenas exemplos futuros. Elas não criam filtros de despesas nesta tarefa. O controller concreto poderá separar os parâmetros da query e os da URL, mas ambos devem possuir allowlists explícitas.

Nunca usar `params.to_unsafe_h`, copiar params/cookies/headers indiscriminadamente ou preservar token, senha, secret ou outra entrada apenas porque apareceu na request.

## Partial de paginação

O contrato é explícito:

```erb
<%= render "shared/pagination", pagy: @pagy %>
```

`app/views/shared/_pagination.html.erb`:

- não renderiza nada para `pagy: nil`;
- informa intervalo/total, página vazia ou total vazio em texto;
- omite o `nav` quando só existe uma página;
- usa `series_nav` server-side em múltiplas páginas;
- fornece nome acessível em português, anterior/próxima textuais, `aria-current="page"` e estados desabilitados;
- funciona por links HTML, sem JavaScript, e continua compatível com Turbo;
- recebe somente os parâmetros permitidos fornecidos ao Pagy e os preserva na query string.

`series_nav` retorna uma string de markup gerada pela própria gem. O exemplo Rails empacotado no Pagy 43.6 renderiza essa saída sem escape; o partial segue a forma ERB `<%== ... %>`. A gem escapa chaves/valores ao compor a query, e a aplicação limita a entrada a parâmetros permitidos. Nenhuma entrada de usuário recebe `html_safe`.

Os estilos locais oferecem alvos mínimos, foco visível, estado atual por cor e semântica, estado desabilitado, quebra controlada em telas pequenas e ocultação da navegação na impressão.

## Formulários de filtro

O helper exige destinos explícitos:

```erb
<%= filter_form_with url: destination_path, clear_url: destination_path do |form| %>
  <%= form.label :query, "Busca", class: "form-label" %>
  <%= form.search_field :query, class: "form-input" %>
<% end %>
```

Ele usa `form_with`, força método `GET`, `scope: :filter` e `role="search"`, preserva classes adicionais e inclui “Filtrar” e “Limpar filtros”. O link de limpeza usa exatamente a URL fornecida pelo chamador; o helper não deriva, reescreve ou manipula strings de URL.

Campos específicos vêm do bloco e devem ter labels visíveis. O helper não conhece caixas, despesas ou relatórios e não permite parâmetros no controller.

## Convenção de parâmetros e limpeza

Filtros futuros usam um hash aninhado:

```text
filter[status]
filter[query]
filter[start_date]
filter[end_date]
filter[category_id]
```

`page`, `sort` e `direction` ficam fora de `filter`. O formulário não possui campo `page`, então aplicar qualquer filtro cria uma nova query na primeira página. A URL de limpeza deve ser fornecida sem `filter` e sem `page`, removendo ambos de modo explícito e compartilhável.

Valores vazios devem ser ignorados pela query object concreta. Parsing de datas/enums pertence ao objeto específico. Não existe classe genérica `Filter`, `FilterParams`, `SearchService` ou DSL nesta infraestrutura.

## Preservação segura da query string

Pagy preserva os parâmetros presentes na request segura fornecida. O controller é responsável por permitir explicitamente:

- chaves conhecidas dentro de `filter`;
- `page` para leitura e substituição nos links;
- `sort` e `direction` somente quando a listagem implementar whitelist segura;
- outra chave legítima específica da listagem.

Parâmetros não permitidos não chegam ao Pagy. O conjunto de testes prova que filtros aninhados e ordenação permitida permanecem nos links, enquanto `token` e uma chave tenant arbitrária não são propagados.

## Ordenação futura

A convenção será:

```text
sort=created_at&direction=desc
```

Cada query object deverá mapear `sort` por whitelist de colunas conhecidas e aceitar somente `asc` ou `desc`. Nunca interpolar parâmetros em SQL. Paginação ocorre depois dos filtros e de uma ordenação estável; resultados paginados precisam de desempate determinístico, normalmente timestamp mais UUID. Nenhuma ordenação real ou `SortingConcern` foi criada aqui.

## Multi-tenancy, autorização e query objects

A ordem obrigatória para listagens futuras é:

```text
relation tenant-scoped
→ policy scope ou autorização
→ filtros
→ ordenação estável
→ paginação
→ apresentação
```

Nunca começar por `Model.all`, paginar e filtrar a empresa em Ruby. Pagy não resolve tenant nem autoriza. A relation já deve estar limitada à empresa e ao ator; por isso o total calculado também não inclui outra empresa. Parâmetros de paginação não alteram tenant, e paginação não justifica `unscoped`.

Query objects continuam recebendo relation explícita, autorizada e tenant-scoped, aplicam filtros/ordenação no banco e retornam `ActiveRecord::Relation` quando possível. Paginação permanece na integração do controller/apresentação e é aplicada ao resultado final.

## Acessibilidade e testes

A navegação usa elementos nativos e funciona por teclado. O estado atual possui texto e `aria-current`; anterior/próxima não dependem de ícones; links indisponíveis usam `aria-disabled`; o `nav` tem nome acessível. CSS mantém foco visível, contraste, área clicável e quebra em 360 px.

Specs cobrem:

- inclusão da API, páginas 1/2, limite, metadados e coleção original;
- página inválida/acima da última e limite de cliente ignorado;
- partial em múltiplas/uma/nenhuma instância e preservação aninhada;
- formulário GET, semântica de busca, URL/limpeza, labels, botão e ausência de `page`;
- allowlist de parâmetros e ausência de propagação sensível;
- Chromium headless: navegação, URL, teclado/foco, 360 px e retorno à página 1.

As rotas/controller auxiliares existem somente quando `Rails.env.test?`; não há página de demonstração ou endpoint de infraestrutura em produção.

## Limitações e recursos adiados

Nesta versão o limite é fixo, há uma paginação por página HTML e não existe paginação JSON. Foram deliberadamente adiados: limite escolhido pelo cliente, keyset/cursor, countish, countless, infinite scroll, carregamento automático, paginação client-side, múltiplas paginações, Turbo Frames específicos de listagem, busca textual, filtros/ordenação reais, query objects de domínio, Ransack e outras gems de paginação/busca.

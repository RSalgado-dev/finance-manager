# Fundação visual

Esta é a base visual mínima da aplicação, não um design system definitivo. Ela usa ERB, helpers Rails e Tailwind CSS, sem bibliotecas externas de componentes ou JavaScript obrigatório.

## Layouts

- `application`: documento HTML compartilhado, metadados, CSRF, CSP, assets, importmap e idioma `pt-BR`;
- `public`: página institucional e futuras telas públicas, com navegação mínima e rodapé;
- `platform`: estrutura futura do painel técnico, sem rotas ou autenticação antecipadas;
- `tenant`: estrutura futura do contexto de empresa, sem depender de `Current.company`;
- `print`: conteúdo sem navegação ou controles interativos, com largura e estilos próprios para impressão.

Os layouts especializados preenchem `layout_body` e renderizam `application`. Cada página deve manter somente um landmark `main` e uma hierarquia de títulos coerente.

## Elementos compartilhados

Os partials ficam em `app/views/shared/`:

- `_page_header`: título obrigatório, descrição e ações opcionais;
- `_flash_messages`: mensagens Rails com rótulo textual, papel semântico e conteúdo sanitizado;
- `_card`: agrupamento simples de conteúdo com título opcional;
- `_empty_state`: título, descrição e ação opcional;
- `_table`: wrapper responsivo, caption, cabeçalhos com `scope="col"`, linhas e estado vazio;
- `_form_errors`: resumo e lista de erros de qualquer objeto compatível com Active Model.

Helpers em `ApplicationHelper` mantêm apenas lógica de apresentação já utilizada: título da página, apresentação de flash, classes de botão, badge textual e resumo de erros.

## Botões e ações

Use `button_classes` com as variantes:

- `primary`: ação principal da página;
- `secondary`: alternativa relacionada à ação principal;
- `neutral`: ação de baixa ênfase;
- `destructive`: ação com consequência destrutiva;
- `disabled: true`: aparência inativa complementar ao atributo HTML `disabled` em botões.

Links devem continuar sendo usados para navegação e botões para ações. Ações destrutivas futuras também devem cumprir confirmação e autorização; esta fundação define somente a apresentação.

## Flash e badges

Flash aceita `success`/`notice`, `warning`, `error`/`alert` e `information`/`info`. Erro e aviso usam `role="alert"`; sucesso e informação usam `role="status"`. Toda variante mostra um rótulo, portanto a interpretação não depende somente de cor.

`status_badge(label, tone:)` aceita `neutral`, `success`, `warning`, `error` e `information`. O texto é obrigatório; não use apenas cor ou ícone para comunicar estado.

## Formulários

As classes `form-label`, `form-input`, `form-hint`, `form-field-error` e `form-error-summary` fornecem a convenção mínima. Todo campo futuro deve possuir label associado, ajuda quando necessária e mensagem de erro compreensível. O partial `_form_errors` apresenta quantidade e mensagens em português; traduções de atributos continuam pertencendo a cada formulário ou model.

## Tabelas e estados vazios

Tabelas devem informar caption e cabeçalhos, permanecer dentro do wrapper com overflow horizontal explícito e oferecer estado vazio textual. Grupos de ações devem aceitar quebra de linha. Não esconda dados importantes somente para acomodar telas pequenas.

Estados vazios devem explicar a ausência de conteúdo e só receber uma ação quando ela existir e estiver autorizada.

## Acessibilidade e responsividade

- documento em `pt-BR`, landmarks sem duplicação e headings ordenados;
- foco visível e contraste de texto/controles;
- navegação por teclado com elementos HTML conforme sua semântica;
- feedback e status sempre textuais;
- redução de movimento respeitada por `prefers-reduced-motion`;
- conteúdo com largura e espaçamento progressivos para celular, tablet e desktop;
- tabelas isolam overflow horizontal sem provocar overflow da página.

## Impressão

O layout `print` omite navegação. Em mídia de impressão, `.no-print`, botões e submits são removidos; fundos, sombras e largura são simplificados. Título, período e identificação da empresa serão fornecidos pelos relatórios futuros, não por esta tarefa.

## Validação

Execute no Dev Container:

```bash
bin/rails tailwindcss:build
RAILS_ENV=test SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
bundle exec rspec
```

A página institucional está em `/` e o healthcheck permanece em `/up`.

## Limites

Esta fundação não inclui autenticação, empresa ativa, autorização, paginação, dados financeiros, gráficos, uploads, temas ou modo escuro. Novos componentes devem nascer de uso concreto, sem transformar os partials atuais em uma camada genérica paralela ao Rails.

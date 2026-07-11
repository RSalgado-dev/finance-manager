# Product Specification

## Visão

Criar um sistema web multi-tenant para gestão financeira operacional de pequenas e médias empresas, com foco em fechamento de caixa, despesas, acompanhamento de divergências e relatórios periódicos.

## Objetivos

- `PRD-001 MUST` Centralizar fechamentos de caixa por empresa e ponto de operação.
- `PRD-002 MUST` Centralizar despesas, categorias, fornecedores e comprovantes.
- `PRD-003 MUST` Fornecer relatórios semanais, mensais, anuais e personalizados.
- `PRD-004 MUST` Impedir acesso cruzado entre empresas.
- `PRD-005 MUST` Disponibilizar painel técnico para administrar empresas e usuários.
- `PRD-006 MUST` Manter trilha de auditoria para eventos críticos.
- `PRD-007 SHOULD` Ser utilizável em desktop e celular.
- `PRD-008 MUST` Ser implantável por container em ambiente de produção.

## Atores

### Platform administrator

- `PRD-ACTOR-001 MUST` Platform administrator operar a plataforma globalmente conforme a matriz normativa, incluindo empresas, identidades, vínculos e suporte auditado.

### Company administrator

- `PRD-ACTOR-002 MUST` Company administrator administrar os recursos autorizados da própria empresa conforme a matriz normativa.

### Manager

- `PRD-ACTOR-003 MUST` Manager gerenciar e aprovar operações financeiras e consultar/exportar relatórios nos limites da matriz normativa.

### Operator

- `PRD-ACTOR-004 MUST` Operator registrar operações do dia a dia e enviar seus rascunhos, sem permissão de aprovação.

### Viewer

- `PRD-ACTOR-005 MUST` Viewer possuir somente as permissões de leitura e export explicitamente previstas na matriz normativa.

## Escopo funcional inicial

- `PRD-SCOPE-001 MUST` Incluir autenticação sem cadastro público.
- `PRD-SCOPE-002 MUST` Incluir empresas, memberships e convites.
- `PRD-SCOPE-003 MUST` Incluir gestão de caixas, fechamentos e movimentações detalhadas.
- `PRD-SCOPE-004 MUST` Incluir despesas, categorias, fornecedores e comprovantes privados.
- `PRD-SCOPE-005 MUST` Incluir dashboard, relatórios HTML, impressão e CSV.
- `PRD-SCOPE-006 MUST` Incluir painel global e suporte auditado.
- `PRD-SCOPE-007 MUST` Incluir auditoria crítica e observacional conforme ADR-0004.
- `PRD-SCOPE-008 MUST` Incluir e-mails transacionais e jobs necessários.
- `PRD-SCOPE-009 MUST` Incluir Docker de desenvolvimento e produção, CI e documentação de deploy.

## Fora de escopo

- `PRD-101 MUST NOT` Implementar emissão de nota fiscal.
- `PRD-102 MUST NOT` Implementar integração bancária.
- `PRD-103 MUST NOT` Implementar conciliação automática.
- `PRD-104 MUST NOT` Implementar folha de pagamento.
- `PRD-105 MUST NOT` Implementar estoque.
- `PRD-106 MUST NOT` Implementar integração com adquirentes.
- `PRD-107 MUST NOT` Implementar cobrança de assinatura.
- `PRD-108 MUST NOT` Implementar checkout.
- `PRD-109 MUST NOT` Implementar contabilidade fiscal.
- `PRD-110 MUST NOT` Implementar aplicativo mobile nativo.
- `PRD-111 MUST NOT` Implementar microserviços.

- `PRD-112 MUST NOT` Implementar incidentalmente itens fora do escopo.

## Critérios de sucesso da primeira versão

- `PRD-SUCCESS-001 MUST` Demonstrar duas empresas operando sem vazamento de dados.
- `PRD-SUCCESS-002 MUST` Executar um fluxo completo de fechamento.
- `PRD-SUCCESS-003 MUST` Executar um fluxo completo de despesa.
- `PRD-SUCCESS-004 MUST` Demonstrar que dashboards e relatórios usam os mesmos cálculos centrais.
- `PRD-SUCCESS-005 MUST` Demonstrar que exports respeitam tenant e filtros.
- `PRD-SUCCESS-006 MUST` Inicializar a aplicação sobre banco vazio.
- `PRD-SUCCESS-007 MUST` Passar testes, lint e verificações de segurança aplicáveis.
- `PRD-SUCCESS-008 MUST` Construir a imagem de produção.
- `PRD-SUCCESS-009 MUST` Documentar deploy e recuperação.

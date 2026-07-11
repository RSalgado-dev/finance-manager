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

Opera a plataforma globalmente, cria empresas, cria ou convida usuários, administra vínculos e presta suporte auditado.

### Company administrator

Administra configurações, usuários, caixas, fechamentos, despesas, relatórios e auditoria da própria empresa.

### Manager

Gerencia e aprova operações financeiras, consulta e exporta relatórios.

### Operator

Registra operações do dia a dia e envia informações para aprovação, sem poder aprovar o próprio fechamento.

### Viewer

Possui acesso somente de leitura a dashboards, registros permitidos e relatórios.

## Escopo funcional inicial

- autenticação sem cadastro público;
- empresas e memberships;
- gestão de caixas;
- fechamento de caixa;
- movimentações detalhadas;
- despesas, categorias e fornecedores;
- anexos privados;
- dashboard;
- relatórios e CSV;
- painel global;
- auditoria;
- e-mails transacionais;
- jobs;
- Docker, CI e deploy.

## Fora de escopo

- `PRD-101` emissão de nota fiscal;
- `PRD-102` integração bancária;
- `PRD-103` conciliação automática;
- `PRD-104` folha de pagamento;
- `PRD-105` estoque;
- `PRD-106` integração com adquirentes;
- `PRD-107` cobrança de assinatura;
- `PRD-108` checkout;
- `PRD-109` contabilidade fiscal;
- `PRD-110` aplicativo mobile nativo;
- `PRD-111` microserviços.

Itens fora do escopo não devem ser implementados incidentalmente.

## Critérios de sucesso da primeira versão

- duas empresas de demonstração operam sem vazamento de dados;
- um fluxo completo de fechamento é executável;
- um fluxo completo de despesa é executável;
- dashboards e relatórios usam os mesmos cálculos centrais;
- exports respeitam tenant e filtros;
- aplicação sobe em banco vazio;
- testes, lint e verificações de segurança passam;
- imagem de produção é construída;
- deploy e recuperação estão documentados.

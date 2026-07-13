# Autenticação

A autenticação usa `User` e `Session` globais. Ela comprova identidade, mas não resolve empresa, membership ou autorização. Esses contextos permanecem para tarefas posteriores.

## User global

`User` possui UUID, nome, e-mail, digest BCrypt, estado ativo, papel global e `last_sign_in_at`. Não possui `company_id`; futuramente poderá participar de várias empresas por `CompanyMembership`.

- nome: obrigatório, strip, até 160 caracteres;
- e-mail: obrigatório, `strip.downcase`, até 254 caracteres e único globalmente por `lower(email)`;
- senha: `has_secure_password reset_token: false`, mínimo 12 e máximo BCrypt de 72 bytes/caracteres ASCII;
- papel global: `user` ou `platform_admin`, sem relação com papéis empresariais;
- estado: `active=true` por default;
- `last_sign_in_at`: atualizado explicitamente somente quando o login conclui com sucesso.

Não há callback que autentique, crie sessão, conceda papel ou atualize sign-in.

## Session persistida

Cada login cria uma `Session` UUID no PostgreSQL, ligada a User por foreign key com `ON DELETE CASCADE`. IP e user agent são metadados opcionais da request; não são fatores de autenticação e não provocam parsing manual de headers.

A persistência no banco permite revogar uma sessão removendo seu registro. Não existem JWT, refresh token, fingerprint, timeout próprio ou política avançada de dispositivos nesta etapa.

## Cookie

O navegador recebe somente o UUID da Session em cookie assinado `session_id`. O cookie é `httponly`, `same_site: :lax` e `secure` em produção. Ele não contém user ID, e-mail, papel, empresa, senha, headers ou objeto serializado.

Toda request verifica que o UUID assinado ainda corresponde a uma Session existente e a um User ativo. Cookie sem registro não autentica.

## Fluxo de login

`POST /session` permite somente `email` e `password`, normaliza o e-mail e usa `User.authenticate_by`. E-mail inexistente, senha incorreta e User inativo recebem a mesma mensagem: `E-mail ou senha inválidos.`

No sucesso:

1. um return path local previamente armazenado é consumido;
2. a Rails session é renovada por `reset_session` para mitigar session fixation;
3. uma Session autenticada anterior da mesma request é descartada, quando existir;
4. nova Session é criada e `last_sign_in_at` atualizado na mesma transação;
5. o cookie assinado é emitido;
6. o usuário retorna ao path local seguro ou a `/`.

Parâmetro externo de retorno não é aceito. Caminhos absolutos, protocol-relative ou inválidos são descartados, evitando open redirect.

## Retomada, Current e callbacks

`RequestContext` continua responsável por limpar Current antes/depois da request e por preencher request ID, IP e user agent. Dentro desse ciclo, `Authentication` resolve a Session e atribui somente `Current.user`.

Os atributos permanecem exatamente `user`, `company`, `membership`, `request_id`, `ip_address` e `user_agent`. Não existe `Current.session`; `Current.company` e `Current.membership` continuam nulos. Specs cobrem disponibilidade durante action e cleanup após resposta/exceção.

## Proteção deny-by-default

`ApplicationController` inclui `Authentication`, portanto controllers exigem login por default. Controllers públicos declaram `allow_unauthenticated_access`; atualmente são Home e as actions `new`/`create` de Sessions. Rotas de teste condicionais também declaram o opt-out necessário.

Essa camada autentica apenas. Ela não implementa Pundit, papel empresarial, platform authorization ou tenant scoping.

## Usuário inativo

User inativo não cria nova Session e não atualiza `last_sign_in_at`. Se a Session já existir, a request não recebe `Current.user`, o registro atual é destruído, o cookie removido e a rota protegida redireciona para login com mensagem não enumerativa. Outras Sessions do usuário não são removidas por essa retomada; revogação global pertence a operação administrativa futura.

## Logout

`DELETE /session` destrói somente a Session atual, remove o cookie, renova/limpa a Rails session e redireciona para `/`. Acesso protegido posterior exige novo login.

## Ausências deliberadas

- não há cadastro público nem controller/rota de criação de User;
- não há recuperação/alteração de senha, token ou mailer; M2-T06 será responsável;
- não há membership, convite, empresa atual ou resolução por slug;
- não há MFA, login social, confirmação de e-mail, remember-me ou JWT;
- rate limiting e política de timeout permanecem para hardening futuro;
- não há auditoria persistida nesta tarefa.

## Validação em desenvolvimento/teste

Usuários só devem ser criados manualmente em desenvolvimento/teste enquanto não existir fluxo administrativo. Use uma senha fornecida por variável de ambiente, nunca uma credencial fixa versionada:

```bash
docker compose -f .devcontainer/compose.yaml exec \
  -e AUTH_CHECK_PASSWORD app bin/rails runner '
    abort unless Rails.env.development? || Rails.env.test?
    User.create!(
      name: "Usuário local",
      email: "local@example.test",
      password: ENV.fetch("AUTH_CHECK_PASSWORD"),
      password_confirmation: ENV.fetch("AUTH_CHECK_PASSWORD")
    )
  '
```

Remova o registro de validação quando não for mais necessário. Produção dependerá do fluxo administrativo/convite especificado, não de seed com senha.

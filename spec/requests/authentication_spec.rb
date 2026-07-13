require "rails_helper"

RSpec.describe "Autenticação", type: :request do
  let(:password) { "temporary-password-123" }
  let(:user) { create(:user, password: password, password_confirmation: password) }
  let(:protected_path) { "/__test__/authentication" }

  after do
    Current.reset
    AuthenticationTestController.observed_context = nil
  end

  it "renderiza formulário público acessível sem recuperação ou cadastro" do
    get new_session_path

    document = Capybara.string(response.body)
    expect(response).to have_http_status(:ok)
    expect(document).to have_css("h1", text: "Entrar")
    expect(document).to have_field("E-mail", type: "email")
    expect(document).to have_field("Senha", type: "password")
    expect(document).to have_button("Entrar")
    expect(document).to have_no_link("Esqueci minha senha")
    expect(document).to have_no_link("Criar conta")
    expect(document).to have_no_link("Cadastro")
  end

  it "autentica, cria Session com metadados, emite cookie e atualiza last_sign_in_at" do
    expect do
      post session_path,
        params: { email: user.email.upcase, password: password },
        headers: { "REMOTE_ADDR" => "192.0.2.44", "User-Agent" => "Request auth spec" }
    end.to change(Session, :count).by(1)

    authentication_session = Session.last
    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("Login realizado com sucesso.")
    expect(authentication_session).to have_attributes(
      user: user,
      ip_address: "192.0.2.44",
      user_agent: "Request auth spec"
    )
    expect(user.reload.last_sign_in_at).to be_present
    cookie_header = Array(response.headers.fetch("Set-Cookie")).join("; ").downcase
    expect(cookie_header).to include("session_id=", "httponly", "samesite=lax")

    get protected_path, headers: { "X-Request-Id" => "authenticated-request" }

    expect(response).to have_http_status(:ok)
    expect(AuthenticationTestController.observed_context).to include(
      user: user,
      company: nil,
      membership: nil,
      request_id: "authenticated-request",
      authentication_session_id: authentication_session.id
    )
    expect(Current.user).to be_nil
  end

  it "ignora parâmetros adicionais no login" do
    post session_path, params: {
      email: user.email,
      password: password,
      system_role: "platform_admin",
      active: false
    }

    expect(response).to redirect_to(root_path)
    expect(user.reload).to be_user
    expect(user).to be_active
  end

  it "usa a mesma falha genérica para e-mail inexistente e senha incorreta" do
    initial_sign_in = user.last_sign_in_at

    expect do
      post session_path, params: { email: "missing@example.test", password: password }
    end.not_to change(Session, :count)
    expect(flash[:alert]).to eq("E-mail ou senha inválidos.")

    expect do
      post session_path, params: { email: user.email, password: "incorrect-password-123" }
    end.not_to change(Session, :count)
    expect(flash[:alert]).to eq("E-mail ou senha inválidos.")
    expect(user.reload.last_sign_in_at).to eq(initial_sign_in)
  end

  it "não autentica usuário inativo nem atualiza last_sign_in_at" do
    inactive_user = create(:user, :inactive, password: password, password_confirmation: password)

    expect do
      post session_path, params: { email: inactive_user.email, password: password }
    end.not_to change(Session, :count)

    expect(response).to redirect_to(new_session_path)
    expect(flash[:alert]).to eq("E-mail ou senha inválidos.")
    expect(inactive_user.reload.last_sign_in_at).to be_nil
  end

  it "protege por padrão e retorna ao path local após login" do
    get protected_path

    expect(response).to redirect_to(new_session_path)
    expect(flash[:alert]).to eq("Entre para continuar.")

    post session_path, params: { email: user.email, password: password }

    expect(response).to redirect_to(protected_path)
  end

  it "rejeita retorno externo armazenado" do
    get "/__test__/authentication/unsafe_return", params: { path: "//evil.example/path" }

    post session_path, params: { email: user.email, password: password }

    expect(response).to redirect_to(root_path)
  end

  it "renova a Rails session ao autenticar" do
    session_key = Rails.application.config.session_options.fetch(:key)

    get "/__test__/authentication/seed"
    previous_cookie = cookies[session_key]

    post session_path, params: { email: user.email, password: password }

    expect(cookies[session_key]).to be_present
    expect(cookies[session_key]).not_to eq(previous_cookie)

    get protected_path
    expect(AuthenticationTestController.observed_context.fetch(:pre_authentication_marker)).to be_nil
  end

  it "logout destrói somente a Session atual e remove autenticação" do
    other_session = create(:session, user: user)
    post session_path, params: { email: user.email, password: password }
    current_session = Session.where.not(id: other_session.id).find_by!(user: user)

    delete session_path

    expect(response).to redirect_to(root_path)
    expect(response).to have_http_status(:see_other)
    expect(flash[:notice]).to eq("Sessão encerrada com sucesso.")
    expect(Session.exists?(current_session.id)).to be(false)
    expect(Session.exists?(other_session.id)).to be(true)

    get protected_path
    expect(response).to redirect_to(new_session_path)
  end

  it "invalida somente a sessão retomada quando User fica inativo" do
    post session_path, params: { email: user.email, password: password }
    current_session = Session.find_by!(user: user)
    other_session = create(:session, user: user)
    user.update!(active: false)

    get protected_path

    expect(response).to redirect_to(new_session_path)
    expect(Session.exists?(current_session.id)).to be(false)
    expect(Session.exists?(other_session.id)).to be(true)
    expect(Current.user).to be_nil
  end

  it "limpa Current depois de exceção autenticada" do
    post session_path, params: { email: user.email, password: password }

    expect do
      get "/__test__/authentication/failure", headers: { "X-Request-Id" => "failed-auth-request" }
    end.to raise_error(RuntimeError, "falha controlada após autenticação")

    expect(AuthenticationTestController.observed_context).to include(
      user: user,
      company: nil,
      membership: nil,
      request_id: "failed-auth-request"
    )
    expect(Current.user).to be_nil
  end
end

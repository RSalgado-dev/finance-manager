require "rails_helper"

RSpec.describe "Login e logout", type: :system do
  let(:password) { "temporary-password-123" }
  let(:user) { create(:user, password: password, password_confirmation: password) }

  it "autentica, apresenta usuário na navegação e encerra a sessão" do
    visit new_session_path

    expect(page).to have_css("h1", text: "Entrar")
    expect(page).to have_field("E-mail", type: "email")
    expect(page).to have_field("Senha", type: "password")

    fill_in "E-mail", with: user.email
    fill_in "Senha", with: password
    click_button "Entrar"

    expect(page).to have_current_path(root_path)
    expect(page).to have_text("Login realizado com sucesso.")
    expect(page).to have_text(user.name)
    expect(page).to have_button("Sair")

    click_button "Sair"

    expect(page).to have_current_path(root_path)
    expect(page).to have_text("Sessão encerrada com sucesso.")
    expect(page).to have_link("Entrar")
  end

  it "mostra falha genérica para credencial inválida e usuário inativo" do
    visit new_session_path
    fill_in "E-mail", with: user.email
    fill_in "Senha", with: "incorrect-password-123"
    click_button "Entrar"

    expect(page).to have_text("E-mail ou senha inválidos.")

    inactive_user = create(:user, :inactive)
    fill_in "E-mail", with: inactive_user.email
    fill_in "Senha", with: inactive_user.password
    click_button "Entrar"

    expect(page).to have_text("E-mail ou senha inválidos.")
  end

  it "mantém autocomplete, teclado e responsividade em 360 px" do
    page.current_window.resize_to(360, 800)
    visit new_session_path

    expect(page).to have_css("input[type='email'][autocomplete='email']")
    expect(page).to have_css("input[type='password'][autocomplete='current-password']")

    page.find("body").send_keys(:tab)
    focused = page.evaluate_script("document.activeElement")
    expect(focused).to be_present

    has_overflow = page.evaluate_script(
      "document.documentElement.scrollWidth > document.documentElement.clientWidth"
    )
    expect(has_overflow).to be(false)
  end
end

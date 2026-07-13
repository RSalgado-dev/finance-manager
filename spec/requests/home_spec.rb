require "rails_helper"

RSpec.describe "Página inicial", type: :request do
  it "renderiza a página institucional pública em português" do
    get root_path

    document = Capybara.string(response.body)

    expect(response).to have_http_status(:ok)
    expect(document).to have_css("html[lang='pt-BR']")
    expect(document).to have_css("main#main-content", count: 1)
    expect(document).to have_css("h1", text: "Finance Manager")
    expect(document).to have_title("Início — Finance Manager")
    expect(document).to have_text("Em desenvolvimento")
    expect(document).to have_link("Início", href: root_path)
    expect(document).to have_link("Entrar", href: new_session_path)
  end

  it "não oferece links para funcionalidades futuras" do
    get root_path

    document = Capybara.string(response.body)

    expect(document).to have_no_link("Cadastro")
    expect(document).to have_no_link("Dashboard")
    expect(document).to have_no_link("Empresas")
    expect(document).to have_no_link("Caixas")
    expect(document).to have_no_link("Despesas")
    expect(document).to have_no_link("Relatórios")
  end

  it "mantém o healthcheck disponível" do
    get rails_health_check_path

    expect(response).to have_http_status(:ok)
  end
end

require "rails_helper"

RSpec.describe "Infraestrutura de paginação", type: :request do
  let(:path) { "/__test__/pagination" }

  it "disponibiliza a API atual no controller e pagina a primeira página" do
    expect(ApplicationController).to be < Pagy::Method

    get path

    document = Capybara.string(response.body)
    expect(response).to have_http_status(:ok)
    expect(document).to have_css("[data-page='1'][data-limit='25'][data-count='60'][data-pages='3']")
    expect(document).to have_css("[data-record]", count: 25)
    expect(document).to have_css("[data-record='1']", text: "Registro 1")
    expect(document).to have_no_css("[data-record='26']")
  end

  it "pagina a segunda página com metadados coerentes sem alterar a coleção" do
    original = PaginationTestController::RECORDS.dup

    get path, params: { page: 2 }

    document = Capybara.string(response.body)
    expect(response).to have_http_status(:ok)
    expect(document).to have_css("[data-page='2'][data-limit='25'][data-count='60'][data-pages='3']")
    expect(document).to have_css("[data-record]", count: 25)
    expect(document).to have_css("[data-record='26']")
    expect(document).to have_css("[data-record='50']")
    expect(PaginationTestController::RECORDS).to eq(original)
    expect(PaginationTestController::RECORDS).to be_frozen
  end

  it "normaliza páginas malformadas, zero e negativas para a primeira página" do
    [ "abc", "0", "-1", { unexpected: "value" } ].each do |page|
      get path, params: { page: page }

      document = Capybara.string(response.body)
      expect(response).to have_http_status(:ok)
      expect(document).to have_css("[data-page='1']")
      expect(document).to have_css("[data-record='1']")
    end
  end

  it "responde de forma controlada com coleção vazia acima da última página" do
    get path, params: { page: 99 }

    document = Capybara.string(response.body)
    expect(response).to have_http_status(:ok)
    expect(document).to have_css("[data-page='99'][data-count='60']")
    expect(document).to have_no_css("[data-record]")
    expect(document).to have_text("Nenhum registro nesta página.")
  end

  it "ignora limites do cliente, inclusive excessivos e inválidos" do
    [ "1000", "-1", "abc" ].each do |limit|
      get path, params: { limit: limit }

      document = Capybara.string(response.body)
      expect(response).to have_http_status(:ok)
      expect(document).to have_css("[data-limit='25']")
      expect(document).to have_css("[data-record]", count: 25)
    end
  end

  it "preserva filtros e ordenação permitidos sem propagar parâmetros arbitrários" do
    get path, params: {
      filter: { query: "conta azul", status: "active", company_id: "other-company" },
      sort: "created_at",
      direction: "desc",
      token: "secret-value"
    }

    document = Capybara.string(response.body)
    next_link = document.find_link("Próxima")[:href]
    query = Rack::Utils.parse_nested_query(URI.parse(next_link).query)

    expect(query).to include(
      "page" => "2",
      "sort" => "created_at",
      "direction" => "desc",
      "filter" => { "query" => "conta azul", "status" => "active" }
    )
    expect(query).not_to have_key("token")
    expect(query.fetch("filter")).not_to have_key("company_id")
  end

  it "começa na primeira página quando o novo filtro não envia page" do
    get path, params: { filter: { query: "novo filtro" } }

    document = Capybara.string(response.body)
    expect(response).to have_http_status(:ok)
    expect(document).to have_css("[data-page='1']")
    expect(document).to have_field("filter[query]", with: "novo filtro")
  end

  it "rejeita a construção de links a partir de parâmetros não permitidos" do
    controller = ApplicationController.new
    allow(controller).to receive(:request).and_return(
      instance_double(ActionDispatch::Request, base_url: "http://test.host", path: "/items")
    )

    expect do
      controller.send(:pagination_request, ActionController::Parameters.new(token: "secret"))
    end.to raise_error(ArgumentError, "pagination params must be explicitly permitted")
  end
end

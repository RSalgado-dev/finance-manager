require "rails_helper"

RSpec.describe "Paginação compartilhada", type: :view do
  def build_pagy(count:, page: 1, params: {})
    pagy_request = Pagy::Request.new(
      request: {
        base_url: "http://test.host",
        path: "/items",
        params: params,
        cookie: nil
      }
    )

    Pagy::Offset.new(count: count, page: page, limit: 25, request: pagy_request)
  end

  it "renderiza navegação acessível, página atual e controles textuais" do
    pagy = build_pagy(count: 60, page: 2)

    render partial: "shared/pagination", locals: { pagy: pagy }

    expect(rendered).to have_css("nav[aria-label='Paginação dos resultados']")
    expect(rendered).to have_css("a[aria-current='page']", text: "2")
    expect(rendered).to have_link("Anterior", href: "/items?page=1")
    expect(rendered).to have_link("Próxima", href: "/items?page=3")
    expect(rendered).to have_text("Mostrando registros 26–50 de 60.")
  end

  it "preserva filtros aninhados recebidos na request permitida" do
    pagy = build_pagy(
      count: 60,
      params: { "filter" => { "query" => "conta azul", "status" => "active" } }
    )

    render partial: "shared/pagination", locals: { pagy: pagy }

    next_link = Capybara.string(rendered).find_link("Próxima")[:href]
    query = Rack::Utils.parse_nested_query(URI.parse(next_link).query)

    expect(query).to include(
      "page" => "2",
      "filter" => { "query" => "conta azul", "status" => "active" }
    )
  end

  it "mantém informação textual e omite nav quando há uma página" do
    pagy = build_pagy(count: 1)

    render partial: "shared/pagination", locals: { pagy: pagy }

    expect(rendered).to have_css("[data-ui='pagination']", text: "Mostrando 1 registro.")
    expect(rendered).to have_no_css("nav")
  end

  it "não produz HTML quando pagy é nulo" do
    render partial: "shared/pagination", locals: { pagy: nil }

    expect(rendered.strip).to be_empty
  end
end

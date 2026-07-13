require "rails_helper"

RSpec.describe "Paginação e filtros", type: :system do
  let(:path) { "/__test__/pagination" }

  it "navega por links preservando filtros na URL" do
    visit "#{path}?filter%5Bquery%5D=conta+azul"

    click_link "Próxima"

    expect(page).to have_css("[data-page='2']")
    query = Rack::Utils.parse_nested_query(URI.parse(page.current_url).query)
    expect(query).to include("page" => "2", "filter" => { "query" => "conta azul" })
  end

  it "oferece sequência de teclado e foco visível nos links" do
    visit path

    12.times do
      page.find("body").send_keys(:tab)
      break if page.evaluate_script("document.activeElement.closest('.pagy') !== null")
    end

    expect(page.evaluate_script("document.activeElement.closest('.pagy') !== null")).to be(true)
    focus_style = page.evaluate_script(<<~JAVASCRIPT)
      (() => {
        const style = getComputedStyle(document.activeElement);
        return { width: style.outlineWidth, style: style.outlineStyle };
      })()
    JAVASCRIPT
    expect(focus_style.fetch("style")).not_to eq("none")
    expect(focus_style.fetch("width")).not_to eq("0px")
  end

  it "não cria overflow horizontal em 360 px" do
    page.current_window.resize_to(360, 800)
    visit path

    has_overflow = page.evaluate_script(
      "document.documentElement.scrollWidth > document.documentElement.clientWidth"
    )

    expect(has_overflow).to be(false)
  end

  it "remove a página anterior ao aplicar um novo filtro" do
    visit "#{path}?page=2&filter%5Bquery%5D=antigo"

    fill_in "Busca", with: "novo"
    click_button "Filtrar"

    expect(page).to have_css("[data-page='1']")
    expect(page).to have_field("Busca", with: "novo")
    query = Rack::Utils.parse_nested_query(URI.parse(page.current_url).query)
    expect(query.fetch("filter")).to include("query" => "novo")
    expect(query).not_to have_key("page")
  end
end

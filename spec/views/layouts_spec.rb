require "rails_helper"

RSpec.describe "Layouts da aplicação", type: :view do
  before do
    view.singleton_class.define_method(:authenticated?) { false }
  end

  %w[application public platform tenant print].each do |layout_name|
    it "renderiza #{layout_name} sem autenticação ou tenant" do
      render inline: "<h1>Conteúdo de teste</h1>", layout: "layouts/#{layout_name}"

      document = Capybara.string(rendered)

      expect(document).to have_css("html[lang='pt-BR']")
      expect(document).to have_css("main#main-content", count: 1)
      expect(document).to have_css("h1", text: "Conteúdo de teste")
    end
  end

  it "mantém navegação fora do layout de impressão" do
    render inline: "<h1>Conteúdo de teste</h1>", layout: "layouts/print"

    expect(rendered).to have_no_css("nav")
    expect(rendered).to have_no_css(".no-print")
  end
end

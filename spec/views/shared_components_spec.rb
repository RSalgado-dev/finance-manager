require "rails_helper"

RSpec.describe "Elementos visuais compartilhados", type: :view do
  let(:form_object_class) do
    Class.new do
      include ActiveModel::Model

      attr_accessor :name

      validates :name, presence: true

      def self.name
        "ExampleForm"
      end
    end
  end

  it "renderiza flash com rótulo, papel e conteúdo sanitizado" do
    flash[:alert] = "Falha <script>indesejada</script>"

    render partial: "shared/flash_messages"

    expect(rendered).to have_css("[role='alert']", text: /Erro:\s+Falha indesejada/)
    expect(rendered).to have_no_css("script")
  end

  it "renderiza cabeçalho com descrição e ações opcionais" do
    render partial: "shared/page_header", locals: {
      title: "Título da página",
      description: "Descrição da página",
      actions: view.tag.button("Ação", type: "button")
    }

    expect(rendered).to have_css("h1", text: "Título da página")
    expect(rendered).to have_text("Descrição da página")
    expect(rendered).to have_button("Ação")
  end

  it "renderiza tabela semântica e estado vazio" do
    render partial: "shared/table", locals: {
      caption: "Pessoas",
      headers: [ "Nome", "Situação" ],
      rows: [],
      empty_message: "Nenhuma pessoa encontrada."
    }

    expect(rendered).to have_css("table caption", text: "Pessoas", visible: :all)
    expect(rendered).to have_css("th[scope='col']", count: 2)
    expect(rendered).to have_css("td[colspan='2']", text: "Nenhuma pessoa encontrada.")
  end

  it "apresenta erros de um objeto Active Model" do
    object = form_object_class.new
    object.validate

    render partial: "shared/form_errors", locals: { object: object, id: "example-errors" }

    expect(rendered).to have_css("section#example-errors[role='alert']")
    expect(rendered).to have_css("h2", text: "Não foi possível salvar: 1 erro encontrado.")
    expect(rendered).to have_css("li", text: "não pode ficar em branco")
  end
end

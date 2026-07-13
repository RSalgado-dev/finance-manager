require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#flash_presentation" do
    it "mapeia mensagens Rails para rótulo e papel semântico" do
      expect(helper.flash_presentation(:notice)).to include(label: "Sucesso", role: "status")
      expect(helper.flash_presentation(:alert)).to include(label: "Erro", role: "alert")
      expect(helper.flash_presentation(:warning)).to include(label: "Aviso", role: "alert")
      expect(helper.flash_presentation(:info)).to include(label: "Informação", role: "status")
    end

    it "trata tipos desconhecidos como informação" do
      expect(helper.flash_presentation(:custom)).to include(label: "Informação", role: "status")
    end
  end

  describe "#button_classes" do
    it "retorna variantes explícitas e estado desabilitado" do
      expect(helper.button_classes(variant: :primary)).to include("ui-button--primary")
      expect(helper.button_classes(variant: :destructive, disabled: true)).to include("ui-button--destructive", "ui-button--disabled")
    end

    it "rejeita variantes desconhecidas" do
      expect { helper.button_classes(variant: :unknown) }.to raise_error(ArgumentError)
    end
  end

  describe "#status_badge" do
    it "sempre renderiza um rótulo textual" do
      badge = Capybara.string(helper.status_badge("Pendente", tone: :warning))

      expect(badge).to have_css("[data-ui='status-badge']", text: "Pendente")
      expect { helper.status_badge("", tone: :warning) }.to raise_error(ArgumentError)
    end
  end

  describe "#form_error_summary" do
    it "apresenta singular e plural em português" do
      expect(helper.form_error_summary(1)).to eq("Não foi possível salvar: 1 erro encontrado.")
      expect(helper.form_error_summary(2)).to eq("Não foi possível salvar: 2 erros encontrados.")
    end
  end

  describe "#filter_form_with" do
    it "renderiza formulário GET aninhado com ações explícitas e sem página" do
      html = helper.filter_form_with(url: "/items", clear_url: "/items") do |form|
        helper.safe_join([
          form.label(:query, "Busca"),
          form.search_field(:query)
        ])
      end
      document = Capybara.string(html)

      expect(document).to have_css("form[action='/items'][method='get'][role='search']")
      expect(document).to have_css("label[for='filter_query']", text: "Busca")
      expect(document).to have_field("filter[query]")
      expect(document).to have_button("Filtrar")
      expect(document).to have_link("Limpar filtros", href: "/items")
      expect(document).to have_no_field("page", type: :hidden)
    end

    it "preserva classes fornecidas sem permitir troca do método ou escopo" do
      html = helper.filter_form_with(
        url: "/items",
        clear_url: "/items",
        class: "custom-filter",
        method: :post,
        role: "form"
      ) { |form| form.text_field(:status) }
      document = Capybara.string(html)

      expect(document).to have_css("form.filter-form.custom-filter[method='get'][role='search']")
      expect(document).to have_field("filter[status]")
    end
  end
end

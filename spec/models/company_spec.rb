require "rails_helper"

RSpec.describe Company do
  describe "estrutura e defaults" do
    subject(:company) { create(:company) }

    it "gera UUID no banco" do
      expect(company.id).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
    end

    it "aplica os defaults normativos" do
      expect(company).to have_attributes(
        active: true,
        timezone: "America/Sao_Paulo",
        currency: "BRL",
        cash_difference_tolerance_cents: 0
      )
    end

    it "aceita os campos opcionais ausentes" do
      expect(company).to have_attributes(legal_name: nil, document: nil, suspended_at: nil)
    end
  end

  describe "nome e campos opcionais" do
    it "exige nome não vazio" do
      expect(build(:company, name: nil)).not_to be_valid
      expect(build(:company, name: "   ")).not_to be_valid
    end

    it "remove espaços externos sem alterar capitalização" do
      company = create(:company, name: "  Minha Empresa  ")

      expect(company.name).to eq("Minha Empresa")
    end

    it "não exige unicidade do nome" do
      create(:company, name: "Nome repetido")

      expect(build(:company, name: "Nome repetido")).to be_valid
    end

    it "normaliza vazios opcionais para nil e preserva seu conteúdo" do
      company = create(
        :company,
        legal_name: "  Empresa Exemplo Ltda.  ",
        document: "  12.345.678/0001-90  "
      )

      expect(company).to have_attributes(
        legal_name: "Empresa Exemplo Ltda.",
        document: "12.345.678/0001-90"
      )
      expect(build(:company, legal_name: " ", document: " ")).to have_attributes(
        legal_name: nil,
        document: nil
      )
    end
  end

  describe "slug" do
    it "exige slug" do
      expect(build(:company, slug: nil)).not_to be_valid
      expect(build(:company, slug: "   ")).not_to be_valid
    end

    it "remove espaços externos e normaliza para lowercase" do
      company = create(:company, slug: "  Empresa-Exemplo  ")

      expect(company.slug).to eq("empresa-exemplo")
    end

    it "aceita letras ASCII minúsculas, números e hífens simples" do
      expect(build(:company, slug: "empresa-exemplo-2")).to be_valid
    end

    it "rejeita formatos inadequados para URL" do
      invalid_slugs = [ "empresa exemplo", "empresa_exemplo", "-empresa", "empresa-", "empresa--exemplo" ]

      invalid_slugs.each do |slug|
        expect(build(:company, slug: slug)).not_to be_valid, "esperava #{slug.inspect} inválido"
      end
    end

    it "impede duplicidade sem diferenciar caixa" do
      create(:company, slug: "empresa-unica")

      expect(build(:company, slug: "EMPRESA-UNICA")).not_to be_valid
    end

    it "não altera o slug quando o nome muda" do
      company = create(:company, name: "Nome inicial", slug: "slug-estavel")

      company.update!(name: "Outro nome")

      expect(company.reload.slug).to eq("slug-estavel")
    end
  end

  describe "timezone" do
    it "aceita identificadores IANA válidos" do
      expect(build(:company, timezone: "America/Sao_Paulo")).to be_valid
      expect(build(:company, timezone: "Europe/Lisbon")).to be_valid
    end

    it "rejeita identificador inexistente e valor vazio" do
      expect(build(:company, timezone: "Invalid/Nowhere")).not_to be_valid
      expect(build(:company, timezone: " ")).not_to be_valid
    end
  end

  describe "moeda" do
    it "normaliza BRL para uppercase" do
      expect(build(:company, currency: " brl ").currency).to eq("BRL")
    end

    it "rejeita moeda não suportada e valor vazio" do
      expect(build(:company, currency: "USD")).not_to be_valid
      expect(build(:company, currency: " ")).not_to be_valid
    end
  end

  describe "tolerância de caixa" do
    it "aceita zero e inteiro positivo" do
      expect(build(:company, cash_difference_tolerance_cents: 0)).to be_valid
      expect(build(:company, cash_difference_tolerance_cents: 1_500)).to be_valid
    end

    it "rejeita negativo e valor não inteiro" do
      expect(build(:company, cash_difference_tolerance_cents: -1)).not_to be_valid
      expect(build(:company, cash_difference_tolerance_cents: "1.5")).not_to be_valid
    end
  end
end

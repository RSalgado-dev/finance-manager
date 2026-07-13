require "rails_helper"

RSpec.describe Company, "constraints do banco" do
  def insert_company(overrides = {})
    attributes = {
      name: "Empresa via SQL",
      slug: "empresa-via-sql-#{SecureRandom.hex(4)}",
      timezone: "America/Sao_Paulo",
      currency: "BRL",
      cash_difference_tolerance_cents: 0,
      active: true
    }.merge(overrides)

    described_class.insert_all!([ attributes ])
  end

  it "rejeita name nulo ou vazio ignorando validações Rails" do
    expect { insert_company(name: nil) }.to raise_error(ActiveRecord::StatementInvalid)
    expect { insert_company(name: "   ") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita slug nulo ou fora do formato" do
    expect { insert_company(slug: nil) }.to raise_error(ActiveRecord::StatementInvalid)
    expect { insert_company(slug: "empresa--invalida") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita slug duplicado com diferença apenas de caixa" do
    insert_company(slug: "empresa-case-insensitive")

    expect do
      insert_company(slug: "EMPRESA-CASE-INSENSITIVE")
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "mantém índice funcional único em lower(slug)" do
    index = described_class.connection.indexes(:companies).find do |candidate|
      candidate.name == "index_companies_on_lower_slug"
    end

    expect(index.unique).to be(true)
    expect(index.columns).to include("lower")
  end

  it "rejeita timezone nulo ou vazio" do
    expect { insert_company(timezone: nil) }.to raise_error(ActiveRecord::StatementInvalid)
    expect { insert_company(timezone: " ") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita currency nula ou não suportada" do
    expect { insert_company(currency: nil) }.to raise_error(ActiveRecord::StatementInvalid)
    expect { insert_company(currency: "USD") }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita tolerância negativa" do
    expect do
      insert_company(cash_difference_tolerance_cents: -1)
    end.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "rejeita active nulo" do
    expect { insert_company(active: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "expõe os checks com nomes estáveis" do
    names = described_class.connection.check_constraints(:companies).map(&:name)

    expect(names).to include(
      "companies_name_not_blank",
      "companies_slug_format",
      "companies_timezone_not_blank",
      "companies_currency_supported",
      "companies_tolerance_non_negative"
    )
  end
end

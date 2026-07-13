class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :name, null: false
      t.string :legal_name
      t.string :slug, null: false
      t.string :document
      t.string :timezone, null: false, default: "America/Sao_Paulo"
      t.string :currency, null: false, default: "BRL"
      t.bigint :cash_difference_tolerance_cents, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.datetime :suspended_at

      t.timestamps
    end

    add_index :companies, "lower(slug)", unique: true, name: "index_companies_on_lower_slug"

    add_check_constraint :companies, "btrim(name) <> ''", name: "companies_name_not_blank"
    add_check_constraint :companies,
      "slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'",
      name: "companies_slug_format"
    add_check_constraint :companies, "btrim(timezone) <> ''", name: "companies_timezone_not_blank"
    add_check_constraint :companies, "currency = 'BRL'", name: "companies_currency_supported"
    add_check_constraint :companies,
      "cash_difference_tolerance_cents >= 0",
      name: "companies_tolerance_non_negative"
  end
end

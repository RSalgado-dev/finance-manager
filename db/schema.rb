# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_13_013500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "cash_difference_tolerance_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "BRL", null: false
    t.string "document"
    t.string "legal_name"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "suspended_at"
    t.string "timezone", default: "America/Sao_Paulo", null: false
    t.datetime "updated_at", null: false
    t.index "lower((slug)::text)", name: "index_companies_on_lower_slug", unique: true
    t.check_constraint "btrim(name::text) <> ''::text", name: "companies_name_not_blank"
    t.check_constraint "btrim(timezone::text) <> ''::text", name: "companies_timezone_not_blank"
    t.check_constraint "cash_difference_tolerance_cents >= 0", name: "companies_tolerance_non_negative"
    t.check_constraint "currency::text = 'BRL'::text", name: "companies_currency_supported"
    t.check_constraint "slug::text ~ '^[a-z0-9]+(-[a-z0-9]+)*$'::text", name: "companies_slug_format"
  end
end

# frozen_string_literal: true

require "pagy"

Pagy::OPTIONS[:limit] = 25
Pagy::OPTIONS[:page_key] = "page"
Pagy::OPTIONS[:limit_key] = "limit"

Pagy.translate_with_the_slower_i18n_gem!
I18n.load_path << Rails.root.join("config/locales/pagy.pt-BR.yml")

Pagy::OPTIONS.freeze

module ApplicationHelper
  FLASH_PRESENTATIONS = {
    "success" => { label: "Sucesso", role: "status", classes: "flash-message--success" },
    "notice" => { label: "Sucesso", role: "status", classes: "flash-message--success" },
    "warning" => { label: "Aviso", role: "alert", classes: "flash-message--warning" },
    "error" => { label: "Erro", role: "alert", classes: "flash-message--error" },
    "alert" => { label: "Erro", role: "alert", classes: "flash-message--error" },
    "information" => { label: "Informação", role: "status", classes: "flash-message--information" },
    "info" => { label: "Informação", role: "status", classes: "flash-message--information" }
  }.freeze

  BUTTON_VARIANTS = {
    primary: "ui-button--primary",
    secondary: "ui-button--secondary",
    neutral: "ui-button--neutral",
    destructive: "ui-button--destructive"
  }.freeze

  BADGE_TONES = {
    neutral: "status-badge--neutral",
    success: "status-badge--success",
    warning: "status-badge--warning",
    error: "status-badge--error",
    information: "status-badge--information"
  }.freeze

  def page_title
    [ content_for(:title), "Finance Manager" ].compact_blank.join(" — ")
  end

  def flash_presentation(type)
    FLASH_PRESENTATIONS.fetch(type.to_s, FLASH_PRESENTATIONS.fetch("information"))
  end

  def button_classes(variant: :primary, disabled: false)
    variant_class = BUTTON_VARIANTS.fetch(variant.to_sym) do
      raise ArgumentError, "unknown button variant: #{variant}"
    end

    class_names("ui-button", variant_class, "ui-button--disabled": disabled)
  end

  def status_badge(label, tone: :neutral)
    raise ArgumentError, "badge label cannot be blank" if label.blank?

    tone_class = BADGE_TONES.fetch(tone.to_sym) do
      raise ArgumentError, "unknown badge tone: #{tone}"
    end

    tag.span(label, class: class_names("status-badge", tone_class), data: { ui: "status-badge" })
  end

  def form_error_summary(count)
    if count == 1
      "Não foi possível salvar: 1 erro encontrado."
    else
      "Não foi possível salvar: #{count} erros encontrados."
    end
  end

  def filter_form_with(url:, clear_url:, **options, &block)
    html_options = options.fetch(:html, {}).merge(role: "search")
    form_options = options.merge(
      url: url,
      scope: :filter,
      method: :get,
      class: class_names("filter-form", options[:class]),
      html: html_options
    )
    form_options.delete(:role)

    form_with(**form_options) do |form|
      actions = tag.div(class: "filter-form__actions no-print") do
        safe_join([
          form.submit("Filtrar", class: button_classes(variant: :primary)),
          link_to("Limpar filtros", clear_url, class: button_classes(variant: :neutral))
        ])
      end

      safe_join([ capture(form, &block), actions ])
    end
  end
end

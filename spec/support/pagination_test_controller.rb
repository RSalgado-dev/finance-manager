class PaginationTestController < ApplicationController
  allow_unauthenticated_access

  RECORDS = (1..60).to_a.freeze

  TEMPLATE = <<~ERB
    <% content_for :title, "Paginação de teste" %>

    <%= filter_form_with url: "/__test__/pagination", clear_url: "/__test__/pagination" do |form| %>
      <div>
        <%= form.label :query, "Busca", class: "form-label" %>
        <%= form.search_field :query, value: params.dig(:filter, :query), class: "form-input" %>
      </div>
      <div>
        <%= form.label :status, "Situação", class: "form-label" %>
        <%= form.select :status,
                        [["Todas", ""], ["Ativa", "active"]],
                        { selected: params.dig(:filter, :status) },
                        class: "form-input" %>
      </div>
    <% end %>

    <section aria-label="Registros de teste"
             data-page="<%= @pagy.page %>"
             data-limit="<%= @pagy.limit %>"
             data-count="<%= @pagy.count %>"
             data-pages="<%= @pagy.pages %>">
      <% @records.each do |record| %>
        <p data-record="<%= record %>">Registro <%= record %></p>
      <% end %>
    </section>

    <%= render "shared/pagination", pagy: @pagy %>
  ERB

  def index
    @pagy, @records = pagy(
      :offset,
      RECORDS,
      request: pagination_request(pagination_params)
    )
    @records ||= []

    render inline: TEMPLATE, layout: "tenant"
  end

  private

  def pagination_params
    params.permit(:page, :sort, :direction, filter: %i[query status])
  end
end

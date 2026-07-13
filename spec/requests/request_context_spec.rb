require "rails_helper"

RSpec.describe "Contexto de request", type: :request do
  let(:attribute_names) { %i[user company membership request_id ip_address user_agent] }

  after do
    Current.reset
    RequestContextTestController.observed_context = nil
  end

  it "preenche somente metadados HTTP durante a action e limpa ao final" do
    get "/__test__/request_context", headers: request_headers(
      request_id: "request-one",
      ip_address: "192.0.2.10",
      user_agent: "Request context spec"
    )

    expect(response).to have_http_status(:no_content)
    expect(RequestContextTestController.observed_context).to eq(
      user: nil,
      company: nil,
      membership: nil,
      request_id: "request-one",
      ip_address: "192.0.2.10",
      user_agent: "Request context spec"
    )
    expect(current_values).to all(be_nil)
  end

  it "não herda valores entre duas requests sequenciais" do
    get "/__test__/request_context", headers: request_headers(
      request_id: "request-one",
      ip_address: "192.0.2.10",
      user_agent: "First request"
    )

    first_context = RequestContextTestController.observed_context

    get "/__test__/request_context", headers: request_headers(
      request_id: "request-two",
      ip_address: "198.51.100.20",
      user_agent: "Second request"
    )

    expect(first_context).to include(request_id: "request-one", ip_address: "192.0.2.10", user_agent: "First request")
    expect(RequestContextTestController.observed_context).to eq(
      user: nil,
      company: nil,
      membership: nil,
      request_id: "request-two",
      ip_address: "198.51.100.20",
      user_agent: "Second request"
    )
    expect(current_values).to all(be_nil)
  end

  it "limpa o contexto quando a action gera uma exceção" do
    expect do
      get "/__test__/request_context/failure", headers: request_headers(
        request_id: "failed-request",
        ip_address: "203.0.113.30",
        user_agent: "Failed request"
      )
    end.to raise_error(RuntimeError, "falha controlada no contexto de request")

    expect(RequestContextTestController.observed_context).to include(
      request_id: "failed-request",
      ip_address: "203.0.113.30",
      user_agent: "Failed request"
    )
    expect(current_values).to all(be_nil)
  end

  private

  def current_values
    attribute_names.map { |attribute| Current.public_send(attribute) }
  end

  def request_headers(request_id:, ip_address:, user_agent:)
    {
      "X-Request-Id" => request_id,
      "REMOTE_ADDR" => ip_address,
      "User-Agent" => user_agent
    }
  end
end

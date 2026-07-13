require "rails_helper"

RSpec.describe Current do
  subject(:current) { described_class }

  let(:attribute_names) { %i[user company membership request_id ip_address user_agent] }

  after { current.reset }

  it "inicia com todos os atributos nulos" do
    expect(attribute_names.index_with { |attribute| current.public_send(attribute) }).to eq(
      attribute_names.index_with { nil }
    )
  end

  it "atribui e lê todos os atributos sem depender de models de domínio" do
    values = {
      user: Object.new,
      company: Object.new,
      membership: Object.new,
      request_id: "request-123",
      ip_address: "192.0.2.10",
      user_agent: "Current spec"
    }

    values.each { |attribute, value| current.public_send("#{attribute}=", value) }

    expect(current.attributes).to eq(values)
  end

  it "remove todos os valores no reset" do
    current.user = Object.new
    current.company = Object.new
    current.membership = Object.new
    current.request_id = "request-123"
    current.ip_address = "192.0.2.10"
    current.user_agent = "Current spec"

    current.reset

    expect(attribute_names.map { |attribute| current.public_send(attribute) }).to all(be_nil)
  end

  it "limita valores ao bloco Current.set e restaura o contexto anterior" do
    current.request_id = "outer-request"
    user = Object.new

    current.set(request_id: "inner-request", user: user) do
      expect(current.request_id).to eq("inner-request")
      expect(current.user).to be(user)
    end

    expect(current.request_id).to eq("outer-request")
    expect(current.user).to be_nil
  end

  it "restaura o contexto quando Current.set recebe uma exceção" do
    current.request_id = "outer-request"

    expect do
      current.set(request_id: "inner-request") { raise "falha controlada" }
    end.to raise_error(RuntimeError, "falha controlada")

    expect(current.request_id).to eq("outer-request")
  end

  it "isola valores entre threads e mantém o contexto principal limpo" do
    ready = Queue.new
    release = Queue.new
    results = Queue.new

    threads = %w[request-a request-b].map do |request_id|
      Thread.new do
        observed = nil

        current.set(request_id: request_id) do
          ready << true
          release.pop
          observed = current.request_id
        end

        results << [ request_id, observed, current.request_id ]
      end
    end

    2.times { ready.pop }
    expect(current.request_id).to be_nil

    2.times { release << true }
    threads.each(&:join)

    expect(2.times.map { results.pop }).to contain_exactly(
      [ "request-a", "request-a", nil ],
      [ "request-b", "request-b", nil ]
    )
    expect(current.request_id).to be_nil
  end
end

require "rails_helper"

RSpec.describe "Health check", type: :request do
  it "confirma que a aplicação inicializa" do
    get "/up"

    expect(response).to have_http_status(:ok)
  end
end

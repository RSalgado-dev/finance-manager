require "rails_helper"

RSpec.describe Authentication, type: :controller do
  controller(ApplicationController) do
    include Authentication
  end

  it "configura cookie httponly, lax e secure somente em produção" do
    expect(controller.send(:authentication_cookie_options)).to eq(
      httponly: true,
      same_site: :lax,
      secure: false
    )

    allow(Rails).to receive(:env).and_return(ActiveSupport::EnvironmentInquirer.new("production"))

    expect(controller.send(:authentication_cookie_options)).to include(secure: true)
  end

  it "aceita somente caminhos locais seguros" do
    expect(controller.send(:safe_local_path, "/area?tab=1")).to eq("/area?tab=1")
    expect(controller.send(:safe_local_path, "//evil.example/path")).to be_nil
    expect(controller.send(:safe_local_path, "https://evil.example/path")).to be_nil
    expect(controller.send(:safe_local_path, "not-a-path")).to be_nil
  end
end

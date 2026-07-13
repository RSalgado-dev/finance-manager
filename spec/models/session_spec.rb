require "rails_helper"

RSpec.describe Session do
  it "gera UUID, pertence a User e não possui company_id" do
    authentication_session = create(:session)

    expect(authentication_session.id).to match(/\A[0-9a-f-]{36}\z/i)
    expect(authentication_session.user).to be_a(User)
    expect(authentication_session).not_to respond_to(:company_id)
  end

  it "exige User" do
    expect(build(:session, user: nil)).not_to be_valid
  end

  it "aceita IP e user agent opcionais" do
    expect(build(:session, ip_address: nil, user_agent: nil)).to be_valid
  end

  it "é removida quando User é destruído pelo model" do
    authentication_session = create(:session)

    expect { authentication_session.user.destroy! }.to change(described_class, :count).by(-1)
  end
end

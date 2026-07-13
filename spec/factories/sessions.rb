FactoryBot.define do
  factory :session do
    association :user
    ip_address { "192.0.2.10" }
    user_agent { "RSpec authentication client" }
  end
end

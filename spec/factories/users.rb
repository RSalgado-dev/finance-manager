FactoryBot.define do
  factory :user do
    sequence(:name) { |number| "Usuário #{number}" }
    sequence(:email) { |number| "usuario-#{number}@example.test" }
    password { "secure-password-123" }
    password_confirmation { password }

    trait :platform_admin do
      system_role { "platform_admin" }
    end

    trait :inactive do
      active { false }
    end
  end
end

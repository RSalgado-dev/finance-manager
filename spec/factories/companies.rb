FactoryBot.define do
  factory :company do
    sequence(:name) { |number| "Empresa #{number}" }
    sequence(:slug) { |number| "empresa-#{number}" }
  end
end

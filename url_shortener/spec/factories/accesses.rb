FactoryBot.define do
  factory :access do
    accessed_at { Faker::Time.backward(days: 30, period: :all) }
    url
  end
end

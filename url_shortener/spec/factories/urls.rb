FactoryBot.define do
  factory :url do
    original_url { Faker::Internet.url }
    short_url { SecureRandom.alphanumeric(8) }
    access_count { 1 }
    expiration_date { Date.today + rand(10..365) }
  end
end

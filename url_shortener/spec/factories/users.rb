# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'testuser@example.com' }
    password { 'password123' }
    password_confirmation { 'password123' }

    after(:build) do |user|
      user.password_digest = BCrypt::Password.create(user.password)
    end
  end
end

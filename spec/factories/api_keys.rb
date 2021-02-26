# frozen_string_literal: true

FactoryBot.define do
  factory :api_key, class: 'ApiKey' do
    association :user

    access_token { SecureRandom.hex }
    expires_at { 7.weeks.from_now }
  end
end

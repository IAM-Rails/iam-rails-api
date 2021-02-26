# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :user, class: 'User' do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    password_confirmation { password }

    trait :with_api_key do
      after :create do |user|
        create(:api_key, user: user)
      end
    end
  end
end

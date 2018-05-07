# frozen_string_literal: true

FactoryBot.define do
  factory :authentication do
    user

    trait :github do
      provider :github
      uid { Faker::Number.number(10) }
    end
  end
end

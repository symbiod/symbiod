# frozen_string_literal: true

FactoryBot.define do
  factory :stack do
    name { Faker::App.author }
    identifier { Faker::Internet.slug }

    trait :rails_monolith do
      identifier 'rails_monolith'
    end
  end
end

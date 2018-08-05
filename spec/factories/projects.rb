# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    slug { Faker::Internet.slug(name, '_') }
    idea
    stack
  end
end

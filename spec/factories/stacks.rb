# frozen_string_literal: true

FactoryBot.define do
  factory :stack do
    name { Faker::App.author }
    identifier { Faker::App.name }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :developer_test_task, class: 'Developer::TestTask' do
    title { Faker::VForVendetta.quote }
    position { Faker::Number.between(1, 2) }
    description { Faker::VForVendetta.speech }
  end
end

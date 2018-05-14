# frozen_string_literal: true

FactoryBot.define do
  factory :developer_test_task, class: 'Developer::TestTask' do
    title { Faker::VForVendetta.quote }
    description { Faker::VForVendetta.speech }
  end
end
